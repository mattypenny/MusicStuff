Describe "Get-PlSongsFromCrucialTracksCommunityPlaylist" {
    BeforeAll {
        Import-Module -Name PlaylistStuff -Force
    }
    It "works" {
        $result = Get-PlSongsFromCrucialTracksCommunityPlaylist -CrucialTracksCommunityPlaylistURL https://app.crucialtracks.org/community-tracks/2025-09-21
        $result.Count | Should -Be 20
        $result | where-object Song -eq 'The Body of An American' | Should -HaveCount 1 
    }
}