using DotNetEnv;
using Azure;
using Azure.Communication.Email;

namespace SendEmail
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            Env.Load(); // Lade die Umgebungsvariablen aus der .env-Datei

            // This code demonstrates how to fetch your connection string
            // from an environment variable.
            string connectionString = Environment.GetEnvironmentVariable("COMMUNICATION_SERVICES_CONNECTION_STRING");
            Console.WriteLine($"Connectionstring={connectionString}");
            EmailClient emailClient = new EmailClient(connectionString);

            //Replace with your domain and modify the content, recipient details as required

            var subject = "Welcome to Azure Communication Service Email APIs.";
            var htmlContent = "<html><body><h1>Quick send email test</h1><br/><h4>This email message is sent from Azure Communication Service Email.</h4><p>This mail was sent using .NET SDK!!</p></body></html>";
            var sender = "donotreply@mydomain.com";
            var recipient = "me@mydomain.com";

            try
            {
                Console.WriteLine("Sending email...");
                EmailSendOperation emailSendOperation = await emailClient.SendAsync(
                    Azure.WaitUntil.Completed,
                    sender,
                    recipient,
                    subject,
                    htmlContent);
                EmailSendResult statusMonitor = emailSendOperation.Value;

                Console.WriteLine($"Email Sent. Status = {emailSendOperation.Value.Status}");

                /// Get the OperationId so that it can be used for tracking the message for troubleshooting
                string operationId = emailSendOperation.Id;
                Console.WriteLine($"Email operation id = {operationId}");
            }
            catch (RequestFailedException ex)
            {
                /// OperationID is contained in the exception message and can be used for troubleshooting purposes
                Console.WriteLine($"Email send operation failed with error code: {ex.ErrorCode}, message: {ex.Message}");
            }
        }
    }
}