<#
.SYNOPSIS
This script automates the export of a Sparx Enterprise Architect (EA) model to HTML format.

.DESCRIPTION
The script uses the EA automation interface to control EA from PowerShell, generating an HTML report of the model.

.PARAMETER model
The path to the EA model file. Can be relative or absolute.

.PARAMETER output
The directory where the HTML report will be saved.

.PARAMETER package
The GUID of the package to export.

.EXAMPLE
PS> .\export.ps1 -model "model.eap" -output "." -package "{4BCFB7BC-FF16-4fb2-86F6-6B2A0AF17455}"

.NOTES
Author: Vincent Huybrechts
Last Updated: 2024-05-28
Requires: Enterprise Architect and appropriate permissions to run scripts and COM objects.

.LINK
Documentation about EA automation interface can be found in the [Sparx Systems Documentation](https://sparxsystems.com/enterprise_architect_user_guide/14.0/automation/automation_interface.html)
#>

param(
    [Parameter(Mandatory=$true)]
    [string] $model = "model.eapx",

    [Parameter(Mandatory=$true)]
    [string] $output = ".",

    [string] $package = "{4BCFB7BC-FF16-4fb2-86F6-6B2A0AF17455}"
)

Write-Host "Exporting a Sparx Enterprise Architect model to HTML..."
$model = Join-Path (Get-Location) $model
Write-Host "    - Path to model: $model"
Write-Host "    - Exporting pacakge: $package"

$output = Join-Path (Get-Location) $output
Write-Host "    - Path for export: $output"

# Create a new instance of the EA.App object
# Open the EA model file and export to HTML
Write-Host "    - Exporting ..."
$eaApp = New-Object -ComObject EA.App
$eaRepo = $eaApp.Repository
$eaRepo.OpenFile($model)
$eaRepo.GetProjectInterface().RunHTMLReport($package, $output, "PNG", "<default>", ".aspx")
$eaRepo.CloseFile()
Write-Host "    - Exporting ... done"
# Release the COM objects
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($eaApp) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($eaRepo) | Out-Null
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
Write-Host "Exporting a Sparx Enterprise Architect model to HTML...Completed."
