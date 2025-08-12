param(
  [Parameter(Mandatory=$true)] [string]$InputPath,
  [string]$OutputPath = "",
  [string]$Scale = "1280:1080",
  [string]$Ffmpeg = "C:\ffmpeg\bin\ffmpeg.exe"
)

if (-not (Test-Path $InputPath)) { Write-Error "Input not found: $InputPath"; exit 1 }

$inpDir  = Split-Path $InputPath -Parent
$inpBase = [IO.Path]::GetFileNameWithoutExtension($InputPath)
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
  $OutputPath = Join-Path $inpDir ($inpBase + "_crop_upscaled.mp4")
}
$cropLog = Join-Path $inpDir ($inpBase + "_cropdetect.txt")

# Detect crop (3 seconds)
& $Ffmpeg -hide_banner -loglevel info -i $InputPath -vf cropdetect -t 3 -f null - 2>$cropLog

# Get the last suggested crop=
$cropLine = Select-String -Path $cropLog -Pattern "crop=\d+:\d+:\d+:\d+" | Select-Object -Last 1
if (-not $cropLine) { Write-Error "No crop suggestion found in $cropLog"; exit 1 }

$crop = $cropLine.Matches[0].Value  # e.g., crop=496:304:782:8
Write-Host "Using $crop"

# Apply crop + upscale
& $Ffmpeg -y -i $InputPath -vf "$crop,scale=$Scale" -c:v libx264 -crf 18 -preset medium -c:a copy $OutputPath
Write-Host "Done -> $OutputPath"
