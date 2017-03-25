function Get-FBXCallLog {
# Construction de l'entête
# Afficher le journal d'appel
(Invoke-RestMethod -Uri "$global:FBXBaseURL/call/log/" -Headers $global:Header).result |
Sort-Object -Descending:$false -Property datetime |
Select-Object name,type,duration,@{l='Date';e={
Get-Unixdate $_.datetime
}} | Format-Table -AutoSize
}
