<#
    .SYNOPSIS
        Download the module files from GitHub.

    .DESCRIPTION
        Download the module files from GitHub to the local client in the module folder.
#>

[CmdLetBinding()]
Param (
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName = 'PSCognitiveService',
    [String]$InstallDirectory,
    [ValidateNotNullOrEmpty()]
    [String]$GitPath = 'https://raw.githubusercontent.com/PrateekKumarSingh/PSCognitiveService/master'
)

$Pre = $VerbosePreference
$VerbosePreference = 'continue'

Try {
    Write-Verbose "$ModuleName module installation started"

    $Files = @(
        'PSCognitiveService.psd1',
        'PSCognitiveService.psm1',
        'Classes/Vision.ps1',
        'Classes/Moderate.ps1',
        'Classes/Enum.ps1',
        'Classes/Face.ps1',
        'Classes/ValidateFile.ps1',
        'Classes/ValidateImage.ps1',
        'Examples/ConvertTo-Thumbnail.ps1',
        'Examples/Get-Face.ps1',
        'Examples/Get-ImageAnalysis.ps1',
        'Examples/Get-ImageTag.ps1',
        'Examples/Get-ImageText.ps1',
        'Examples/Test-AdultRacyContent.ps1',
        'Private/Test-AzureRMLogin.ps1',
        'Private/Test-LocalConfiguration.ps1',
        'Public/New-LocalConfiguration.ps1',
        'Public/Face/Get-Face.ps1',
        'Public/Moderator/Test-AdultRacyContent.ps1',
        'Public/Vision/ConvertTo-Thumbnail.ps1',
        'Public/Vision/Get-ImageAnalysis.ps1',
        'Public/Vision/Get-ImageDescription.ps1',
        'Public/Vision/Get-ImageTag.ps1',
        'Public/Vision/Get-Imagetext.ps1'
    )
}
Catch {
    throw "Failed installing the module in the install directory '$InstallDirectory': $_"
}

Try {
    if (-not $InstallDirectory) {
        Write-Verbose "$ModuleName no installation directory provided"

        $PersonalModules = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules

        if (($env:PSModulePath -split ';') -notcontains $PersonalModules) {
            Write-Warning "$ModuleName personal module path '$PersonalModules' not found in '`$env:PSModulePath'"
        }

        if (-not (Test-Path $PersonalModules)) {
            Write-Error "$ModuleName path '$PersonalModules' does not exist"
        }

        $InstallDirectory = Join-Path -Path $PersonalModules -ChildPath $ModuleName
        Write-Verbose "$ModuleName default installation directory is '$InstallDirectory'"
    }

    if (-not (Test-Path $InstallDirectory)) {
        New-Item -Path $InstallDirectory -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\Classes -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\Examples -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\Private -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\Public -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\Public\Face -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\Public\Moderator -ItemType Directory -EA Stop -Verbose | Out-Null
        New-Item -Path $InstallDirectory\Public\Vision -ItemType Directory -EA Stop -Verbose | Out-Null
        Write-Verbose "$ModuleName created module folder '$InstallDirectory'"
    }

    $WebClient = New-Object System.Net.WebClient

    $Files | ForEach-Object {
        $File = $installDirectory, '\', $($_ -replace '/', '\') -join ''
        $URL = $GitPath, '/', $_ -join ''
        $WebClient.DownloadFile($URL, $File)
        Write-Verbose "$ModuleName installed module file '$_'"
    }

    Write-Verbose "$ModuleName module installation successful"
}
Catch {
    throw "Failed installing the module in the install directory '$InstallDirectory': $_"
}
$VerbosePreference = $Pre