param (
    [string]$OutFile
)

$results = @()
$trustedDomains = Get-ADTrust -Filter * | Select-Object -ExpandProperty Name

foreach ($domain in $trustedDomains) {
    Write-Host "`n===== $domain ====="

    try {
        $computers = Get-ADComputer -Filter * -Server $domain -Properties DNSHostName |
                     Where-Object { $_.DNSHostName }

        foreach ($computer in $computers) {
            $hostname = $computer.DNSHostName

            try {
                $ip = (Resolve-DnsName -Name $hostname -ErrorAction Stop | Where-Object { $_.Type -eq "A" }).IPAddress
            } catch {
                $ip = "Unresolved"
            }

            $results += [PSCustomObject]@{
                Domain    = $domain
                Name      = $computer.Name
                Hostname  = $hostname
                IPAddress = $ip
            }
        }

    } catch {
        Write-Warning "Could not query $domain. $_"
    }
}

if ($OutFile) {
    $results | Export-Csv -Path $OutFile -NoTypeInformation
    Write-Host "`nResults written to $OutFile"
} else {
    $results | Format-Table -AutoSize
}
