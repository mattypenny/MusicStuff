
function New-PlTidalPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        $ClientId = $(Get-SsfParameter -Parameter PsTidalClientId),
        $ClientSecret = $(Get-SsfParameter -Parameter PsTidalClientSecret),
        $PlaylistFolder,
        $PlaylistName        
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    # --- 2. Define Authentication Endpoint ---
    $TokenUrl = "https://auth.tidal.com/v1/oauth2/token"
    $AuthHeader = @{
        Authorization = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($ClientId):$($ClientSecret)"))
    }
    $Body = @{
        grant_type = "client_credentials"
    }

    # --- 3. Request the Access Token ---
    try {
        Write-Host "Requesting Access Token..."
        $TokenResponse = Invoke-RestMethod -Uri $TokenUrl -Method Post -Headers $AuthHeader -Body $Body
        $AccessToken = $TokenResponse.access_token

        if (-not $AccessToken) {
            throw "Access token not found in response."
        }

        Write-Host "Successfully obtained Access Token."
    }
    catch {
        Write-Error "Failed to obtain Access Token. Check your Client ID/Secret. Details: $($_.Exception.Message)"
        return
    }
    

    write-dbg "`$Playlist count: <$($Playlist.Length)>"
    write-endfunction
   
    return $Playlist
   
}