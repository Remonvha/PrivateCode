using System;
using System.Collections.Generic;
using ICSharpCode.SharpZipLib.Zip;
using System.IO;
using FunctionApp.ZIP.Model;
using Microsoft.Azure.WebJobs;

namespace FunctionApp.ZIP.Helper
{
    public class ZipHelper
    {
        private readonly IBinder _binder;

        public ZipHelper(IBinder Binder)
        {
            _binder = Binder;
        }

        public string CreateZipFile(List<OutputBlob> blobs)
        {

            BlobAttribute dynamicBlobBinding = new BlobAttribute(blobPath: $"output/{DateTime.Now.ToString("yyyyMMddTHHmmss")}-{Guid.NewGuid()}.zip", FileAccess.Write);

            using (var writer = _binder.Bind<Stream>(dynamicBlobBinding))
            {
                var zipOutputStream = new ZipOutputStream(writer);

                foreach (var blob in blobs)
                {
                    zipOutputStream.SetLevel(0);
                    var entry = new ZipEntry(blob.OutputName);

                    zipOutputStream.PutNextEntry(entry);
                    blob.Blob.DownloadToStream(zipOutputStream);
                }
                zipOutputStream.Finish();

                zipOutputStream.Close();
            }

            return dynamicBlobBinding.BlobPath;
        }
    }
}
