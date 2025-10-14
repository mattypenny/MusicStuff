function New-PlSpotifyPlaylistFromList {
    <#
.SYNOPSIS
   create a playlist from a supplied list of songs
.DESCRIPTION
.EXAMPLE
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)][string[]]$ListOfSongs,
        [Parameter(Mandatory = $True)][string]$PlaylistName,
        [string]$ApplicationName = 'spotishell',
        [string]$PlaylistFolder = 'Created by spotishell',
        [string]$PlaylistDescription = "Created from file $FileName on $(get-date)"
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    # create the playlist
    
    $NewPlaylistParams = @{
        PlaylistName        = $PlaylistName
        ApplicationName     = $ApplicationName
        PlaylistFolder      = $PlaylistFolder
        PlaylistDescription = $PlaylistDescription
    }
    $playlist = New-PlSpotifyPlaylist @NewPlaylistParams
   
    foreach ($line in $ListOfSongs) {
        write-dbg "`$line: <$line>"
        write-dbg "`$ArtistSong: <$ArtistSong>"
        $SplatParameters = @{
            SearchString    = $line
            ShowFirstHits   = 25
            ApplicationName = $ApplicationName
        }
        $track = Search-PlSpotifyItems @SplatParameters

        $SelectedTrack = $track | select  track,
        artist,
        album,
        released,  
        @{Label        = 'Line'
            expression = { 
                $line 
            } 
        },
        trackid | Out-GridView -OutputMode Single -Title "Select track for line <$line>" 
        
        if ($SelectedTrack) {
            $TrackId = $SelectedTrack.trackid
            $Track = $SelectedTrack.track
            $Artist = $SelectedTrack.artist
            write-dbg "User selected: <$Track> by <$Artist> which has a Spotty id of <$TrackId>"

            Add-PlSpotifyTrackToPlaylist -PlaylistId $playlist.Id -TrackId $SelectedTrack.TrackId -ApplicationName $ApplicationName
        }
        else {
            write-dbg "User did not select a track for line <$line>"
        }
    }
    write-endfunction
   
   
}


