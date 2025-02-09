docker run --rm -v $(pwd):/nytescripts -w /nytescripts nytescripts-psm-builder pwsh -Command '$PSVersionTable.PSVersion.ToString()'
docker run --rm -v $(pwd):/nytescripts -w /nytescripts nytescripts-psm-builder pwsh -Command 'nuget help | select -First 1'
docker run --rm -v $(pwd):/nytescripts -w /nytescripts nytescripts-psm-builder pwsh -Command 'dotnet --info'