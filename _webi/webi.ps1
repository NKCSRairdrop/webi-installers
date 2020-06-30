﻿#!/usr/bin/env pwsh

# If a command returns an error, halt the script.
$ErrorActionPreference = 'Stop'

# Ignore progress events from cmdlets so Invoke-WebRequest is not painfully slow
$ProgressPreference = 'SilentlyContinue'

# TODO get arch
$Env:WEBI_UA = 'Windows/10 amd64'
$exename = $args[0]

# Switch to userprofile
pushd $Env:USERPROFILE

# Make paths if needed
if (!(Test-Path -Path .local\bin))
{
    New-Item -Path .local\bin -ItemType Directory
}
if (!(Test-Path -Path .local\opt))
{
    New-Item -Path .local\opt -ItemType Directory
}
# TODO windows version of mktemp -d
if (!(Test-Path -Path .local\tmp))
{
    New-Item -Path .local\tmp -ItemType Directory
}

# TODO SetStrictMode
# TODO Test-Path variable:global:Env:WEBI_HOST ???
IF(!$Env:WEBI_HOST)
{
    $Env:WEBI_HOST = "https://webinstall.dev"
}

if (!(Test-Path -Path .local\bin\pathman.exe))
{
    & curl.exe -fsSL -A "$Env:WEBI_UA" "$Env:WEBI_HOST/packages/pathman/install.ps1" -o .\.local\tmp\pathman-setup.ps1
    powershell .\.local\tmp\pathman-setup.ps1
    # TODO del .\.local\tmp\pathman-setup.bat
}

# {{ baseurl }}
# {{ version }}

# Fetch <whatever>.ps1
echo "$Env:WEBI_HOST/packages/$exename/install.ps1"
echo "$exename.install.ps1"

# TODO detect formats
# Invoke-WebRequest -UserAgent "Windows amd64" "$Env:WEBI_HOST/api/installers/$exename.ps1?formats=zip,tar" -OutFile ".\.local\tmp\$exename.install.ps1"
& curl.exe -fsSL -A "$Env:WEBI_UA" "$Env:WEBI_HOST/api/installers/$exename.ps1?formats=zip,tar" -o .\.local\tmp\$exename.install.ps1

# Run <whatever>.ps1
powershell .\.local\tmp\$exename.install.ps1

# Done
popd
