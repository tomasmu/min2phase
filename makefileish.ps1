#because i have no idea what i'm doing, i rewrote parts of Makefile to powershell

[CmdletBinding()]
param(
	[parameter(Mandatory, Position = 0)]
	[ValidateSet('All', 'Build', 'Run', 'Clean')]
	[string[]]$Action
)

if ('All' -eq $Action) {
	$Action = 'Clean', 'Build', 'Run'
}

$SRC = @(
	'src/CoordCube.java'
	'src/CubieCube.java'
	'src/Search.java'
	'src/Util.java'
	'src/Tools.java'
)
$MAINPROG = 'example/MainProgram.java'
$DIST     = 'dist/twophase.jar'

switch ($Action) {
	'Build' {
		Write-Host "* $_"
		javac.exe -d 'dist' $SRC $MAINPROG -Xlint:all
		Copy-Item -Force -Path $SRC -Destination 'dist/cs/min2phase'
		cd 'dist'
		jar.exe cfe 'twophase.jar' 'ui.MainProgram' 'ui/*.class' 'cs/min2phase/*.class' 'cs/min2phase/*.java'
		cd ..
	}
	'Run' {
		Write-Host "* $_"
		java.exe -jar $DIST
	}
	'Clean' {
		Write-Host "* $_"
		Remove-Item -Recurse dist -ErrorAction SilentlyContinue
	}
}
