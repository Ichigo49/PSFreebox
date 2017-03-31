function Get-FBXDownloadTaskLog {
    <#
        TODO : Setup help
        TODO : error management
    #>
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$EntryID
    )
    
    $DownloadTaskLogResult = (Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/$EntryID/log" -Headers $global:Header).result
    $DownloadTaskLogResult
}
