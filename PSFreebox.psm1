$global:FBXApi = Invoke-RestMethod -Uri http://mafreebox.freebox.fr/api_version
$global:FBXBaseURL = "http://mafreebox.freebox.fr$($global:FBXApi.api_base_url)v$([int]$global:FBXApi.api_version)"
$global:ApiTokenFile =  "$Home\.fbx\fbx.key"
if ((Test-Path $global:ApiKeyFile) -eq $True) {
    $global:ApiToken = Get-Content $global:ApiTokenFile
} else {
    Write-Warning "[PSFreebox] First, you need to run Initialize-FBXConnection to create your token"
}

<#
# dot-source all function files
Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }

# Export all commands except for Test-ElevatedShell
Export-ModuleMember –Function @(Get-Command –Module $ExecutionContext.SessionState.Module | Where-Object {$_.Name -ne "Test-ElevatedShell"})

#>


#base64 pour les chemins dans les download [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(""))

