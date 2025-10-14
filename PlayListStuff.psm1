import-module -force Spotishell -prefix Spo
foreach ($F in $(get-childitem  $PsScriptRoot/functions/*.ps1)) {
    . $F.fullname
}
