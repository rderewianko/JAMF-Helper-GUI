# JAMF-Helper-GUI

The 'JAMF Helper GUI' is a Cocoa interface, written in Swift, that allows for easily creating JAMF Helper commands. The application provides a GUI option for all of the 'jamfhelper' binary commands to make selecting and formatting the appropriate arguments easier. 

It allows for launching 'jamfhelper' with the selected commands to preview the settings, outputting the commands to a '.sh' file on the desktop, and submitting the 'jamfhelper' command as a script directly to the JSS via the API.

REQUIREMENTS: OS X 10.7+ (only OS X 10.10 and 10.11 tested)
              JAMF Helper Binary - Located in "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"                in order for previews to work.
