using Microsoft.Azure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.Text;

namespace FunctionApp.ZIP.Model
{
    public class OutputBlob
    {
        public String OutputName { get; set; } 
        public CloudBlockBlob Blob { get; set; }
    }
}
