$global:FBXApi = Invoke-RestMethod -Uri http://mafreebox.freebox.fr/api_version
$global:FBXBaseURL = "http://mafreebox.freebox.fr$($global:FBXApi.api_base_url)v$([int]$global:FBXApi.api_version)"            
$global:ApiKey = Get-Content $Home\.fbx\fbx.key

<#
# dot-source all function files
Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }

# Export all commands except for Test-ElevatedShell
Export-ModuleMember –Function @(Get-Command –Module $ExecutionContext.SessionState.Module | Where-Object {$_.Name -ne "Test-ElevatedShell"})

#>

function Initialize-FBXConnection {
# Déclarer l'application            
$AuthJson = @'
{
   "app_id": "fr.freebox.testapp",
   "app_name": "Test App",
   "app_version": "1.0.0",
   "device_name": "Mon PC"
}
'@            

    # Demander l'autorisation
    $post = Invoke-RestMethod -Uri "$BaseURL/login/authorize" -Method Post -Body $AuthJson

    $statusToken = Invoke-RestMethod -Uri "$BaseURL/login/authorize/$($post.result.track_id)"
    # Requete GET pour interroger le statut
    while ($statusToken.result.status -eq "pending") {
    $statusToken = Invoke-RestMethod -Uri "$BaseURL/login/authorize/$($post.result.track_id)"
    Start-Sleep -Seconds 1
    }

    if ($statusToken.result.status -eq "granted") {
        "Bravo, application autorisée"
        "le app_token secret à conserver est: {0}" -f $post.result.app_token
    } else {
        "Echec: résultat du processus d'autorisation: {0}" -f $statusToken.result.status
    }
}
#ouverture session
function Connect-FBX {
    param(
        $BaseURL = $global:FBXBaseURL,
        $AppToken = $ApiKey
    )
    $Challenge = (Invoke-RestMethod -Uri "$BaseURL/login").result.challenge

    # password = hmac-sha1(app_token, challenge)
    # http://leftshore.wordpress.com/2010/10/04/hmac-sha1-using-powershell/
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA1
    $hmacsha.key = [Text.Encoding]::ASCII.GetBytes($AppToken)
    $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($Challenge))
    $password = [string]::join("", ($signature | % {([int]$_).toString('x2')}))

$SessionJson = @"
{
    `"app_id`": `"fr.freebox.testapp`",
    `"password`": `"$($password)`"
}
"@

    $global:session = Invoke-RestMethod -Uri "$BaseURL/login/session/" -Method Post -Body $SessionJson
    $global:Header = @{'X-Fbx-App-Auth' = $($global:session.result.session_token)}

    'ouverture de la session avec succes: {0}' -f $global:session.success
    'le session_token est: {0}' -f $global:session.result.session_token
    # Afficher les permissions
    $global:session.result.permissions
}

function Get-FBXCallLog {
# Get-Unixdate from http://thepowershellguy.com
Function Get-Unixdate ($UnixDate){
 [timezone]::CurrentTimeZone.ToLocalTime(
  ([datetime]'01/01/1970 00:00:00').AddSeconds($UnixDate)
 )
}
# Construction de l'entête
# Afficher le journal d'appel
(Invoke-RestMethod -Uri "$global:FBXBaseURL/call/log/" -Headers $global:Header).result |
Sort-Object -Descending:$false -Property datetime |
Select-Object name,type,duration,@{l='Date';e={
Get-Unixdate $_.datetime
}} | Format-Table -AutoSize
}

function Get-FBXDownload {
#List des downloads
(Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/" -Headers $global:Header).result
}

#base64 pour les chemins dans les download [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(""))
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
#list des fichier d'un download
function Get-FBXDownloadFiles {
    param (
        $dlID
    )
(Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/$dlID/files" -Headers $global:Header).result
}
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