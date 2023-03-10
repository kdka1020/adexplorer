## Main - Enumerate Forests and Domains from local domain admin perspective.

# Check if RSAT is installed
if (!(Get-WindowsFeature -Name RSAT-AD-PowerShell -ErrorAction SilentlyContinue)) {
    $install = (Read-Host "RSAT is not installed. Do you want to install it? (y/n)").ToLower()
    if ($install -eq "y") {
        try {
            # Install RSAT
            Add-WindowsFeature -Name RSAT-AD-PowerShell
            Write-Host "RSAT was installed successfully."
        } catch {
            Write-Error "An error occurred while installing RSAT: $($_.Exception.Message)"
            Exit
        }
    } else {
        Exit
    }
}

# Check if user has permissions to enumerate domain and forest trusts
if (!(Get-AdUser -Identity (Get-AdPrincipalGroupMembership -Identity $env:USERNAME -MemberOf | Where-Object {$_.Name -eq "Domain Admins"}))) {
    Write-Error "You do not have sufficient permissions to enumerate domain and forest trusts. Please run the script as a user with the 'Domain Admins' group membership."
    Exit
}

# Enumerate domain trusts
Write-Host "Domain trusts:"
try {
    Get-ADDomain | Select-Object Name, Parent, Trusts
} catch {
    Write-Error "An error occurred while enumerating domain trusts: $($_.Exception.Message)"
}

# Enumerate forest trusts
Write-Host "Forest trusts:"
try {
    Get-ADForest | Select-Object Name, Trusts
} catch {
    Write-Error "An error occurred while enumerating forest trusts: $($_.Exception.Message)"
}
