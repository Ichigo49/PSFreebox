function Set-FBXCallLogEntry {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        $EntryID
    )

    if ((Invoke-RestMethod -Uri "$global:FBXBaseURL/call/log/$EntryID" -Method Delete -Headers $global:Header).Success) {
        Write-Warning "[PSFreebox] Call (ID : $EntryID) Successfully deleted"
    } else {
        Write-Warning "[PSFreebox]Problem encountered while deleted call"
    }

}
