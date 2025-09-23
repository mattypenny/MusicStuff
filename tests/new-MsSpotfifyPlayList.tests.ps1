
describe "function New-MsSpotifyPlaylist" {
    
    It "creates a new playlist" {

        $Now = Get-Date -Format "yyyyMMdd-HHmmss"

        $Params = @{
            ApplicationName = "spotishell" 
            PlaylistName = "Test Playlist - $Now" 
            PlaylistDescription = "This is a test playlist created by Pester on $(get-date)" 
            PlaylistFolder = "Test Playlists"
        }
        
        $result = New-MsSpotifyPlaylist @Params 
        
        $result | Should -Not -BeNullOrEmpty
        $result | Should -HaveProperty "Id"
        $result | Should -HaveProperty "Name"
        $result.Name | Should -Be "Test Playlist"
        $result | Should -HaveProperty "Description"
        $result.Description | Should -Be "This is a test playlist created by Pester"
        
    }

}