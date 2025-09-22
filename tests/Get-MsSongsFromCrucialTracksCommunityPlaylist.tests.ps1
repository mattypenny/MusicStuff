Describe "Get-MsSongsFromCrucialTracksCommunityPlaylist" {
    BeforeAll {
        Import-Module -Name MusicStuff -Force
    }
    It "works" {
        $result = Get-MsSongsFromCrucialTracksCommunityPlaylist -CrucialTracksCommunityPlaylistURL https://app.crucialtracks.org/community-tracks/2025-09-21
        $result.Count | Should -Be 20
        $result | where-object Song -eq 'The Body of An American' | Should -HaveCount 1 
    }
}