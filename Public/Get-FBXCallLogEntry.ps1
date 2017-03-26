function Get-FBXCallLogEntry {
    <#
        TODO : Setup help
        TODO : FullInfo switch : OK
    #>
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        $EntryID
    )
    $CallEntry = (Invoke-RestMethod -Uri "$global:FBXBaseURL/call/log/$EntryID" -Headers $global:Header).result

    $Params = [ordered]@{
        Name = $CallEntry.name
        Number = $CallEntry.number
        Type = $CallEntry.type
        Duration = $CallEntry.duration
        Date = Get-UnixDate $CallEntry.datetime
        ID = $CallEntry.id
        New = $CallEntry.new
    }
    New-Object PSObject -Property $params

}
