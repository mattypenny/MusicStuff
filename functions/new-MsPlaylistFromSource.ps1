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
            'File'
        )] 
        $SourceType,
        [Parameter(Mandatory = $True)][string]$SourceURL,
        [Parameter(Mandatory = $True)][string]$SourceCrucialTracksPrompt,
        [Parameter(Mandatory = $True)][string]$SourceFilePath,
        [Parameter(Mandatory = $True)][string]$TargetType,
        [Parameter(Mandatory = $True)][string]$TargetPlaylistName,
        [Parameter(Mandatory = $True)][string]$TargetPlaylistFolder,
        [Parameter(Mandatory = $True)][string]$TargetPlaylistDescription
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction

    switch ($SourceType) {
        'CrucialTracksPlaylist' {
            $Tracks = New-MsSpotifyPlaylistFromCrucialTracksCommunityPlaylist -CrucialTracksCommunityPlaylistURL $SourceURL
        }
        'CrucialTracksPrompt' {
            $Tracks = New-MsSpotifyPlaylistFromCrucialTracksPrompt -CrucialTracksPrompt $SourceCrucialTracksPrompt
        }
        'File' {
            $Tracks = New-MsSpotifyPlaylistFromList -FilePath $SourceFilePath
        }
        default {
            throw "Unknown SourceType: <$SourceType>"
        }
    }
   
   
    write-endfunction
   
    return $Tracks
   
}