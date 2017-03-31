$global:FBXApi = Invoke-RestMethod -Uri http://mafreebox.freebox.fr/api_version
$global:FBXBaseURL = "https://mafreebox.freebox.fr$($global:FBXApi.api_base_url)v$([int]$global:FBXApi.api_version)"
$global:ApiTokenFile =  "$Home\.fbx\fbx.key"
if ((Test-Path $global:ApiTokenFile -ErrorAction SilentlyContinue) -eq $True) {
    $global:ApiToken = Get-Content $global:ApiTokenFile
} else {
    Write-Warning "[PSFreebox] First, you need to run Initialize-FBXConnection to create your token"
}

    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
    
    Foreach($Import in @($Public + $Private))
    {
        Try
        {
            . $Import.FullName
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($Import.FullName): $_"
        }
    }
    
    $ModuleMembers = $Public.BaseName
    
    Export-ModuleMember -Function $ModuleMembers


#base64 pour les chemins dans les download [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(""))

