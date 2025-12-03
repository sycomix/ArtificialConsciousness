# Cleans Visual Studio local caches to remove stale migration messages or project cache
# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\clean-vs.ps1 -SolutionPath .
param(
    [string]$SolutionPath = '.'
)

$folders = @('..\\.vs', '.\\.vs')
$pattern = 'UpgradeLog*.htm'

Set-Location -Path $SolutionPath
Write-Host "Cleaning .vs and UpgradeLog files in: $SolutionPath"

if (Test-Path -Path '.vs') {
    Remove-Item -Path '.vs' -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Removed .vs folder"
} else {
    Write-Host "No .vs folder found"
}

# Remove any solution .suo
Get-ChildItem -Path $SolutionPath -Filter *.suo -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item -Path $_.FullName -Force
    Write-Host "Removed $_.FullName"
}

# Remove any UpgradeLog files
Get-ChildItem -Path $SolutionPath -Filter 'UpgradeLog*.htm' -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item -Path $_.FullName -Force
    Write-Host "Removed upgrade log: $_.FullName"
}

Write-Host "Cleaned caches. You may now reopen Visual Studio."