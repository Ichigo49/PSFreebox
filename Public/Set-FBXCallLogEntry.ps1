function Set-FBXCallLogEntry {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        $EntryID,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        $New
    )

$SetCallJson = @"
{
    `"new`": $New
}
"@

    $SetCallEntry = Invoke-RestMethod -Uri "$global:FBXBaseURL/call/log/$EntryID" -Method Put -Body $SetCallJson -Headers $global:Header
    if ($SetCallEntry.success -eq $True) {
        Write-Warning "[PSFreebox] Successfully updated Call Log Entry $EntryID"
        $True
    } else {
        Write-Warning "[PSFreebox] Failed to update Call Log Entry $EntryID"
        Write-Warning "[PSFreebox] Error : $SetCallEntry.error_code"
        $False
    }
}
