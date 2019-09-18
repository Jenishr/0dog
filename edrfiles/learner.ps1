if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
{ # Powershell script
	$presentpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
else
{ # PS2EXE compiled script
	$presentpath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
}
$ErrorActionPreference = "SilentlyContinue" 
