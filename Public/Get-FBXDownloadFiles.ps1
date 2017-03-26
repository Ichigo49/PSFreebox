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

#list des fichier d'un download
<#

path     : /Disque dur/Téléchargements///[-SeT-]_Kanon_2006_21_VostFr_[BD_1080p_10bit]_[5bce2f48].mkv
id       : 342-0
task_id  : 342
filepath : L0Rpc3F1ZSBkdXIvVMOpbMOpY2hhcmdlbWVudHMvLy9bLVNlVC1dX0thbm9uXzIwMDZfMjFfVm9zdEZyX1tCRF8xMDgwcF8xMGJpdF1fWzVi
           Y2UyZjQ4XS5ta3Y=
mimetype : video/x-matroska
name     : [-SeT-]_Kanon_2006_21_VostFr_[BD_1080p_10bit]_[5bce2f48].mkv
rx       : 1272908955
status   : done
priority : normal
error    : none
size     : 1272908955


#>