using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using FunctionApp.ZIP.Helper;

namespace FunctionApp.ZIP
{
    public static class TriggerHTTP
    {
        [FunctionName("TriggerHTTP")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            IBinder binder,            
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            try
            {
                //NB: add validation string.isnullorempty
                string xmlName = (String.IsNullOrEmpty(req.Query["xmlName"])) ? throw new Exception("Request parameters xmlName not Found.") : req.Query["xmlName"];
                string pdfName = (String.IsNullOrEmpty(req.Query["pdfName"])) ? throw new Exception("Request parameters pdfName not Found.") : req.Query["pdfName"];

                log.LogInformation($"BlobInput processed blob\n Name:{xmlName} \n Size: {xmlName.Length} bytes");
                log.LogInformation($"BlobInput processed blob\n Name:{pdfName} \n Size: {pdfName.Length} bytes");

                var blobHelper = new BlobHelper(binder);
                var zipHelper = new ZipHelper(binder);

                var blobNames = new List<string>() { $"{xmlName}", $"{pdfName}" };

                //retrieve blobNames incl. name change
                var blobs = blobHelper.RetrieveBlobsFromContainer(blobNames);

                //zip blobs
                var blobPath = zipHelper.CreateZipFile(blobs);

                return blobPath != null ? (ActionResult)new OkObjectResult($"{blobPath}") : new ContentResult
                {
                    StatusCode = 500,
                    Content = "Something went wrong"
                };
            }
            catch (Exception ex)
            {
                log.LogError(ex, $"An error occured");
                throw;
            }

        }
    }
}
