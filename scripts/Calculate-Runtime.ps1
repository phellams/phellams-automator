# Calculate-Runtime.ps1
if ($env:CI_PIPELINE_CREATED_AT) {
    $CreatedTime = [DateTimeOffset]::Parse(
        $env:CI_PIPELINE_CREATED_AT,
        [Globalization.CultureInfo]::InvariantCulture
    )

    $Duration = [DateTimeOffset]::UtcNow - $CreatedTime.ToUniversalTime()

    $RuntimeStr = '{0}m {1}s' -f `
        [Math]::Floor($Duration.TotalMinutes),
        $Duration.Seconds
}
else {
    $RuntimeStr = 'unknown'
}

return $RuntimeStr