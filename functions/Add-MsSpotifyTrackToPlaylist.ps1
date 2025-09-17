function Add-MsSpotifyTrackToPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]$PlaylistId,
        [Parameter(Mandatory = $True)]$TrackId,
        [Parameter(Mandatory = $True)][string]$ApplicationName 
   
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    if ($PlaylistId -notmatch '^[a-zA-Z0-9]{22}$') {
        write-dbg "Invalid PlaylistId: <$PlaylistId>"
        throw "Invalid PlaylistId: <$PlaylistId>"
    }
    else {
        write-dbg "PlaylistId OK: <$PlaylistId>"
    }
    if ($TrackId -notmatch '^[a-zA-Z0-9]{22}$') {
        write-dbg "Invalid TrackId: <$TrackId>"
        throw "Invalid TrackId: <$TrackId>"
    }
    else {
        write-dbg "TrackId OK: <$TrackId>"
    }

    try {
        $TrackId = "spotify:track:$TrackId"
        write-dbg "Adding track <$TrackId> to playlist <$PlaylistId> with application name <$ApplicationName>"
        Add-PlaylistItem -Id $PlaylistId -ItemId $TrackId -ApplicationName $ApplicationName
        $TrackAdded = $True
    }
    catch {
        write-error "Error adding track to playlist: $_"
        $TrackAdded = $False
    }
    write-endfunction

    return $TrackAdded
   
   
}
