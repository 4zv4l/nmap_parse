# Path to File containing nmap result
param(
    [Parameter(Mandatory)]
    [string] $Path
)
$result = @{}
$ip = ""

foreach($line in Get-Content $Path) {
    if ($line -match 'Nmap scan report for (.+)') {
        $ip = $Matches.1
    }

    if ($line -match '(\d+)/(tcp|udp) (open)  ([^ ]+)') {
        if ( ! $result[$Matches.1]) {
            $result[$Matches.1] = @{ port = ""; service = ""; ips = @() }
        }
        $result[$Matches.1].port = $Matches.2
        $result[$Matches.1].service = $Matches.4
        $result[$Matches.1].ips += $ip
    }
}

$result.Keys |  
Sort-Object { [int]$_ } | 
% { '{0,-5} | {1} | {2,15} | {3}' -f $_, $result[$_].port, $result[$_].service, ($result[$_].ips -join ', ') }
