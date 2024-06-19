Get-WmiObject -Query "select * from win32_OperatingSystem"
Get-WmiObject win32_OperatingSystem | Select-Object -Property Locale

# get instance
$os = Get-WmiObject Win32_OperatingSystem

# output information:
"The class has {0} properties" -f $os.properties.count
"Details on this class:"
$os | Format-List *

Get-WmiObject -Query "select * from win32_OperatingSystem"
Get-WmiObject win32_OperatingSystem | Select-Object -Property Locale

# get instance
$os = Get-WmiObject Win32_OperatingSystem

# output information:
"The class has {0} properties" -f $os.properties.count
"Details on this class:"
$os | Format-List *

# Correct way to get all available cultures
$cultures = [System.Globalization.CultureInfo]::GetCultures([System.Globalization.CultureTypes]::AllCultures)
$cultures | Select-Object | Sort-Object -property DisplayName | Format-Table