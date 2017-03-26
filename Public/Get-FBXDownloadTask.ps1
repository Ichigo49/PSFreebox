function Get-FBXDownloadTask {
    <#
        TODO : Setup help
        TODO : error management
    #>
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$EntryID,
        [switch]$SizeHumanReadable,
        [switch]$FullInfo
    )
    #List des downloads
    $DownloadTaskResult = (Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/$EntryID" -Headers $global:Header).result
    $Ratio = [math]::Round($DownloadTaskResult.tx_bytes/$DownloadTaskResult.rx_bytes,2)
    if ($SizeHumanReadable) {
        $DownloadSize = $DownloadTaskResult.size | ConvertTo-KMG
        $DownloadReceived = $DownloadTaskResult.rx_bytes | ConvertTo-KMG
        $DownloadSeeded = $DownloadTaskResult.tx_bytes | ConvertTo-KMG

    } else {
        $DownloadSize = $DownloadTaskResult.size
        $DownloadReceived = $DownloadTaskResult.rx_bytes
        $DownloadSeeded = $DownloadTaskResult.tx_bytes
    }

    $Params = [ordered]@{
        Name = $DownloadTaskResult.name
        Size = $DownloadSize
        Status = $DownloadTaskResult.status
        CreatedTime = Get-UnixDate $DownloadTaskResult.created_ts
        Type = switch ($DownloadTaskResult.type) {
            "bt"	{"bittorrent"}
            "nzb"	{"newsgroup"}
            "http"	{"HTTP"}
            "ftp"	{"FTP"}
            default {"Unknown"}
        }
        ID = $DownloadTaskResult.id
    }
    if ($FullInfo) {
        $Params.Add("Priority",$DownloadTaskResult.io_priority)
        $Params.Add("ETA",$DownloadTaskResult.eta)
        $Params.Add("Error",$DownloadTaskResult.error)
        $Params.Add("Position",$DownloadTaskResult.queue_pos)
        $Params.Add("Received",$DownloadReceived)
        $Params.Add("Seeded",$DownloadSeeded)
        $Params.Add("Ratio",$Ratio)
    }
    New-Object PSObject -Property $params
}

<#
A stop_ratio of 150 means that the task will stop seeding once tx_bytes/rx_bytes ratio
rx_bytes         : 13150000000
tx_bytes         : 1340000000
download_dir     : L0Rpc3F1ZSBkdXIvVMOpbMOpY2hhcmdlbWVudHMv
archive_password :
eta              : 0
status           : queued
io_priority      : normal
type             : bt
queue_pos        : 1
id               : 277
created_ts       : 1488149446
stop_ratio       : 150
tx_rate          : 0
name             : Fantastic.Beasts.and.Where.to.Find.Them.2016.MULTI.1080p.BluRay.x264-NLX5.mkv
tx_pct           : 680
rx_pct           : 10000
rx_rate          : 0
error            : none
size             : 13150000000


#>