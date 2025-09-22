function Get-MsSongsFromCrucialTracksCommunityPlaylist {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        $CrucialTracksCommunityPlaylistURL
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    write-startfunction
   
    $WebPage = Invoke-WebRequest -Uri $CrucialTracksCommunityPlaylistURL -UseBasicParsing
    [string]$WebPageContent = $WebPage.Content
    write-dbg "`$WebPageContent count: <$($WebPageContent.Length)>"

    [string]$InnerHtml = $($WebPageContent  | convertfrom-html).innerhtml
    [string[]]$HtmlLines = $InnerHtml -split "`n"
    $FoundSong = $False
    foreach ($line in $HtmlLines) {
        $line = $line.trim()
        if ($FoundSong) {
            $ArtistLine = $line
            $FoundSong = $False

            $Artist = Get-MsTextFromHtmlLine -HtmlLine $ArtistLine
            $Song = Get-MsTextFromHtmlLine -HtmlLine $SongLine
            [PSCustomObject]@{
                ArtistLine = $ArtistLine
                SongLine   = $SongLine
                Artist     = $Artist
                Song       = $Song
                ArtistSong = "$Artist - $Song"
            }
        }
        if ($line -like '*<div class="font-medium text-xl">*') {
            $SongLine = $line
            $FoundSong = $True
        }
    }

    <#
    $Songs = $WebPageContent | select-string 'text-xl' -Context 0, 1  
    write-dbg "`$Songs count: <$($Songs.Length)>"

    foreach ($song in $Songs) {
        [string]$TitleLine = $song.Line 
        #        write-dbg "`$TitleLine: <$TitleLine>"
        if ($TitleLine -match '>(.*?)<') {
            $text = $matches[1]
        } 
        write-dbg "`$text: <$text>" 

        [string]$ArtistLine = $($song | select -ExpandProperty context | select -ExpandProperty postcontext)
        
        write-dbg "`$ArtistLine: <$ArtistLine>"
    }
    write-endfunction
    #>
   
   
}

function Get-MsTextFromHtmlLine {
    <#
.SYNOPSIS
   Extract text from an HTML line, like <div class="text-zinc-600 dark:text-zinc-400">Bethany Eve</div> 
#>
    [CmdletBinding()]
    param (
        [string]$HtmlLine
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    if ($HtmlLine -match '>(.*?)<') {
        $text = $matches[1]
    }
   
    write-endfunction
   
    return $text
   
}