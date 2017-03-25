function Get-FBXCallLog {
    (Invoke-RestMethod -Uri "$global:FBXBaseURL/call/log/" -Headers $global:Header).result |
        Sort-Object -Descending:$false -Property datetime |
        Select-Object name,number,type,duration,@{l='Date';e={Get-UnixDate $_.datetime}},id,new | Format-Table -AutoSize
}
