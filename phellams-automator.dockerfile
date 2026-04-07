# Use Debian 12 slim as the clean base image to avoid massive gitlab-runner overhead
FROM debian:12-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive \
    DOTNET_ROOT=/root/.dotnet \
    PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.dotnet:/root/.dotnet/tools"

# 1. Base Dependencies & Mono/NuGet
# Combined to reduce layers and cleaned up thoroughly
RUN apt update && \
    apt install -y --no-install-recommends \
    curl wget gnupg apt-transport-https software-properties-common ca-certificates git \
    mono-complete lsb-release && \
    # Install NuGet Latest
    wget -q https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -O /usr/local/bin/nuget.exe && \
    echo '#!/bin/bash\nmono /usr/local/bin/nuget.exe "$@"' > /usr/local/bin/nuget && \
    chmod +x /usr/local/bin/nuget && \
    # Cleanup apt cache
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/*

# 2. .NET SDKs (Consolidated)
RUN mkdir -p /root/.dotnet && \
    # .NET 8
    wget -q https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-x64.tar.gz -O /tmp/dotnet8.tar.gz && \
    tar zxf /tmp/dotnet8.tar.gz -C /root/.dotnet && \
    # .NET 10
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version 10.0.103 --install-dir /root/.dotnet && \
    # Cleanup .NET caches/temp
    rm -rf /tmp/* /root/.dotnet/sdk/NuGetFallbackFolder /root/.dotnet/templates

# 3. PowerShell 7.5.3
RUN wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.5.3/powershell_7.5.3-1.deb_amd64.deb -O /tmp/powershell.deb && \
    apt update && apt install -y /tmp/powershell.deb && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/*

# 4. Ruby, Jekyll, Go, Rust, Elixir (Consolidated & Cleaned)
RUN apt update && \
    apt install -y --no-install-recommends \
    ruby rubygems ruby-dev make gcc g++ \
    golang rustc elixir && \
    # Jekyll without documentation
    gem install bundler jekyll --no-document && \
    # Cleanup
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /root/.gem /root/.bundle

# 5. DevOps Tools (Codecov & Coveralls)
RUN wget -qO- 'https://keybase.io/codecovsecurity/pgp_keys.asc' | gpg --no-default-keyring --keyring /root/trustedkeys.gpg --import && \
    curl -Os https://uploader.codecov.io/latest/linux/codecov && \
    curl -Os https://uploader.codecov.io/latest/linux/codecov.SHA256SUM && \
    curl -Os https://uploader.codecov.io/latest/linux/codecov.SHA256SUM.sig && \
    gpg --no-default-keyring --keyring /root/trustedkeys.gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM && \
    shasum -a 256 -c codecov.SHA256SUM && \
    chmod +x codecov && mv codecov /usr/local/bin/codecov && \
    # Coveralls
    curl -L https://coveralls.io/coveralls-linux.tar.gz | tar -xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/coveralls && \
    # Cleanup
    rm -rf /tmp/* codecov.*

# 6. PowerShell Modules from PSGallery
RUN pwsh -NoProfile -Command ' \
    $ErrorActionPreference = "Stop"; \
    $Modules = @("Pester", "PSScriptAnalyzer", "powershell-yaml"); \
    foreach ($m in $Modules) { \
        Write-Host "Installing $m..."; \
        Install-Module -Name $m -Force -SkipPublisherCheck -AllowClobber -Scope AllUsers; \
    }' && \
    # Prune PSModule help/docs to save space
    find /usr/local/share/powershell/Modules -type d -name "en-US" -exec rm -rf {} + 2>/dev/null || true

# 7. Local Files & Customizations
COPY ./includes/modules/ /root/.local/share/powershell/Modules/
COPY ./includes/acsiilogo-template.txt /root/.config/powershell/acsiilogo-template.txt
COPY ./includes/Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# Final sanity check and cache cleanup
RUN pwsh -NoProfile -Command "Write-Host 'Verifying installations...'; dotnet --version; nuget help | select -First 1; rustc --version; go version; elixir --version" && \
    rm -rf /root/.cache /root/.local/share/NuGet /tmp/*

CMD ["pwsh"]
