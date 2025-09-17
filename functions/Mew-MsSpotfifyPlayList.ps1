
function New-MsSpotifyPlaylist {
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