function New-MsPlaylistFromSource {
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
        [Parameter(Mandatory = $False)][string]$SourceFilePath,
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
            $SongObjects = Get-MsSongsFromCrucialTracksCommunityPlaylist -CrucialTracksCommunityPlaylistURL $SourceURL
            $Songs = $SongObjects.ArtistSong
        }
        'CrucialTracksPrompt' {
            $Songs = Get-MsSongsFromCrucialTracksPrompt -CrucialTracksPrompt $SourceCrucialTracksPrompt
        }
        'File' {
            $Songs = Get-MsListOfSongsFromFile -FilePath $SourceFilePath
        }
        'DiscogsCode' {
            $SongObjects = Get-MsSongsFromDiscogs -DiscogsCode $DiscogsCode
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

    $SpotifyPlayList = New-MsSpotifyPlaylistFromList @NewPlaylistFromListParams
 
    write-endfunction
   
    return $SpotifyPlayList
   
}