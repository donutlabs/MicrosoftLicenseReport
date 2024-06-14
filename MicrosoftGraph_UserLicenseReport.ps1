# Try to connect to Microsoft Graph with the specified scopes
try {
    Connect-MgGraph -Scopes "User.Read.All"
} catch {
    # If the connection fails, write an error message and exit
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit
}

# Try to retrieve all users from Microsoft Graph
try {
    $users = Get-MgUser -All
} catch {
    # If retrieving users fails, write an error message and exit
    Write-Error "Failed to retrieve users: $_"
    exit
}

# Initialize a new list to hold the output data
$output = New-Object System.Collections.Generic.List[System.Object]

# Loop through each user retrieved from Microsoft Graph
foreach ($user in $users) {
    try {
        # Get the user's email and domain
        $email = $user.UserPrincipalName
        $domain = $email.Split("@")[-1]

        # Get the user's licenses
        $licenses = Get-MgUserLicenseDetail -UserId $user.Id | Select-Object -ExpandProperty SkuPartNumber

        # If the user has licenses, add them to the output list
        if ($licenses) {
            foreach ($license in $licenses) {
                # Create a custom object for each license
                $user_licenses = [PSCustomObject]@{
                    Email = $email
                    Domain = $domain
                    License = $license
                }
                # Add the custom object to the output list
                $output.Add($user_licenses)
            }
        }
    } catch {
        # If processing a user fails, write a warning message and continue with the next user
        Write-Warning "Failed to process user $($user.UserPrincipalName): $_"
        continue
    }
}

# Try to group and transform the output data
try {
    # Group the output by domain and license
    $grouped = $output | Group-Object -Property Domain, License

    # Transform the grouped data into a custom object with domain, license, and count
    $result = $grouped | ForEach-Object {
        $domain, $license = $_.Name -split ", "
        $domainValue = $domain -replace "^Domain=", ""
        $licenseValue = $license -replace "^License=", ""
        [PSCustomObject]@{
            Domain  = $domainValue
            License = $licenseValue
            Count   = $_.Count
        }
    }
} catch {
    # If grouping and transforming data fails, write an error message and exit
    Write-Error "Failed to group and transform data: $_"
    exit
}

# Try to display the results in a table
try {
    $result | Format-Table -AutoSize
} catch {
    # If displaying results fails, write a warning message
    Write-Warning "Failed to display results: $_"
}

# Try to export the results to a CSV file
try {
    $result | Export-Csv -Path "c:/yourfile.csv" -NoTypeInformation
} catch {
    # If exporting results fails, write an error message
    Write-Error "Failed to export results to CSV: $_"
}
