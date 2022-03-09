using System.Collections.Generic;
using Microsoft.Azure.Storage.Blob;
using Microsoft.Azure.WebJobs;
using System.IO;
using FunctionApp.ZIP.Model;

namespace FunctionApp.ZIP.Helper
{
    public class BlobHelper
    {
        private readonly IBinder _binder;

        public BlobHelper(IBinder binder)
        {
            _binder = binder;
        }
        public List<OutputBlob> RetrieveBlobsFromContainer(List<string> blobNames)
        {            
            var blobs = CollectBlobs(blobNames);            
            var outputBlobs = ChangeBlobNames(blobs);

            return outputBlobs;
        }

        private List<CloudBlockBlob> CollectBlobs(List<string> blobNames)
        {
            List<CloudBlockBlob> blobs = new List<CloudBlockBlob>();

            foreach (var file in blobNames)
            {
                var blob = _binder.Bind<CloudBlockBlob>(new BlobAttribute(blobPath: $"{file}")
                {
                    Connection = "AzureWebJobsStorage"
                });

                blobs.Add(blob);
            }
            return blobs;
        }

        private List<OutputBlob> ChangeBlobNames(List<CloudBlockBlob> blobs)
        {
            var ouputBlobs = new List<OutputBlob>();
            foreach (CloudBlockBlob blob in blobs)
            {
                ouputBlobs.Add(ChangeBlobName(blob));
            }
            return ouputBlobs;
        }
        private OutputBlob ChangeBlobName(CloudBlockBlob blob)
        {
            var outputBlob = new OutputBlob();
            var extension = "";
            extension = Path.GetExtension(blob.Name);
            switch (extension)
            {
                case ".xml":
                    outputBlob = new OutputBlob { OutputName = $@"ChangeBlobName.xml", Blob = blob };
                    break;
                case ".pdf":
                    outputBlob = new OutputBlob { OutputName = $@"This\Way\for\subfolder\{blob.Name}", Blob = blob };
                    break;
                default:
                    break;
            }
            return outputBlob;
        }

        private OutputBlob ChangeTemplateBlobName(CloudBlockBlob templateBlob)
        {
            return new OutputBlob { OutputName = $@"{templateBlob.Name}", Blob = templateBlob };
        }
    }
}
