function Set-FBXDownloadTask {
    <#
        TODO : Setup help
        TODO : error management
    #>
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$EntryID,
        [ValidateSet("stopped","queued","downloading","retry")]
        [string]$Status,
        [string]$Position,
        [ValidateSet("low","normal","high")]
        [string]$Priority
    )

$SetDownloadTaskJson = @"
{

"@

    if ($Status) {
$SetDownloadTaskJson += @"
    `"status`": $Status`n
"@
    }
    if ($Position) {
$SetDownloadTaskJson += @"
    `"queue_pos`": $Position`n
"@
    }
    if ($Priority) {
$SetDownloadTaskJson += @"
    `"io_priority`": $Priority`n
"@
    }

$SetDownloadTaskJson += @"
}
"@

    $SetDownloadTask = Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/$EntryID"  -Method Put -Body $SetDownloadTaskJson -Headers $global:Header
    if ($SetDownloadTask.success -eq $True) {
        Write-Warning "[PSFreebox] Successfully updated Download Task $EntryID"
        $True
    } else {
        Write-Warning "[PSFreebox] Failed to update Download Task $EntryID"
        Write-Warning "[PSFreebox] Error : $SetCallEntry.error_code"
        $False
    }


}