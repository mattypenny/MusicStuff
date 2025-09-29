function Get-MsListOfSongsFromFile {
    <#
.SYNOPSIS
   Read a file containing a list of tracks, and create a list of songs
.DESCRIPTION
    Read a file containing a list of tracks, 
    
.EXAMPLE
    
    
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)][string]$FileName
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    if ($Filename) {
        if (-not (Test-Path $FileName)) {
            throw "File $FileName does not exist"
        }
        # reading the file
        $fileContent = Get-Content $FileName

        $ListOfSongs = foreach ($line in $fileContent) {

            if (!($line)) {
                continue
            }
            if ($line -match '^\s*#') {
                continue
            }
            if ($line -match '^\s*$') {
                continue
            }
            write-dbg "`$line: <$line>"

            [PSCustomObject]@{
                Song = $Line
            }
        }
    }
    if (-not $ListOfSongs) {
        throw "No songs found in file $FileName"
    }    

    return $ListOfSongs
}
 