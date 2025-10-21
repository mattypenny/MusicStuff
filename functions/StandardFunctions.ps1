function write-startfunction {
    <#
.SYNOPSIS
  Marks start of function in logfile or debug output
.DESCRIPTION
  Gets parameters back from Get-PSCallStack
.EXAMPLE
  write-startfunction 
#>

    [CmdletBinding()]

    Param(  )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    $CallDate = get-date -format 'hh:mm:ss.ffff'

    $CallingFunction = Get-PSCallStack | Select-Object -first 2 | select-object -last 1

    [string]$Command = $CallingFunction.Command

    [string]$Location = $CallingFunction.Location

    [string]$Arguments = $CallingFunction.Arguments

    # [string]$FunctionName = $CallingFunction.FunctionName
    # (Get-Host).PrivateData.DebugForegroundColor = "Gray"

    if ($Log) {
        write-SsfLog -Log $Log -Message  "$CallDate StartFunction: $Command "
    }
    else {
        write-dbg "$CallDate StartFunction: $Command "
    }

    # (Get-Host).PrivateData.DebugForegroundColor = "Blue"

    return
}


function write-endfunction {
    <#
.SYNOPSIS
  Marks end of function in logfile or debug output
.DESCRIPTION
  Gets parameters back from Get-PSCallStack
.EXAMPLE
  write-endfunction 
#>

    [CmdletBinding()]

    Param(  )

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    $CallDate = get-date -format 'hh:mm:ss.ffff'

    $CallingFunction = Get-PSCallStack | Select-Object -first 2 | select-object -last 1

    [string]$Command = $CallingFunction.Command

    [string]$Location = $CallingFunction.Location

    [string]$Arguments = $CallingFunction.Arguments

    # [string]$FunctionName = $CallingFunction.FunctionName
    # (Get-Host).PrivateData.DebugForegroundColor = "Gray"

    if ($Log) {
        write-SsfLog -Log $Log -Message  "$CallDate EndFunction: $Command "
    }
    else {
        write-dbg "$CallDate EndFunction: $Command "
    }

    # (Get-Host).PrivateData.DebugForegroundColor = "Blue"

    return
}


function write-SsfLog {

    <#

    .SYNOPSIS

      write-SsfLog -Log $Log -Message with function and time stamp

    .DESCRIPTION

      Gets parameters back from Get-PSCallStack

    .EXAMPLE

      write-startfunction $MyInvocation

    #>

    [CmdletBinding()]

    Param( $x,

        [switch]$TimeStamp = $False )

 

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    $CallingFunction = Get-PSCallStack | Select-Object -first 2 | select-object -last 1

 

    [string]$Command = $CallingFunction.Command

 

    if ($TimeStamp) {

        [string]$Ts = $(Get-Date -format "dd MMM yyyy HH:mm:ss:fff:")

    }

    else {

        [string]$Ts = ""

    }

 

    write-SsfLog -Log $Log -Message "$Ts$Command`: $x"

 

    return

}

 

 

function Write-SSfLog {

    <#

.SYNOPSIS

    Write formatted message to csv logfile

.NOTES

    Aliased both the function name and the $Csv parameter with 'log' instead of csv

#>

    [CmdletBinding()]

    param (

        [Alias ('Log')][string]$Csv,

        [string]$Message,

        [string]$ExtraKey = '',

        [switch]$Initialize,

        [switch]$TimeStamp = $True,

        [String][ValidateSet('Warning', 'Error', 'Info', 'Information')]$Status = 'Info'

    )

 

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

 

    if ($Status -eq 'Information') {

        $Status = "Info"

    }

 

    if ($TimeStamp) {

        [string]$Ts = $(Get-Date -format "dd MMM yyyy HH:mm:ss:fff")

        $Ts = $Ts + "^"

    }

    else {

        [string]$Ts = ""

    }

 

    $LineToOutput = "$Ts$Status^$Message^$ExtraKey"

 

    if ($Initialize) {

        $Append = $False

 

        if ($Timestamp) {

            $TsHeader = "Timestamp^"

        }

 

        $LineToOutput = @"

    ${TsHeader}Status^Message^ExtraKey

    $LineToOutput

"@

 

    }
    else {

        $Append = $True

    }

 

    $LineToOutput | out-file -Append:$Append -filepath $Csv

 

    write-SsfLog -Log $Log -Message $LineToOutput

 

}

Set-Alias Write-SsfCsv Write-SSfLog

 

function New-SsfFolderForFileName {

    <#

.SYNOPSIS

    Create containing folder for given filename

#>

    [CmdletBinding()]

    param (

        [string[]]$Fullname

    )

 

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

 

    foreach ($F in $Fullname) {

        [string]$Folder = [System.IO.Path]::GetDirectoryName($F)

        if ($Log) {
            write-SsfLog -Log $Log -Message "`$Folder: <$Folder>"
        }
        else {
            write-dbg "`$Folder: <$Folder>"
        }

        if (!(test-path $Folder)) {

            New-Item -ItemType "directory" -Path $Folder

        }

    }

 

}

 

 

function Show-SsfInformation {

    <#

.SYNOPSIS

    Until I can find a way of turning write-information green, this does a write-host. Sue me. :)

 

#>

    [CmdletBinding()]

    param(

        [Parameter(Mandatory)]

        [string]$Message

    )

 

    Write-Host -ForegroundColor Green $message

}

 

function write-DbgPsBoundParameters {

    <#

    .SYNOPSIS

        Write all the parameters to debug

    .EXAMPLE

        write-DbgPsBoundParameters -MyParameters $PSBoundParameters

    #>

    [CmdletBinding()]

    param (

        $MyParameters

    )

 

    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

 

    if ($Log) {
        write-SsfLog -Log $Log -Message "PSBoundParameters are as follows:"
    }
    else {
        write-dbg "PSBoundParameters are as follows:"
    }

 

    foreach ($k in $MyParameters.Keys) {

        $PaddedKey = $k + ':'

        $PaddedKey = $PaddedKey.PadRight(24)

        if ($Log) {
            write-SsfLog -Log $Log -Message "$PaddedKey $($MyParameters[$k])"
        }
        else {
            write-dbg "$PaddedKey $($MyParameters[$k])"
        }

    }

 

    if ($Log) {
        write-SsfLog -Log $Log -Message "End of PSBoundParameters"
    }
    else {
        write-dbg "End of PSBoundParameters"
    }

}

function write-dbg {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        $Message
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
   
    write-debug $Message
   
   
}

function Get-SsfParameter {
    <#
.SYNOPSIS
   xx
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string] $Parameter,
        $ParameterFile = "$env:PSParametersFolder\GeneralParameters.csv"
    )
   
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
   
    write-startfunction
   
    $ParameterLine = Import-Csv -Path $ParameterFile | where-object { $_.Parameter -eq $Parameter }
    if ($ParameterLine) {
        $Value = $ParameterLine.Value
    }
    else {
        throw "Parameter <$Parameter> not found in file <$ParameterFile>"
    }
   
    write-endfunction
   
    return $Value
   
}