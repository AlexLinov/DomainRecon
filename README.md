# Poors-Man-Recon

This is a simple PowerShell script that queries all trusted domains in the current Active Directory forest, retrieves all computer objects from each, and attempts to resolve their IP addresses using DNS. Outputs results to the terminal or a CSV file.

---

## 🔍 Use Case

You've got multiple trusted domains and need to quickly:

- Enumerate all computer or server objects in each one
- Get their hostnames and resolve to IP addresses
- Export the data for further recon or analysis

Great for pentesters, red teamers, or defenders mapping their AD estate.

---

## 🚀 Usage

```powershell
# Run the script and print results to terminal
.\Script.ps1

# Run the script and export to a CSV
.\Script.ps1 -OutFile C:\Recon\trusted_computers.csv
```
## 🧠 Notes
- Requires the ActiveDirectory PowerShell module (`RSAT-AD-PowerShell`)
- Assumes you have access to query the trusted domains (usually works with two-way trust)
- Will try to resolve `DNSHostName` for each computer using `Resolve-DnsName`

## 💬 Sample Output

```
Domain           Name       Hostname                   IPAddress
---------------  ---------  -------------------------  --------------
child.local      DC01       dc01.child.local           10.1.1.1
corp.internal    APP-SVR1   app-svr1.corp.internal     10.0.10.5
otherdomain.com  FILESRV    filesrv.otherdomain.com    Unresolved
```
