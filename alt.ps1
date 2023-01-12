# Import the System.DirectoryServices.ActiveDirectory namespace
Add-Type -AssemblyName System.DirectoryServices.ActiveDirectory

try {
    # Enumerate domain trusts
    $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    Write-Host "Domain trusts:"
    foreach ($trust in $domain.GetAllTrustRelationships()) {
        Write-Host "Trust: $($trust.SourceName)"
    }
} catch {
    Write-Error "An error occurred while enumerating domain trusts: $($_.Exception.Message)"
}

try {
    # Enumerate forest trusts
    $forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
    Write-Host "Forest trusts:"
    foreach ($trust in $forest.GetAllTrustRelationships()) {
        Write-Host "Trust: $($trust.SourceName)"
    }
} catch {
    Write-Error "An error occurred while enumerating forest trusts: $($_.Exception.Message)"
}
