#Start of function
function Enter-Variables
{
#Skip errors, this can be changed if you wish to see more of the failed connections
$ErrorActionPreference = "SilentlyContinue"

    $port = 1..65535 #You can change this manually or setup an input variable, by default it will scan all ports
    
#Enter something like X.X.X -- 1.1.1 for IP
#This block is for explanation
    Write-Host "Enter the first 3 octets of the IP address example: 10.1.1 or 192.168.0 `n"
    
    Write-Host "
    Do not enter the last octet:
    Example of what not to do            10.1.1.125 <---Last Octet Entered  .125
    or leave a trailing period
    Example of what not to do            192.168.0.  <--Trailing Period
    " -Foregroundcolor "Yellow"

#Enter the info
$net = Read-Host "-"
    
#Verification of the host names    
    $confirmnet = Read-Host "You would like to scan $net/0 correct?
y/n"
    if ($confirmnet -eq "n")
    {
        Write-Host "`n`n`n`n`n`n"
        Enter-Variables
    }
    else {}


#By default this will scan all IP addresses, otherwise you can do one, or multiple
#Use a range (i.e.  1..250  would scan your Network range, from 1 to 250)


$range= Read-Host = "Enter an IP or a range of IPs 
To enter a range add 2 dots between the numbers: 1..5 would scan one through five.

To scan All IPs press enter"
    
    
    If ($range -eq '') #If nothing do everything except broadcast
    {
        $range= 1..254
    }
    
#Main Scan


    foreach ($r in $range)          #For each of the IP addresses in the range of IPs
    {
        foreach ($p in $port)       #AND for each port defined
        {
            $ip = "{0}.{1}" -F $net,$r
            
                                    #If connected do the thing and write it out to screen
            if(Test-Connection -BufferSize 32 -Count 1 -Quiet -ComputerName $ip)   
            {
                $socket = new-object System.Net.Sockets.TcpClient($ip, $p)
                if($socket.Connected)
                {
                    "$ip listening to port $p"
                    $socket.Close()
                }
            }
        }
    }
}
Enter-Variables
