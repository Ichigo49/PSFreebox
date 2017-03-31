function Get-FBXDownloadFiles {
    <#
        TODO : Setup help
        TODO : FullInfo switch : OK
    #>
    param (
        [string]$DownloadID,
        [switch]$SizeHumanReadable
    )
    
    #List des fichiers
    $DownloadFileResult = (Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/$DownloadID/files" -Headers $global:Header).result
    ForEach ($File in $DownloadFileResult) {
        if ($SizeHumanReadable) {
            $FileSize = $File.size | ConvertTo-KMG
        } else {
            $FileSize = $File.size
        }
        $Params = [ordered]@{
            Name = $File.name
            Size = $FileSize
            Status = $File.status
            ID = $File.id
            ParentID = $File.task_id
            Path = $File.path
            MimeType = $File.mimetype
        }
        New-Object PSObject -Property $params
    }

}
