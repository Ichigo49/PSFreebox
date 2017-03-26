function Disconnect-FBX {
    <#
        TODO : Setup help
    #>
    param(
        $BaseURL = $global:FBXBaseURL
    )
    if ((Invoke-RestMethod -Uri "$BaseURL/login/logout/" -Headers $global:Header -Method post).Success) {
        Write-Warning "[PSFreebox] Successfully disconnected"
    } else {
        Write-Warning "[PSFreebox]Problem encountered while disconnecting"
    }
}
