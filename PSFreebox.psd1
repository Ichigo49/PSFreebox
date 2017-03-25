@{
    RootModule = 'PSFreebox.psm1'
    ModuleVersion = '0.0.1'
    GUID = '21d8a5de-dd5c-46e8-9790-7cd5beb1f113'
    Author = 'Mathieu (Ichigo49) ALLEGRET'
    CompanyName = 'home.mal'
    Copyright = '(c) 2017 Mathieu (Ichigo49) Allegret. All rights reserved.'
    Description = 'Module for managing Freebox Server.'
    PowerShellVersion = '3.0'
    FunctionsToExport = '*'
    CmdletsToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{
            Tags = @('Utilities', 'Freebox')
            LicenseUri = 'https://github.com/Ichigo49/PSFreebox/blob/master/LICENSE'
            ProjectUri = 'https://github.com/Ichigo49/PSFreebox'
            IconUri = 'https://cdn.rawgit.com/Windos/BurntToast/master/Media/BurntToast-Logo.png'
            ReleaseNotes = '
* For now, everything has to be implemented !
* First Commit : stuff in the psm1 file, has to be splitted in files under \Public
* Source for the Freebox API : 
* http://dev.freebox.fr/sdk/os/
'
        }
    }
}
