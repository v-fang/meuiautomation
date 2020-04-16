using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Microsoft.WindowsAzure.Storage.Auth;
using Microsoft.WindowsAzure.Storage.Queue;
using Microsoft.WindowsAzure.Storage.Table;
using Microsoft.WindowsAzure.Storage;

namespace $rootnamespace$.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }

        public ActionResult ForHttpData()
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://www.baidu.com");
            using(WebResponse response = request.GetResponse())
            {
            }  
           return View();
        }
        public ActionResult DownloadFromBlob()
        {
            string url = "http://aivendortest.blob.core.windows.net/test/AITest.txt";
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                WebResponse response = request.GetResponse();
                Stream stream = response.GetResponseStream();

               // Response.ContentType = "text/plain";
                byte[] bytes = new byte[512]; // create a buffer.
                //int bytesReaded = 512;
                //while (bytesReaded == 512)
                //{
                // bytesReaded = stream.Read(bytes, 0, 512);   // read the source 0~511 to bytes array.
                stream.Read(bytes, 0, 512);
                //Response.OutputStream.Write(bytes, 0, bytesReaded);
                //}
                // return null;
                return View();
            }
            catch (Exception ex)
            {
               // return null;
                return View();
                //return Content(@"<script>alert('" + ex.Message + "');window.location.href='Index';</script>");
            }
        }
        public ActionResult ConnectDB()
        {
            string sqlstring = "Server=tcp:n604ivwf6k.database.windows.net,1433;Database=aivendortest;User ID=aivendor@n604ivwf6k;Password=AIRocks!;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;";
            SqlConnection con = new SqlConnection(sqlstring);
            con.Open();
            string command = "Select * From T1";
            SqlCommand com = new SqlCommand(command, con);
            SqlDataAdapter sda = new SqlDataAdapter(com);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                con.Close();
                return View();
            }
            else
            {
                con.Close();
                return View();
            }
        }
        public ActionResult ForHttpError()
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://wjhkww.baidasdasddu.com");

            try
            {
                WebResponse response = request.GetResponse();
            }
            catch { request.Abort(); }
            return View();
        }
        public ActionResult BlobError()
        {
            try
            {
                string errorUrl = "http://aivendortest.blob.core.windows.net/test/AITest0000.txt";
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(errorUrl);
                WebResponse response = request.GetResponse();
                Stream stream = response.GetResponseStream();
                
                return View();
            }
            catch (Exception ex)
            {
               
                return View();
            }
        }
        public ActionResult SqlError()
        {
            try
            {
                string sqlstring = "Server=tcp:n604ivwf6k.database.windows.net,1433;Database=aivendortest;User ID=aivendor@n604ivwf6k;Password=AIRocks!;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;";
                SqlConnection con = new SqlConnection(sqlstring);
                con.Open();
                string command = "INSERT INTO T1 VALUES (1,'ERROR')";
                SqlCommand com = new SqlCommand(command, con);
                com.ExecuteNonQuery();
                return View();
            }
            catch (Exception ex)
            {
                return View();
            }
        }
         public ActionResult GetAzureQueueAndTableInfo()
        {
            string connectStorageString = @"DefaultEndpointsProtocol=https;AccountName=marystorage;AccountKey=lM069ZdGB5L70Tm5wRTPTp6hlfGmQdqk+sJp9pmoegHEn2ElWPfOW3tEcxV9fmbWTEaT7M9Km8Nzptzrt/Z1pQ==;BlobEndpoint=https://marystorage.blob.core.windows.net/;TableEndpoint=https://marystorage.table.core.windows.net/;QueueEndpoint=https://marystorage.queue.core.windows.net/;FileEndpoint=https://marystorage.file.core.windows.net";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(
               connectStorageString);
            // Create the table client.
            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();
            // Create the table if it doesn't exist.
            CloudTable table = tableClient.GetTableReference("people");
            table.CreateIfNotExists();
            //Create the queue client
            CloudQueueClient queueClient = storageAccount.CreateCloudQueueClient();
            // Retrieve a reference to a queue
            CloudQueue queue = queueClient.GetQueueReference("myqueue0322");
            // Fetch the queue attributes.
            queue.FetchAttributes();

            // Retrieve the cached approximate message count.
            int? cachedMessageCount = queue.ApproximateMessageCount;

            string Count = cachedMessageCount.HasValue ? cachedMessageCount.Value.ToString() : "0";
            // Display number of messages.
            return View();     
        }
        public ActionResult GetAzureQueueAndTableError()
        {
            string connectStorageString =@"DefaultEndpointsProtocol=https;AccountName=marystorage;AccountKey=lM069ZdGB5L70Tm5wRTPTp6hlfGmQdqk+sJp9pmoegHEn2ElWPfOW3tEcxV9fmbWTEaT7M9Km8Nzptzrt/Z1pQ==;BlobEndpoint=https://marystorage.blob.core.windows.net/;TableEndpoint=https://marystorage.table.core.windows.net/;QueueEndpoint=https://marystorage.queue.core.windows.net/;FileEndpoint=https://marystorage.file.core.windows.net";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(
               connectStorageString);
            //Create the queue client
            CloudQueueClient queueClient = storageAccount.CreateCloudQueueClient();
            // Create the table client.
            CloudTableClient tableClient = storageAccount.CreateCloudTableClient();

            // Retrieve a reference to a queue
            try
            {
                CloudQueue queue = queueClient.GetQueueReference("myqueueAIVENDOR");
                queue.GetMessage();
            }
            catch
            {
            }
            try
            {
                // Create the table failed because of existence.
                CloudTable table = tableClient.GetTableReference("people");
                table.Create();
            }
            catch
            {
               return View();
            }
             return View();
        }
    }
}