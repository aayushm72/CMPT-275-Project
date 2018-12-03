# CMPT-275-Project

Simon Fraser University 
CMPT 275 Team 2 iOS Project

Remembral : Memories Matter
- Set reminders
- Geo-location tracking
- Personal and Contact Info

Steps to checkout project:
 - The project uses XCode IDE version 10.1+ running on a macOS device, therefore, make sure you are running a macOS device and have XCode IDE version 10.1 or higher is installed.
 - Download the project files using the "Clone or download" > "Download ZIP" option
 - Place the downloaded ZIP file where you want the project files to reside in your file structure.
 - Extract the contents of the ZIP folder
 - Open the file "Remembral.xcworkspace" in XCode IDE.
 - Run the application in an iOS simulator or load onto an iPhone
 - Login with the provided details below or Register a new User
 
 - - - - -
 
 Login Notes:
 * Caretaker Account
    * Email - caretaker@remembral.com
    * Password - CaretakerPassword
 * Patient Account
    * Email - patient@remembral.com
    * Password - PatienPassword

- - - - -
 
 Testing Notes:
 * SOS Testing
    * The SOS functionality is not available when running test on a simulator as there is no messaging service available on the simulator
    * To perform SOS testing it is recommended to load the application onto an iPhone.
 * Current location and Heatmaps Testing
    * It is recommended to use the above mentioned user accounts for location and heatmap testing as location data already exists in the database.
    * For testing current location tracking it may be better to use XCode's city-run feature to simulate GPS Movement for the Patient while the Caretaker can observe the movement of the Patient.
