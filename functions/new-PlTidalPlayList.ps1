
function New-PlSpotifyPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        $ClientId     ,
        $ClientSecret ,
        $PlaylistFolder      ,
        $PlaylistName        
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $playlistParams = @{
        UserId          = (Get-SpoCurrentUserProfile -ApplicationName $ApplicationName).id
        Name            = $PlaylistName
        Description     = $PlaylistDescription
        ApplicationName = $ApplicationName
    }

    $Playlist = New-SpoPlaylist @playlistParams

    write-dbg "`$Playlist count: <$($Playlist.Length)>"
    write-endfunction
   
    return $Playlist
   
}