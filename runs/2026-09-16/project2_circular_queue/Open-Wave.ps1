param([ValidateRange(1,3)][int]$Scenario=3)
$ErrorActionPreference='Stop'
$toolRoot=Join-Path (Split-Path $PSScriptRoot -Parent) 'fpga_free_tools'
$env:PATH="$toolRoot/bin;$toolRoot/lib;"+$env:PATH
$env:GTK_EXE_PREFIX=$toolRoot
$env:GTK_DATA_PREFIX=$toolRoot
$env:GSK_RENDERER='cairo'
$waveExe=Join-Path $toolRoot 'bin/gtkwave.exe'
if (!(Test-Path -LiteralPath $waveExe)) {$waveExe='gtkwave'}
Set-Location -LiteralPath $PSScriptRoot
& $waveExe "results/simulation.vcd" "results/view.gtkw" --rcfile "results/view.gtkwrc"
