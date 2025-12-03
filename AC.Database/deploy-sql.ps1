<#
  deploy-sql.ps1

  Deploys all SQL files under this project to the target database using sqlcmd.
  Usage: .\deploy-sql.ps1 -Server "." -Database "ACDatabase" -User "sa" -Password "Password1!"
  If no credentials provided, windows authentication will be used.
#>
param(
  [string]$Server = '.',
  [string]$Database = 'ACDatabase',
  [string]$User = '',
  [string]$Password = ''
)

$ErrorActionPreference = 'Stop'

Write-Host "Deploying SQL scripts from $PSScriptRoot to server '$Server' and database '$Database'"

$credentialArgs = @()
if (![string]::IsNullOrWhiteSpace($User)) {
  $credentialArgs += "-U $User"
  $credentialArgs += "-P $Password"
}

# Find SQL files
$files = Get-ChildItem -Path $PSScriptRoot -Recurse -Filter *.sql | Sort-Object FullName

foreach ($file in $files) {
  Write-Host "Executing $($file.FullName)"
  $cmd = @('sqlcmd','-S', $Server, '-d', $Database, '-i', $file.FullName) + $credentialArgs
  $processInfo = New-Object System.Diagnostics.ProcessStartInfo
  $processInfo.FileName = $cmd[0]
  $processInfo.Arguments = ($cmd[1..$cmd.Length] -join ' ')
  $processInfo.RedirectStandardOutput = $true
  $processInfo.RedirectStandardError = $true
  $processInfo.UseShellExecute = $false
  $processInfo.CreateNoWindow = $true

  $process = [System.Diagnostics.Process]::Start($processInfo)
  $stdout = $process.StandardOutput.ReadToEnd()
  $stderr = $process.StandardError.ReadToEnd()
  $process.WaitForExit()

  if ($process.ExitCode -ne 0) {
    Write-Error "Failed executing $($file.FullName) : $stderr"
    break
  } else {
    Write-Host $stdout
  }
}

Write-Host "Deployment finished."
