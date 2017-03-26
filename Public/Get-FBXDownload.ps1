function Get-FBXDownload {
    <#
    TODO : Setup help
    TODO : FullInfo switch : OK
    #>
    param(
        $BaseURL = $global:FBXBaseURL,
        [switch]$SizeHumanReadable,
        [switch]$FullInfo
    )
    #List des downloads
    $DownloadResult = (Invoke-RestMethod -Uri "$BaseURL/downloads/" -Headers $global:Header).result
    ForEach ($download in $DownloadResult) {
        if ($SizeHumanReadable) {
            $DownloadSize = $download.size | ConvertTo-KMG
            $DownloadReceived = $download.rx_bytes | ConvertTo-KMG
            $DownloadSeeded = $download.tx_bytes | ConvertTo-KMG

        } else {
            $DownloadSize = $download.size
            $DownloadReceived = $download.rx_bytes
            $DownloadSeeded = $download.tx_bytes
        }

        $Params = [ordered]@{
            Name = $download.name
            Size = $DownloadSize
            Status = $download.status
            CreatedTime = Get-UnixDate $download.created_ts
            Type = switch ($download.type) {
                "bt"	{"bittorrent"}
                "nzb"	{"newsgroup"}
                "http"	{"HTTP"}
                "ftp"	{"FTP"}
                default {"Unknown"}
            }
            ID = $download.id
        }
        if ($FullInfo) {
            $Params.Add("Priority",$download.io_priority)
            $Params.Add("ETA",$download.eta)
            $Params.Add("Error",$download.error)
            $Params.Add("Position",$download.queue_pos)
            $Params.Add("Received",$DownloadReceived)
            $Params.Add("Seeded",$DownloadSeeded)
            $Params.Add("Ratio", [math]::Round($DownloadSeeded/$DownloadReceived,2))
        }
        New-Object PSObject -Property $params
    }
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