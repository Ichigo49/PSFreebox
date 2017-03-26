function Remove-FBXDownloadTask {
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        $EntryID,
        [switch]$Permanently
    )

    $URL = "$global:FBXBaseURL/downloads/$EntryID"
    $MessagePart = "remov"
    if ($Permanently) {
        $URL += "/erase"
        $MessagePart = "eras"
    }

    if ((Invoke-RestMethod -Uri $URL -Method Delete -Headers $global:Header).Success) {
        $Message = "[PSFreebox] Download Task (ID : $EntryID) Successfully " + $MessagePart + "ed"
    } else {
        $Message = "[PSFreebox]Problem encountered while " + $MessagePart + "ing download task"
    }
    Write-Warning $Message
}
