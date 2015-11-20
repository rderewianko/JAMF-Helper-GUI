//
//  AppDelegate.swift
//  JAMF Helper GUI
//
//  Created by Jordan Wisniewski on 7/29/15.
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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    // Respond to Help menu item being clicked
    @IBAction func showHelp (sender: NSMenuItem) {
        displayHelp()
    }
    
    // Create an alert with the output of "jamfhelper -help"
    func displayHelp() {
        let jamfHelperPath = "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
        let view = ViewController()
        
        let help = view.executeCommand(jamfHelperPath, args: ["-help"], out: true)
        let frame = NSRect(x: 0,y: 0,width: 600,height: 400)
        
        let textView = NSTextView()
        textView.frame = frame
        textView.string = help!
        
        let scrollView = NSScrollView()
        scrollView.frame = frame
        scrollView.documentView = textView
        
        view.displayAlert("JAMF Helper Help", button: "OK", body: scrollView)
    }


}

