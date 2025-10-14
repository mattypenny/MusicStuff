function New-PlPlaylistFromSource {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string][ValidateSet(
            'CrucialTracksPlaylist', 
            'CrucialTracksPrompt', 
            'File',
            'DiscogsCode'
        )] 
        $SourceType,
        [Parameter(Mandatory = $False)][string]$SourceURL,
        [Parameter(Mandatory = $False)][string]$SourceCrucialTracksPrompt,
        [Parameter(Mandatory = $False)][string]$FileName,
        [Parameter(Mandatory = $False)][string]$DiscogsCode,
        [Parameter(Mandatory = $False)][string]$TargetType,
        [Parameter(Mandatory = $True)][string]$TargetPlaylistName,
        [Parameter(Mandatory = $False)][string]$TargetPlaylistFolder,
        [Parameter(Mandatory = $False)][string]$TargetPlaylistDescription
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction

    switch ($SourceType) {
        'CrucialTracksPlaylist' {
            $SongObjects = Get-PlSongsFromCrucialTracksCommunityPlaylist -CrucialTracksCommunityPlaylistURL $SourceURL
            $Songs = $SongObjects.ArtistSong
        }
        'CrucialTracksPrompt' {
            $Songs = Get-PlSongsFromCrucialTracksPrompt -CrucialTracksPrompt $SourceCrucialTracksPrompt
        }
        'File' {
            $Songs = Get-PlListOfSongsFromFile -FileName $FileName
        }
        'DiscogsCode' {
            $SongObjects = Get-PlSongsFromDiscogs -DiscogsCode $DiscogsCode
            $Songs = $SongObjects.ArtistSong
        }
        default {
            throw "Unknown SourceType: <$SourceType>"
        }
    }


    $NewPlaylistFromListParams = @{
        ListOfSongs         = $Songs
        PlaylistName        = $TargetPlaylistName
        ApplicationName     = 'spotishell'
        PlaylistFolder      = $TargetPlaylistFolder
        PlaylistDescription = $TargetPlaylistDescription
    }

    $SpotifyPlayList = New-PlSpotifyPlaylistFromList @NewPlaylistFromListParams
 
    write-endfunction
   
    return $SpotifyPlayList
   
}