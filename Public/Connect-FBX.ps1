function Connect-FBX {
    <#
        TODO : Setup help
        TODO : FullInfo switch : OK
    #>
    param(
        $BaseURL = $global:FBXBaseURL,
        $AppToken = $global:ApiToken
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

    if ($global:session.success) {
        Write-Warning "[PSFreebox] Successfully connected"
    } else {
        Write-Warning "[PSFreebox]Problem encountered while connecting"
    }
}
