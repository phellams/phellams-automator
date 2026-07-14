# Calculate-Runtime.ps1
if ($env:CI_PIPELINE_CREATED_AT) {
  $CreatedTime = [DateTime]::Parse($env:CI_PIPELINE_CREATED_AT)
  $Duration = [DateTime]::UtcNow - $CreatedTime.ToUniversalTime()
  $RuntimeStr = "{0}m {1}s" -f [Math]::Floor($Duration.TotalMinutes), $Duration.Seconds
} else {
  $RuntimeStr = "unknown"
}
$ENV:RUNTIME_STR = $RuntimeStr
"RUNTIME_STR=$RuntimeStr" | Out-File -FilePath runtime.env -Encoding utf8