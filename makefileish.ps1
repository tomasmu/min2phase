<#
.SYNOPSIS

Simplified powershell version of Makefile.
(because i have no idea what i'm doing)

.DESCRIPTION

Can perform some things that Makefile can; Build, Run, and Clean.

.EXAMPLE

.\makefileish.ps1 clean, build

.EXAMPLE

.\makefileish.ps1 run "R U2 R' U' R U' R'"
#>
[CmdletBinding()]
param(
	[parameter(Mandatory, Position = 0)]
	[ValidateSet('Build', 'Run', 'Clean')]
	[string[]]$Action,

	[parameter(Position = 1)]
	[string[]]$ArgumentList
)

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
		Write-Host "* $($_)ing"
		javac.exe -d 'dist' $SRC $MAINPROG -Xlint:all
		Copy-Item -Path $SRC -Destination 'dist/cs/min2phase' -Force

		Push-Location
		Set-Location 'dist'
		jar.exe cfe 'twophase.jar' 'ui.MainProgram' 'ui/*.class' 'cs/min2phase/*.class' 'cs/min2phase/*.java'
		Pop-Location
	}
	'Run' {
		Write-Host "* $($_)ning"
		java.exe -jar $DIST $ArgumentList
	}
	'Clean' {
		Write-Host "* $($_)ing"
		Remove-Item -Recurse dist -ErrorAction SilentlyContinue
	}
}
