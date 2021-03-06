
param( [string]$alwaysrestartsvrname1 = "Yes", [string]$downloadfolderpath = "", [int]$inactivityinterval = 1)


# Service names
$srvName1 = "Service1"
$srvName2 = "Service2"
$srvName3 = "Service3"


function RestartServices 
{

    # Stop and Start the srvName1 service if it is already running
    If ($alwaysrestartsvrname1 -eq "Yes" )
    {
        Stop-Service $srvName3
        Start-Service $srvName3
    }
    Else
    {
        $serviceHandler = Get-Service $srvName3
        # Start the srvName1 service if it is not already running
        If ($serviceHandler.status -ne "Running")
        {
            Start-Service $srvName3
        }
    }
    
     # Stop and Start the Bridge Client and PDS Agent services
    Stop-Service $srvName2
    Stop-Service $srvName1  
    Start-Service $srvName2
    Start-Service $srvName1  

}


# If no folder is passed in, restart all services (queue restart depend on the parm alwaysrestartsvrname1)
If ($downloadfolderpath -eq "")
{         
    RestartServices 
}
Else
{
    # Get the most recent file in the folder     
    $latest = Get-ChildItem -Path "$downloadfolderpath" | Sort-Object LastAccessTime -Descending | Select-Object -First 1
    
    # Construc the full path to the file       
    $fullPath = "$downloadfolderpath\$latest"
    
    # Get the time this file was modified
    $lastWrite = (get-item $fullPath).LastWriteTime
    $timespan = new-timespan  -hours $inactivityinterval  

    # If inactivity duration is more than specified in our interval, proceed with Services Restart
    If ( ( (get-date) - $lastWrite) -gt $timespan) 
    {
        RestartServices 
    } 


}