Function Get-UnixDate {
    param (
        $UnixDate
    )
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'01/01/1970 00:00:00').AddSeconds($UnixDate))
}
