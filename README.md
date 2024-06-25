# MicrosoftGraphUserLicenseReport

This PowerShell script connects to Microsoft Graph to retrieve all user accounts and their associated licenses within an organization. It groups the data by user domain and license type, providing a count of users for each license in each domain. The results are displayed in a formatted table and exported to a CSV file for further analysis.

## Features:
- Connects to Microsoft Graph with the specified scopes
- Retrieves all users and their license details
- Processes and groups user data by domain and license
- Displays the grouped data in a formatted table
- Exports the final results to a CSV file

## Usage:
1. Ensure you have the required permissions and modules to connect to Microsoft Graph.
2. Run the script in a PowerShell environment with the necessary privileges.
3. The results will be displayed in the console and saved to `c:/yourfilenam.csv`.

## Error Handling:
- The script includes error handling to manage failures in connecting to Microsoft Graph, retrieving user data, processing user information, and exporting the results. Appropriate error messages are displayed to aid in troubleshooting.

