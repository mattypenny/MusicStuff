Describe 'Get-PlSongsFromDiscogs (Live API Test for 222710)' {
    
    BeforeAll {
        import-module -force PlaylistStuff
    }

    # --- Test Case 2: Verification of a Track with an Explicit Artist (A1: Ian Dury) ---
    It 'Should correctly process Track A1 (Ian Dury And The Blockheads)' {
        $Result = Get-PlSongsFromDiscogs -DiscogsCode '780184'

        $Result | Should -HaveCount 16
        
        # Find the specific track in the output
        $TrackA1 = $Result | 
        Where-Object { $_.Song -eq 'Sex & Drugs & Rock & Roll' } | 
        Select-Object -First 1
        
        $TrackA1 | Should -HaveCount 1
        # Verify the structure and content
        $TrackA1.Artist     | Should -Be 'Ian Dury And The Blockheads'
        $TrackA1.Song       | Should -Be 'Sex & Drugs & Rock & Roll'
        $TrackA1.ArtistSong | Should -Be 'Ian Dury And The Blockheads - Sex & Drugs & Rock & Roll'
    }
    
    # --- Test Case 4: Error Handling for Non-Existent Code (Testing the 'catch' block) ---
    # We must mock this case, as we cannot predict a real API error code.
    # We re-mock Invoke-RestMethod temporarily within this 'It' block.
    It 'Should throw the custom error when an API call for a bad code fails' {
        
        # Set up a temporary Mock for Invoke-RestMethod that always throws an error
        Mock Invoke-RestMethod {
            throw 'Simulated 404/500 API Error' 
        } -ModuleName PlaylistStuff

        # Expect the function to catch the error and throw the custom message
        { Get-PlSongsFromDiscogs -DiscogsCode '000000' } | Should -Throw "Error retrieving data from Discogs API for release code <000000>"
    }
}