param (
    [string]$OutFile
)

if ($OutFile) {
    "Domain,Name,Hostname,IPAddress" | Out-File -FilePath $OutFile -Encoding UTF8
}

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

            $result = [PSCustomObject]@{
                Domain    = $domain
                Name      = $computer.Name
                Hostname  = $hostname
                IPAddress = $ip
            }

            if ($OutFile) {
                $result | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Out-File -FilePath $OutFile -Append -Encoding UTF8
            } else {
                $result
            }
        }

    } catch {
        Write-Warning "Could not query $domain. $_"
    }
}
