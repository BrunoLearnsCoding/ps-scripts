<#
.Synopsis
    Modify proxy settings for the current user.

.DESCRIPTION
    Modify proxy settings for the current user modifying the windows registry.

.EXAMPLE
    Get the proxy settings for the current user

    PS D:\> Get-Proxy
    ProxyServer ProxyEnable AutoConfigURL
    ----------- ----------- -------------
                        0   

.EXAMPLE
   Set the auto config proxy server for the current user. Test the address and if the TCP Port is open before applying the settings.
   Set-AutoConfigProxy "yourproxy.server.com:5620/proxy.pac"
  
.EXAMPLE
   Remove the current proxy settings for the user.
   Remove-Proxy

.NOTES
   Author Paolo Frigo, https://www.scriptinglibrary.com
   Modifed by Bruno, https://www.ilearncoding.com
#>



function Get-Proxy (){
    Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' | Select-Object ProxyServer, ProxyEnable, AutoConfigURL        
}

function Set-AutoConfigProxy { 
    [CmdletBinding()]
    [Alias('proxy')]
    [OutputType([string])]
    Param
    (
        # autoconfigurl address
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        $autoconfigurl
 
    )

    $uri = [System.Uri]$autoconfigurl
    #Test if the TCP Port on the server is open before applying the settings
    If ((Test-NetConnection -ComputerName $uri.Host -Port $uri.Port).TcpTestSucceeded) {
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name AutoConfigURL -Value $autoconfigurl
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 1
        Get-Proxy #Show the configuration 
    }
    Else {
        Write-Error -Message "The proxy address is not valid:  $($server):$($port)"
    }    
}

function Remove-Proxy (){    
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyServer -Value ""
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name ProxyEnable -Value 0
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -name AutoConfigURL -Value ""
    
    <#
    .SYNOPSIS 
        Remove the proxy setting for current user
    .DESCRIPTION
        Remove the proxy setting for current user by changing registry keys.

    
    #>
}