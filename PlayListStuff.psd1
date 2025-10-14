@{
    # The name of the module script file
    RootModule        = 'PlaylistStuff.psm1'

    # ScriptsToProcess = @("C:\Users\matty\OneDrive\powershell\Modules\PlaylistStuff\functions\*.ps1")

    # Public functions to export
    FunctionsToExport = @("*-Pl*")

    ModuleVersion     = '0.1.0'

    # You can also use wildcards
    # FunctionsToExport = @('New-*')
}