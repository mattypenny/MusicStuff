function New-MuSpotifyPlaylistFromList {
    <#
.SYNOPSIS
   Read a file containing a list of tracks, and create a playlist from the tracks in the file. 
.DESCRIPTION
    Read a file containing a list of tracks, and create a playlist from the tracks in the file. 
    The user will be prompted to select the correct track from a list of tracks that match the search string.
.EXAMPLE
    New-MuSpotifyPlaylistFromFile -FileName 'C:\temp\BestPsychobilly.txt' -PlaylistName 'Best Psychobilly'
    This will create a playlist called 'Best Psychobilly' from the tracks in the file 'C:\temp\BestPsychobilly.txt'
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)][string]$FileName,
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
    $playlist = New-MuSpotifyPlaylist @NewPlaylistParams
   
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

    foreach ($line in $ListOfSongs) {
        $SplatParameters = @{
            SearchString    = $line
            ShowFirstHits   = 5
            ApplicationName = $ApplicationName
        }
        $track = Search-MuSpotifyItems @SplatParameters

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

            Add-MuSpotifyTrackToPlaylist -PlaylistId $playlist.Id -TrackId $SelectedTrack.TrackId -ApplicationName $ApplicationName
        }
        else {
            write-dbg "User did not select a track for line <$line>"
        }
    }
    write-endfunction
   
   
}

function New-MuSpotifyPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        $ApplicationName     ,
        $PlaylistDescription ,
        $PlaylistFolder      ,
        $PlaylistName        
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $Playlist = New-Playlist -UserId (Get-CurrentUserProfile -ApplicationName $ApplicationName).id -Name $PlaylistName -Description $PlaylistDescription -ApplicationName $ApplicationName
   
    write-dbg "`$Playlist count: <$($Playlist.Length)>"
    write-endfunction
   
    return $Playlist
   
}
function Add-MuSpotifyTrackToPlaylist {
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

