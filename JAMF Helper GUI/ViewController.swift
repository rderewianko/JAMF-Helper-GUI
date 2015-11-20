//
//  ViewController.swift
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
import Foundation

class ViewController: NSViewController {
    
    // Link controls to View Controller
    @IBOutlet weak var WindowType: NSPopUpButton!
    @IBOutlet weak var WindowTitle: NSTextField!
    @IBOutlet weak var WindowHeading: NSTextField!
    @IBOutlet weak var HeadingAlignment: NSPopUpButton!
    @IBOutlet weak var WindowDescription: NSTextField!
    @IBOutlet weak var DescriptionAlignment: NSPopUpButton!
    @IBOutlet weak var WindowPosition: NSPopUpButton!
    @IBOutlet weak var IconSize: NSTextField!
    @IBOutlet weak var ButtonOne: NSTextField!
    @IBOutlet weak var ButtonTwo: NSTextField!
    @IBOutlet weak var DefaultButton: NSSegmentedControl!
    @IBOutlet weak var CancelButton: NSSegmentedControl!
    @IBOutlet weak var LockHUD: NSSegmentedControl!
    @IBOutlet weak var WindowCountdown: NSSegmentedControl!
    @IBOutlet weak var WindowTimeout: NSTextField!
    @IBOutlet weak var StartLaunchD: NSSegmentedControl!
    @IBOutlet weak var ScriptName: NSTextField!
    @IBOutlet weak var jssURL: NSTextField!
    @IBOutlet weak var jssUser: NSTextField!
    @IBOutlet weak var jssPass: NSSecureTextField!
    @IBOutlet weak var FullScreenIcon: NSSegmentedControl!
    @IBOutlet weak var JSSBox: NSBox!
    @IBOutlet weak var MainLogo: NSButton!
    @IBOutlet weak var DelayOptions: NSTextField!
    @IBOutlet weak var IconFileName: NSTextField!
    @IBOutlet weak var CountdownText: NSTextField!
    @IBOutlet weak var CountdownAlignment: NSPopUpButton!
    
    let jamfHelperPath = "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    var icon: String = ""
    
    // Enable countdown alignment field if countdown text is entered
    @IBAction func CountdownTextChanged(sender: NSTextField) {
        
        manageControls().popupButton(CountdownAlignment, dependency: CountdownText)
        
    }
    
    // Enable countdown text if countdown button has 'Yes' selected, otherwise disable
    @IBAction func CountdownButtonChanged(sender: NSSegmentedControl) {
        
        if WindowCountdown.selectedSegment == 0 {
            
            CountdownText.enabled = true
            
        } else {
            
            CountdownText.enabled = false
            CountdownText.stringValue = ""
            manageControls().popupButton(CountdownAlignment, dependency: CountdownText)
            
        }
    }
    
    // Enable countdown button if window timeout value is entered
    @IBAction func TimeoutChanged(sender: NSTextField) {
        
        manageControls().segmentedControl(WindowCountdown, dependency: WindowTimeout, dependency2: nil)
        
    }
    
    // Enable description alignment if description text is entered
    @IBAction func DescriptionChanged(sender: NSTextField) {
        
        manageControls().popupButton(DescriptionAlignment, dependency: WindowDescription)
        
    }
    
    // Open 'jamfhelper -help' as an alert when logo is pressed
    @IBAction func MainLogoClicked(sender: NSButton?) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://jamfnation.jamfsoftware.com")!)
    }
    
    // Enable heading alignment if heading text is entered
    @IBAction func HeadingChanged(sender: NSTextField) {
        
        manageControls().popupButton(HeadingAlignment, dependency: WindowHeading)
        
    }
    
    // Enable default and cancel buttons if button text is entered
    @IBAction func ButtonFieldChanged(sender: NSTextField) {
        
        manageControls().segmentedControl(DefaultButton, dependency: ButtonOne, dependency2: ButtonTwo)
        manageControls().segmentedControl(CancelButton, dependency: ButtonOne, dependency2: ButtonTwo)
        
    }
    
    // Manage window position, and timeout based on window type selection
    @IBAction func WindowTypeChanged(sender: NSPopUpButton) {
        
        let window_type = WindowType.indexOfSelectedItem
        
        
        // If window type is Fullscreen and no icon is selected
        if window_type == 3 && icon != "" {
            
            for var segment = 0; segment < FullScreenIcon.segmentCount; ++segment {
                
                FullScreenIcon.setEnabled(true, forSegment: segment)
                
            }
            
            WindowPosition.enabled = false
            WindowPosition.selectItemAtIndex(0)
            
            WindowTimeout.enabled = false
            WindowTimeout.stringValue = ""
            
            manageControls().segmentedControl(WindowCountdown, dependency: WindowTimeout, dependency2: nil)
        
            
        // If window type is Fullscreen and an icon is selected
        } else if window_type == 3 && icon == "" {
            
            WindowPosition.enabled = false
            WindowPosition.enabled = false
            WindowPosition.selectItemAtIndex(0)
            WindowTimeout.enabled = false
            WindowTimeout.stringValue = ""
            manageControls().segmentedControl(WindowCountdown, dependency: WindowTimeout, dependency2: nil)
        
        // If window type is not Fullscreen
        } else {
            
            // Disable button for fullscreen icon
            for var segment = 0; segment < FullScreenIcon.segmentCount; ++segment {
                
                FullScreenIcon.setEnabled(false, forSegment: segment)
                FullScreenIcon.setSelected(false, forSegment: segment)
                
            }
            
            // Enable window position if it is disabled
            if WindowPosition.enabled == false {
                
                WindowPosition.enabled = true
                
            }
            
            // Enable time out if it is disabled
            if WindowTimeout.enabled == false {
                
                WindowTimeout.enabled = true
                
            }
            
            // Enable countdown if timeout is entered
            manageControls().segmentedControl(WindowCountdown, dependency: WindowTimeout, dependency2: nil)
            
        }
    }
    
    // Display the fields for submitting to the JSS
    @IBAction func UnhideJSS(sender: NSButton) {
        
            if (JSSBox.hidden == true && MainLogo.hidden == false) {
                
                JSSBox.hidden = false
                MainLogo.hidden = true
                
            } else {
                
                JSSBox.hidden = true
                MainLogo.hidden = false
                
            }
    }
    
    // Submit the script to the JSS
    @IBAction func SubmitToJSS(sender: NSButton) {
        
        if WindowTypeSelected() == true {
            
            let script_xml = generateXML(helperArgumentsToString())
            let request = httpRequest()
            request.post(jssURL.stringValue, user: jssUser.stringValue, password: jssPass.stringValue, data: script_xml)
            
        } else {
            
            displayAlert("Warning!", button: "OK", body: "The JAMF Helper binary requires a 'Window Type' be selected to run. Please select a 'Window Type' and try again.")
            
        }
    }
    
    // Execute a JAMF Helper 'kill' command
    @IBAction func KillHelper(sender: NSButton) {
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            executeCommand(jamfHelperPath, args: ["-kill"], out: false)
        }
        
    }
    
    // Get the path to the image to use as an icon
    @IBAction func SelectIcon(sender: NSButton) {
        
        getFilePath()
        
    }
    
    // Asynchronously launch JAMF Helper window
    @IBAction func LaunchHelper(sender: NSButton) {
        
        if WindowTypeSelected() == true {
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                
                let helper = self.helperArgumentsToString()
                self.executeCommand(self.jamfHelperPath, args: helper, out: false)
                
            }
            
        } else {
            
            displayAlert("Warning!", button: "OK", body: "The JAMF Helper binary requires a 'Window Type' be selected to run. Please select a 'Window Type' and try again.")
            
        }
    }
    
    // Create a script and save to the desktop
    @IBAction func CreateScript(sender: NSButton) {
        
        if WindowTypeSelected() == true {
            
            let user_directory = NSHomeDirectory() + "/Desktop"
            let file_name = "JAMFHelperGUI"
            let file_extension = ".sh"
            let shebang = "#!/bin/bash"
            let path = user_directory + "/" + file_name + "-" + printTimestamp() + file_extension
            let script_string = helperArgumentsToString().joinWithSeparator(" ")
            let script_output = shebang + "\n" + "\"" + jamfHelperPath + "\" " + script_string
            try! script_output.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            
        } else {
            
            displayAlert("Warning!", button: "OK", body: "The JAMF Helper binary requires a 'Window Type' be selected to run. Please select a 'Window Type' and try again.")
            
        }
    }
    
    // Displays alert messages in popup window
    func displayAlert(title: String, button: String, body: AnyObject?) {
        
        let alert = NSAlert()
        alert.messageText = title
        alert.addButtonWithTitle(button)
        
        if let body = body {
            
            if body is String {
                
                alert.informativeText = body as! String
                
            } else {
                
                alert.accessoryView = body as! NSScrollView
                
            }
        }
        
        alert.runModal()
        
    }
    
    // Opens a Finder file select dialog window
    func getFilePath() {
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = true
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            
            if result == NSFileHandlingPanelOKButton {
                
                self.icon = openPanel.URL!.path!
                self.IconFileName.stringValue = openPanel.URL!.lastPathComponent!
                self.enableIconSize()
                
                if self.WindowType.indexOfSelectedItem == 3 {
                    
                    for var segment = 0; segment < self.FullScreenIcon.segmentCount; ++segment {
                        
                        self.FullScreenIcon.setEnabled(true, forSegment: segment)
                        
                    }
                }
                
            } else {
                
                self.icon = ""
                self.IconFileName.stringValue = ""
                
            }
        }
        
    }
    
    // Returns true if window type has a value
    func WindowTypeSelected() -> Bool {
        
        var windowEnabled: Bool
        
        if WindowType.indexOfSelectedItem != 0 {
            
            windowEnabled = true
            
        } else {
            
            windowEnabled = false
            
        }
        
        return windowEnabled
        
    }
    
    // Enables icon file size field if an icon has been selected
    func enableIconSize() {
        
        if icon != "" {
            
            IconSize.enabled = true
            
        } else {
            
            IconSize.enabled = false
            
        }
    }
    
    // Creates a string array from the input array of arrays
    func helperArgumentsToString() -> [String] {
        
        let processed_inputs = processInputs()
        var arguments_string: [String] = []
        
        for arguments in processed_inputs {
            
            for stuff in arguments {
                
                arguments_string.append(stuff)
                
            }
        }

        return arguments_string
        
    }
    
    // User input validation
    func processInputs() -> [[String]] {

        var inputs: [[String]] = [["-windowType", WindowType.titleOfSelectedItem!.lowercaseString],
            ["-windowPosition", WindowPosition.titleOfSelectedItem!.lowercaseString],
            ["-title", "\"" + WindowTitle.stringValue + "\""],
            ["-heading", "\"" + WindowHeading.stringValue + "\""],
            ["-alignHeading", HeadingAlignment.titleOfSelectedItem!.lowercaseString],
            ["-description", "\"" + WindowDescription.stringValue + "\""],
            ["-alignDescription", DescriptionAlignment.titleOfSelectedItem!.lowercaseString],
            ["-icon", "\"" + icon + "\""],
            ["-iconSize", IconSize.stringValue],
            ["-fullScreenIcon", String(FullScreenIcon.selectedSegment)],
            ["-button1", "\"" + ButtonOne.stringValue + "\""],
            ["-button2", "\"" + ButtonTwo.stringValue + "\""],
            ["-defaultButton", String(DefaultButton.selectedSegment)],
            ["-cancelButton", String(CancelButton.selectedSegment)],
            ["-timeout", WindowTimeout.stringValue],
            ["-countdown", String(WindowCountdown.selectedSegment)],
            ["-countdownPrompt", "\"" + CountdownText.stringValue + "\""],
            ["-alignCountdown", CountdownAlignment.titleOfSelectedItem!.lowercaseString],
            ["-lockHUD", String(LockHUD.selectedSegment) ],
            ["-startlaunchD", String(StartLaunchD.selectedSegment)],
            ["-showDelayOptions", DelayOptions.stringValue]]
        
        // Remove all empty values
        inputs = inputs.filter { $0[1].isEmpty == false }
        
        // Remove all '-1' values
        inputs = inputs.filter { $0[1] != "-1" }
        
        //Remove all empty strings
        inputs = inputs.filter { $0[1] != "\"\"" }

        for (index, arg_array) in inputs.enumerate() {
            
            // Get the first letter from each word for window position
            if arg_array[0] == "-windowPosition" {
                
                let position_array = arg_array[1].componentsSeparatedByString(" ")
                let position_short = String(position_array[0]).substringToIndex(String(position_array[0]).startIndex.advancedBy(1)) + String(position_array[1]).substringToIndex(String(position_array[1]).startIndex.advancedBy(1))
                inputs[index][1] = position_short
                
            }
            
            // Add one to the selected index
            else if (arg_array[0] == "-defaultButton" || arg_array[0] == "-cancelButton") {
                
                inputs[index][1] = String(Int(arg_array[1])! + 1)
                
            }
            
            // Strip argument value or remove argument based on value
            else if (arg_array[0] == "-lockHUD" || arg_array[0] == "-fullScreenIcon" ||
                    arg_array[0] == "-countdown" || arg_array[0] == "-startLaunchD") {
                        
                        if arg_array[1] == "0" {
                            
                            inputs[index].removeAtIndex(1)
                            
                        } else {
                            
                            inputs.removeAtIndex(index)
                            
                        }
            }
        }
        
        return inputs
        
    }
    
    // Execute terminal commands
    func executeCommand(command: String, args: [String], out: Bool) -> String? {
        
        let pipe = NSPipe()
        let task = NSTask()
        task.launchPath = command
        task.arguments = args
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String? = String(data: data, encoding: NSUTF8StringEncoding)

        if out == true {
            
            return output
            
        } else {
            
            return nil
        }
    }
    
    // Date/Time stamp
    func printTimestamp() -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd HH-mm-ss"
        return formatter.stringFromDate(NSDate())
        
    }
    
    // Creates an XML for the script
    func generateXML(data:[String]) -> String {
        
        let script_name = ScriptName.stringValue
        let shebang = "#!/bin/bash"
        let argument_string = helperArgumentsToString().joinWithSeparator(" ")
        let script_string = shebang + "\n" + "\"" + jamfHelperPath + "\" " + argument_string
        
        let root = NSXMLElement(name: "script")
        root.addChild(NSXMLElement(name: "name", stringValue: script_name))
        root.addChild(NSXMLElement(name: "script_contents", stringValue: script_string))
        
        let xml = NSXMLDocument(rootElement: root)
        return xml.XMLStringWithOptions(Int(NSXMLDocumentIncludeContentTypeDeclaration))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

