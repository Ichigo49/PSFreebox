function Get-FBXDownload {
    param(
        $BaseURL = $global:FBXBaseURL,
        [switch]$FullInfo
    )
    #List des downloads
    $DownloadResult = (Invoke-RestMethod -Uri "$BaseURL/downloads/" -Headers $global:Header).result
    ForEach ($download in $DownloadResult) {
        
        $Params = [ordered]@{
            Name = $download.name
            Size = $download.size | ConvertTo-KMG
            Status = $download.status
            CreatedTime = Get-UnixDate $download.created_ts
            ID = $download.id
            Type = switch ($download.type) {
                "bt"	{"bittorrent"}
                "nzb"	{"newsgroup"}
                "http"	{"HTTP"}
                "ftp"	{"FTP"}
                default {"Unknown"}
            }
        }
        New-Object PSObject -Property $params
    }
}

<#

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