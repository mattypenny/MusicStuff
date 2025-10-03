function Get-MsSongsFromDiscogs {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$DiscogsCode
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $uri = "https://api.discogs.com/releases/$DiscogsCode"

    try {
        $Response = invoke-restmethod $Uri -ErrorAction Stop
    
    }
    catch {
        throw "Error retrieving data from Discogs API for release code <$DiscogsCode>"
    }
   
    $LpTitle = $Response.title
    $Released = $Response.released

    $TrackList = $Response   | select -ExpandProperty tracklist 

    foreach ($Track in $TrackList) {
        try {
            $ArtistsName = $Track.artists[0].name
        }
        catch {
            $ArtistsName = ''
        }
        $ArtistSong = "$ArtistsName - $($Track.title)"
        $Artist = $ArtistsName
        $Song = $Track.title
       
        [PSCustomObject]@{
            ArtistSong = $ArtistSong
            Artist     = $Artist
            Song       = $Song
            LpTitle    = $LpTitle
            Released   = $Released
        }
    }
    write-endfunction
   
   
}