function ConvertFrom-Base64 {
    <# 
    .SYNOPSIS 
    Converts a base-64 encoded string back into its original string. 
     
    .DESCRIPTION 
    For some reason. .NET makes encoding a string a two-step process. This function makes it a one-step process. 
    You're actually allowed to pass in `$null` and an empty string. If you do, you'll get `$null` and an empty string back. 
 
    .LINK 
    ConvertTo-Base64 

    .PARAMETER Value
    The encoded string to convert from base64

    .PARAMETER Encoding
    Encoding of the encoded string, by default : Unicode
     
    .EXAMPLE 
    ConvertFrom-Base64 -Value 'RW5jb2RlIG1lLCBwbGVhc2Uh' 
     
    Decodes `RW5jb2RlIG1lLCBwbGVhc2Uh` back into its original string. 
     
    .EXAMPLE 
    ConvertFrom-Base64 -Value 'RW5jb2RlIG1lLCBwbGVhc2Uh' -Encoding ([Text.Encoding]::ASCII) 
     
    Shows how to specify a custom encoding in case your string isn't in Unicode text encoding. 
     
    .EXAMPLE 
    'RW5jb2RlIG1lIQ==' | ConvertFrom-Base64 
     
    Shows how you can pipeline input into `ConvertFrom-Base64`. 
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [string[]]
        # The base-64 string to convert.
        $Value,
        
        [Text.Encoding]
        # The encoding to use. Default is Unicode.
        $Encoding = ([Text.Encoding]::Unicode)
    )
    
    begin
    {
        Set-StrictMode -Version 'Latest'
    }

    process
    {
        $Value | ForEach-Object {
            if( $_ -eq $null )
            {
                return $null
            }
            
            $bytes = [Convert]::FromBase64String($_)
            $Encoding.GetString($bytes)
        }
    }
}