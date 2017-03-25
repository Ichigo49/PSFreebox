function Get-FBXDownloadFiles {
    param (
        $DownloadID
    )
    (Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/$DownloadID/files" -Headers $global:Header).result
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