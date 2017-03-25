function ConvertTo-Base64 {
    <# 
    .SYNOPSIS 
    Converts a value to base-64 encoding. 
     
    .DESCRIPTION 
    For some reason. .NET makes encoding a string a two-step process. This function makes it a one-step process. 
    You're actually allowed to pass in `$null` and an empty string. If you do, you'll get `$null` and an empty string back. 
 
    .LINK 
    ConvertFrom-Base64 

    .PARAMETER Value
    The string to convert

    .PARAMETER Encoding
    Encoding of the string, by default : Unicode
     
    .EXAMPLE 
    ConvertTo-Base64 -Value 'Encode me, please!' 
     
    Encodes `Encode me, please!` into a base-64 string. 
     
    .EXAMPLE 
    ConvertTo-Base64 -Value 'Encode me, please!' -Encoding ([Text.Encoding]::ASCII) 
     
    Shows how to specify a custom encoding in case your string isn't in Unicode text encoding. 
     
    .EXAMPLE 
    'Encode me!' | ConvertTo-Base64 
     
    Converts `Encode me!` into a base-64 string. 
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [AllowNull()]
        [AllowEmptyString()]
        [string[]]
        # The value to base-64 encoding.
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
            
            $bytes = $Encoding.GetBytes($_)
            [Convert]::ToBase64String($bytes)
        }
    }
}