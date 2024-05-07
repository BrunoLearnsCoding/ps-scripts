# Import the Active Directory module
Import-Module ActiveDirectory

# Get all computers in the domain
$computers = Get-ADComputer -Filter *

# Output the computer names
$computers | Select-Object -ExpandProperty Name

# Create a hashtable of countries
$countries = @{
    "US" = "United States";
    "UK" = "United Kingdom";
    "CA" = "Canada";
    "AU" = "Australia";
}

# Output the hashtable
$countries