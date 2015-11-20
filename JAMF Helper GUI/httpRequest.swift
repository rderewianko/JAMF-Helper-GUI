//
//  RequestAPI.swift
//  JAMF Helper GUI
//
//  Created by Jordan Wisniewski on 8/11/15.
//
//  Copyright (C) 2015, JAMF Software, LLC All rights reserved.
//
//  THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
//  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
//  DAMAGE.

import Cocoa

public class httpRequest: NSObject {
    
    func post(url: String, user: String, password: String, data: String){
        
        let url = url + "/JSSResource/scripts/id/0"
        let data = (data as NSString).dataUsingEncoding(NSUTF8StringEncoding)

        //Combine the credentials
        let credentials = user + ":" + password
        
        //UTF-8 Encode login information, and then Base64 encode login information
        let utf8_credentials = credentials.dataUsingEncoding(NSUTF8StringEncoding)
        let base64_credentials = utf8_credentials!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        //Create a request object, set method to 'POST' and the body to the script XML
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        
        //Create a default configuration, and add additional headers for Basic Authentication and Content Type
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization" : "Basic \(base64_credentials)", "Content-Type" : "text/xml"]
        
        //Initialize a NSURL session
        let session = NSURLSession(configuration: configuration)
        
        //Create the task with the request, and prepare to log result/errors to console
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                
                self.httpStatus(httpResponse)
                
            }
            
            if error == nil {
                
                let result = NSString(data: data!, encoding:
                    NSASCIIStringEncoding)!
                NSLog("result %@", result)
                
            } else {
                
                NSLog("result %@", error!)
                
            }
        }
        
        //Start the task (ie. Submit HTTP Request)
        task.resume()
    }
    
    func httpStatus(status: NSHTTPURLResponse) {
        
        let statusCode = status.statusCode
        let message = "Status: " + String(statusCode) + "\n" + "Request was "
        
        if statusCode == 201 {
            
            ViewController().displayAlert("HTTP Request", button: "OK", body: message + "Successful.")
            
        } else {
            
            ViewController().displayAlert("HTTP Request", button: "OK", body: message + "Unsuccessful")
            
        }
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
        
    }
}
