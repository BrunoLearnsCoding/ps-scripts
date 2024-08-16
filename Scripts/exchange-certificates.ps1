$txtrequest = New-ExchangeCertificate -PrivateKeyExportable $True -GenerateRequest -FriendlyName "taamlocomotive 2023-Final" -SubjectName  "C=IR,CN=xmail.taamlocomotive.com,O=Taamlocomotive,OU=IT,S=Tehran,L=Tehran" -DomainName taamlocomotive.com,autodiscover.taamlocomotive.com

[System.IO.File]::WriteAllBytes('\\mail-01\CSRs\2023\taamlocomotive2023-Final.req', [System.Text.Encoding]::Unicode.GetBytes($txtrequest))

 
# ==================================

 

# Import-ExchangeCertificate -FileData ([System.IO.File]::ReadAllBytes('<FilePathOrUNCPath>')) [-Password (ConvertTo-SecureString -String '<Password> ' -AsPlainText -Force)] [-PrivateKeyExportable <$true | $false>] [-Server <ServerIdentity>]

Import-ExchangeCertificate -FileData ([System.IO.File]::ReadAllBytes('\\mail-01\CSRs\2023\taamlocomotive2023-Final.CER')) -Server mail-01 -Password (Get-Credential).password -Wahtif