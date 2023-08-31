# bicep-email-communication-service

Setup and leverage the Azure Communication Service to send emails.

I was inspired to this project by the following 2 articles:

- <https://medienstudio.net/development-en/deploying-azure-email-communication-service-with-bicep/>
- <https://learn.microsoft.com/de-de/azure/communication-services/quickstarts/email/send-email?tabs=windows%2Cconnection-string&pivots=programming-language-csharp>

**quickstart**

```powershell
cd EmailQuickstart
setx COMMUNICATION_SERVICES_CONNECTION_STRING="<yourConnectionString>"
dotnet run
```

## Setting up the Azure Communication Service

You just run the file `email.bicep` against your Azure Subscription.

If the infrastructure is set up completely, you just need to add your domain configuration and let Azure verify it.

After that you are ready for the next step.

## Sending Emails with Azure Communication Services in .NET

Modern applications often require the capability to send transactional and marketing emails to users. Azure Communication Services provides a robust platform for enabling email communication within your applications. In this article, we'll explore how to send emails using Azure Communication Services in a .NET application while effectively managing sensitive information using DotNetEnv.

---

**Step 1: Setting Up Your Environment**

Before you dive into coding, it's important to ensure your development environment is set up correctly. Make sure you have the necessary .NET SDK and Visual Studio Code installed. Additionally, have an active Azure subscription to access Azure Communication Services.

**Step 2: Integrating DotNetEnv**

Sensitive information, such as connection strings and credentials, should never be hardcoded in your source code. DotNetEnv allows you to securely manage these values in a `.env` file. First, install the `DotNetEnv` package using the following command in your project directory:

```bash
dotnet add package DotNetEnv
```

Load the environment variables in your code:

```csharp
using DotNetEnv;

namespace SendEmail
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            Env.Load();

            // Fetch your connection string from an environment variable
            string connectionString = Environment.GetEnvironmentVariable("COMMUNICATION_SERVICES_CONNECTION_STRING");
        }
    }
}
```

**Step 3: Sending Emails with Azure Communication Services**

Azure Communication Services simplifies email communication by providing the `EmailClient` class. Here's how to use it to send emails:

```csharp
using Azure;
using Azure.Communication.Email;

// ... (previous code)

static async Task Main(string[] args)
{
    // ... (previous code)

    EmailClient emailClient = new EmailClient(connectionString);

    // Set up email content and details
    var subject = "Welcome to Azure Communication Service Email APIs.";
    var htmlContent = "<html><body>...</body></html>";
    var sender = "donotreply@mydomain.com";
    var recipient = "me@mydomain.com";

    try
    {
        // Sending the email
        EmailSendOperation emailSendOperation = await emailClient.SendAsync(
            Azure.WaitUntil.Completed,
            sender,
            recipient,
            subject,
            htmlContent);

        // ... (error handling)
    }
    catch (RequestFailedException ex)
    {
        // ... (error handling)
    }
}
```

**Conclusion**

In this article, we've seen how to send emails using Azure Communication Services in a .NET application. By integrating DotNetEnv, you've learned how to manage sensitive information securely using environment variables. This approach enhances the maintainability and security of your application by keeping confidential data separate from your source code.

By following these steps, you can seamlessly incorporate email communication into your applications, leveraging the power of Azure Communication Services while adhering to best practices for security and code organization.

---

This article covered the process of sending emails using Azure Communication Services in a .NET application and managing environment variables using DotNetEnv. It's important to adapt the code and instructions to your specific use case and ensure that your environment is properly set up before starting the development process.
