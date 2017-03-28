function Get-FBXDownloadTask {
    <#
        TODO : Setup help
        TODO : error management
    #>
    param(
        [ValidateNotNullOrEmpty()]
        [string]$DownloadURL,

        [ValidateNotNullOrEmpty()]
        [string[]]$DownloadURLList,
        
        [ValidateNotNullOrEmpty()]
        [string]$DownloadFile,
        
        [ValidateNotNullOrEmpty()]
        [string]$DownloadPath,
        
        [ValidateNotNullOrEmpty()]
        [string]$UserName,
        
        [ValidateNotNullOrEmpty()]
        [string]$Password,
        
        [ValidateNotNullOrEmpty()]
        [string]$ArchPassword,
        
        [ValidateNotNullOrEmpty()]
        [string]$Cookies,

        [ValidateNotNullOrEmpty()]
        [switch]$recurse

    )

    $AddDownloadTask = @{}

    $ContentType = "application/x-www-form-urlencoded"

    if (-not $DownloadURL -and -not $DownloadURLList -and -not $DownloadFile) {
        throw "Msut set one of the following parameters : DownloadURL, DownloadURLList or DownloadFile"
    }

    if ($DownloadURL) {
        $AddDownloadTask.add("download_url",$DownloadURL)
    }

    if ($DownloadURLList) {
        $AddDownloadTask.add("download_url_list",$DownloadURLList)
    }    
    
    if ($DownloadFile) {
        $ContentType = "multipart/form-data"
        $FileContent = [IO.File]::ReadAllBytes($DownloadFile)
        $AddDownloadTask.add("download_file",$FileContent)
    }    
    
    if ($DownloadPath) {
        $DownloadPathBase64 = $DownloadPath | ConvertTo-Base64
        $AddDownloadTask.add("download_dir",$DownloadPathBase64)
    }
    
    if ($UserName) {
        $AddDownloadTask.add("username",$UserName)
    }
    
    if ($Password) {
        $AddDownloadTask.add("password",$Password)
    }
    
    if ($ArchPassword) {
        $AddDownloadTask.add("archive_password",$ArchPassword)
    }
    
    if ($Cookies) {
        $AddDownloadTask.add("cookies",$Cookies)
    }

    if ($recurse) {
        $AddDownloadTask.add("recursive","true")
    }


    #Pour les DownloadFile, voir si bon comme ça ou si on rajoute a la place du readallbytes le param -InFile pour invoke-restmethod

    $AddDownloadTaskResult = Invoke-RestMethod -Uri "$global:FBXBaseURL/downloads/add" -Body $AddDownloadTask -Method Post -ContentType $ContentType -Headers $global:Header
    if ($AddDownloadTaskResult.success -eq $True) {
        $NewEntryId = $AddDownloadTaskResult.result.id -join ","
        Write-Warning "[PSFreebox]New download task Successfully added, ID : $NewEntryId"
        Get-FBXDownloadTask -EntryId $NewEntryId
    } else {
        Write-Warning "[PSFreebox]Problem encountered while adding new download task"
    }

}
