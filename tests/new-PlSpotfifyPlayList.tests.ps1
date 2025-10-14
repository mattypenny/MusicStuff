
describe "function New-PlSpotifyPlaylist" {
    
    It "creates a new playlist" {

        import-module -Name PlaylistStuff -Force
        $Now = Get-Date -Format "yyyyMMdd-HHmmss"

        $Params = @{
            ApplicationName     = "spotishell" 
            PlaylistName        = "Test Playlist - $Now" 
            PlaylistDescription = "This is a test playlist created by Pester on $Now" 
            PlaylistFolder      = "Test playlists"
        }
        
        $result = New-PlSpotifyPlaylist @Params 
        
        $result | Should -Not -BeNullOrEmpty
        # $result | Should -HaveProperty "Id"
        # $result | Should -HaveProperty "Name"
        $result.Name | Should -Be "Test Playlist - $Now"
        # $result | Should -HaveProperty "Description - $Now"
        $result.Description | Should -Be "This is a test playlist created by Pester on $Now"
        
    }

}