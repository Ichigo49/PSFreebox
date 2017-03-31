function Get-FBXDownloadStats {
    <#
        TODO : Setup help
        TODO : FullInfo switch : OK
        TODO : error management
    #>
    param(
        $BaseURL = $global:FBXBaseURL,
        [switch]$FullInfo
    )

    $DownloadStatsResult = Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/stats" -Headers $global:Header
    
    if ($DownloadStatsResult.success -eq $True) {
        Write-Warning "[PSFreebox]Successfully gather download stats"
        
        $Params = [ordered]@{
            Tasks = $DownloadStatsResult.result.nb_tasks
            TasksActive = $DownloadStatsResult.result.nb_tasks_active
            TasksDone = $DownloadStatsResult.result.nb_tasks_done
            TasksDownloading = $DownloadStatsResult.result.nb_tasks_downloading
            TasksSeeding = $DownloadStatsResult.result.nb_tasks_seeding
            TasksQueued = $DownloadStatsResult.result.nb_tasks_queued
        }
        if ($FullInfo) {
            $Params.Add("TasksStopped",$DownloadStatsResult.result.nb_tasks_stopped)
            $Params.Add("TasksError",$DownloadStatsResult.result.nb_tasks_error)
            $Params.Add("TasksChecking",$DownloadStatsResult.result.nb_tasks_checking)
            $Params.Add("TasksStopping",$DownloadStatsResult.result.nb_tasks_stopping)
            $Params.Add("TasksExtracting",$DownloadStatsResult.result.nb_tasks_extracting)
            $Params.Add("TasksRepairing",$DownloadStatsResult.result.nb_tasks_repairing)
            $Params.Add("RSS",$DownloadStatsResult.result.nb_rss)
            $Params.Add("RssUnreadItems",$DownloadStatsResult.result.nb_rss_items_unread)
            $Params.Add("ThrottlingMode",$DownloadStatsResult.result.throttling_mode)
            $Params.Add("ThrottlingIsSchedule",$DownloadStatsResult.result.throttling_is_schedule)
            $Params.Add("ThrottlingRate",$DownloadStatsResult.result.throttling_rate)
            $Params.Add("nzbConfigStatus",$DownloadStatsResult.result.nzb_config_status)
            $Params.Add("ConnReady",$DownloadStatsResult.result.conn_ready)
            $Params.Add("Peers",$DownloadStatsResult.result.nb_peer)
            $Params.Add("BlocklistEntries",$DownloadStatsResult.result.blocklist_entries)
            $Params.Add("BlocklistHits",$DownloadStatsResult.result.blocklist_hits)
            $Params.Add("dhtStats",$DownloadStatsResult.result.dht_stats)
        }

        $Params.Add("DownloadRate",$DownloadStatsResult.result.rx_rate)
        $Params.Add("UploadRate",$DownloadStatsResult.result.tx_rate)

        New-Object PSObject -Property $params



    } else {
        Write-Warning "[PSFreebox]Problem encountered while gathering download stats "
    }

}
