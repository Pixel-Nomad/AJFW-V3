using System;
using System.Collections.Generic;

public class Config
{
    public List<RequestMethod> Methods { get; set; }
    public PrintLabels PrintLabels { get; set; }
    public List<StatusCodes> StatusCodes { get; set; }
    public string serverUri { get; set; }
    public int ErrorLevel { get; set; }
    public int DebugLevel { get; set; }
}

public class RequestMethod
{
    public string name { get; set; }
    public bool allowed { get; set; }
    public bool RequestBody { get; set; }
}

public class PrintLabels
{
    public string status { get; set; }
    public string error { get; set; }
}

public class StatusCodes
{
    public int code { get; set; }
    public string status { get; set; }
    public string msg { get; set; }
}

public class Program
{
    public static void Main(string[] args)
    {
        Config config = new Config
        {
            Methods = new List<RequestMethod>
            {
                new RequestMethod { name = "GET", allowed = true, RequestBody = false },
                new RequestMethod { name = "HEAD", allowed = false, RequestBody = false },
                new RequestMethod { name = "POST", allowed = true, RequestBody = false },
                new RequestMethod { name = "PUT", allowed = false, RequestBody = false },
                new RequestMethod { name = "DELETE", allowed = false, RequestBody = false },
                new RequestMethod { name = "OPTIONS", allowed = false, RequestBody = false },
                new RequestMethod { name = "PATCH", allowed = false, RequestBody = false }
            },
            PrintLabels = new PrintLabels
            {
                status = "^3[request:status]^0 ",
                error = "^1[request:error]^0 "
            },
            StatusCodes = new List<StatusCodes>
            {
                new StatusCodes { code = 500, status = "500 Internal Server Error", msg = "There isnt any status code, status message or error message defined at index Config.StatusCodes[%s]" },
                new StatusCodes { code = 200, status = "200 OK" },
                new StatusCodes { code = 400, status = "400 Bad Request", msg = "The given request path (%s) handler cleared or didn't return the response data object" },
                new StatusCodes { code = 405, status = "405 Method Not Allowed", msg = "The given request method '%s' isnt allowed for this request and should be a '%s' method" },
                new StatusCodes { code = 500, status = "500 Internal Server Error", msg = "" },
                new StatusCodes { code = 501, status = "501 Not Implemented", msg = "There isnt any http request defined with base path '/%s'" }
            },
            serverUri = "http://localhost:30120/", // the request uri of your server
            ErrorLevel = 10,
            DebugLevel = 10
        };

        // You can now use the 'config' object in your C# code.
    }
}