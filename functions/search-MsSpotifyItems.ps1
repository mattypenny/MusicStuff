
function Search-MsSpotifyItems {
    <#
.SYNOPSIS
   Search and return in more powershell-y format
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string] $SearchString,
        [int]$ShowFirstHits = 5,
        $applicationName = 'spotishell'

    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction

    # foreach ($t in $(search-Item 'hilly fields nick' -type Track -ApplicationName spotishell)) { foreach ($i in $($t | select -expand tracks | select -expand items)) {foreach ($a in $($i | select -expand artists))  { [PSCustomObject]@{artist=$a.name; track = $i.name; type = $i.type}}}}

    . C:\Users\matty\OneDrive\backups\backup_of_repair_websites\Documents\PowerShell\Modules\Spotishell\1.1.1\Private\Send-SpotifyCall.ps1
    
    write-dbg "Searching for <$SearchString> with application name <$ApplicationName>"
    $tracks = search-Item $SearchString -type Track -ApplicationName spotishell
    write-dbg "`$tracks returned from search count: <$($tracks.Length)>"

    $songs = foreach ($t in $tracks) {

        $trackItems = $t | select -expand tracks | select -expand items
        write-dbg "`$trackitems count: <$($trackitems.Length)>"

        foreach ($i in $trackItems) {
            $AlbumStuff = $i | select -expand album
            

            $artists = $i | select -expand artists
            write-dbg "`$artists count: <$($artists.Length)>"

            foreach ($a in $artists) {
                [PSCustomObject]@{
                    artist   = $a.name
                    track    = $i.name
                    type     = $i.type
                    album    = $AlbumStuff.name
                    released = $AlbumStuff.release_date
                    trackid  = $i.id
                }
            }

        }

    }
   
    write-endfunction
   
    return $songs | select-object -first $ShowFirstHits
   
}