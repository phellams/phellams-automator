# Use Debian 12 slim as the clean base image to avoid massive gitlab-runner overhead
FROM debian:12.14-slim

# Set environment variables for non-interactive installation
# ..........................................................
ENV DEBIAN_FRONTEND=noninteractive
ENV DOTNET_ROOT=/root/.dotnet
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.dotnet:/root/.dotnet/tools"
ENV BUNDLE_SILENCE_ROOT_WARNING="1"
ENV BUNDLE_PATH="vendor/bundle"
ENV BUNDLE_APP_CONFIG="/root/.bundle"
ENV COMPOSER_HOME=/tmp/composer
ENV PATH="${COMPOSER_HOME}/vendor/bin:${PATH}" 
ENV BUN_INSTALL="/root/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

# 1. Base Dependencies & Mono/NuGet
# Combined to reduce layers and cleaned up thoroughly
# ..........................................................
RUN apt update && \
    apt install -y --no-install-recommends \
    curl wget gnupg apt-transport-https software-properties-common ca-certificates git \
    mono-complete lsb-release tar perl coreutils yq jq && \
    # Install NuGet Latest
    wget -q https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -O /usr/local/bin/nuget.exe && \
    echo '#!/bin/bash\nmono /usr/local/bin/nuget.exe "$@"' > /usr/local/bin/nuget && \
    chmod +x /usr/local/bin/nuget && \
    # Cleanup apt cache
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/*

# 2. .NET SDKs (Consolidated)
# ...........................
RUN mkdir -p /root/.dotnet && \
    # .NET 8
    wget -q https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-x64.tar.gz -O /tmp/dotnet8.tar.gz && \
    tar zxf /tmp/dotnet8.tar.gz -C /root/.dotnet && \
    # .NET 10
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version 10.0.103 --install-dir /root/.dotnet && \
    # Cleanup .NET caches/temp
    rm -rf /tmp/* /root/.dotnet/sdk/NuGetFallbackFolder /root/.dotnet/templates

# 3. PowerShell 7.5.3
# ....................
RUN wget -q https://github.com/PowerShell/PowerShell/releases/download/v7.6.3/powershell_7.6.3-1.deb_amd64.deb -O /tmp/powershell.deb && \
    apt update && apt install -y /tmp/powershell.deb && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/*

# 4. Ruby, Jekyll, Go, Rust, Elixir (Consolidated & Cleaned)
# ..........................................................
RUN apt update && \
    apt install -y --no-install-recommends \
    ruby rubygems ruby-dev make gcc g++ \
    golang rustc elixir && \
    # Jekyll without documentation
    gem install bundler jekyll --no-document && \
    # Cleanup
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /root/.gem /root/.bundle

# 4.1 PHP 8.2 + Composer + PHP-FPM + Xdebug + PHPUnit
# ..........................................................

RUN apt update && \
    apt install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        git \
        php8.2 \
        php8.2-cli \
        php8.2-fpm \
        php8.2-common \
        php8.2-curl \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        php8.2-intl \
        php8.2-bcmath \
        php8.2-sqlite3 \
        php8.2-mysql \
        php8.2-pgsql \
        php8.2-gd \
        php8.2-opcache \
        php8.2-xdebug \
        composer && \
    composer global require --no-interaction --no-progress \
        phpunit/phpunit:^11 && \
    ln -sf "${COMPOSER_HOME}/vendor/bin/phpunit" /usr/local/bin/phpunit && \
    php -v && \
    composer --version && \
    phpunit --version && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# NODE & NPM - Node.js & NPM(v24.16.0)
# ....................................
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    npm --version && \
    node --version && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# BUN.JS - Bun(v0.5.4)
# ....................................
RUN curl -fsSL https://bun.com/install | bash && \ 
    bun --version && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
    
# Codecov
# ....................................
RUN set -eux; \
    curl -fL -o /tmp/codecov.asc \
        https://keybase.io/codecovsecops/pgp_keys.asc; \
    gpg --no-default-keyring \
        --keyring /tmp/codecov.gpg \
        --import /tmp/codecov.asc; \
    curl -fL -o codecov \
        https://cli.codecov.io/latest/linux/codecov; \
    curl -fL -o codecov.SHA256SUM \
        https://cli.codecov.io/latest/linux/codecov.SHA256SUM; \
    curl -fL -o codecov.SHA256SUM.sig \
        https://cli.codecov.io/latest/linux/codecov.SHA256SUM.sig; \
    gpg --no-default-keyring \
        --keyring /tmp/codecov.gpg \
        --verify codecov.SHA256SUM.sig codecov.SHA256SUM; \
    sha256sum -c codecov.SHA256SUM; \
    chmod +x codecov; \
    mv codecov /usr/local/bin/codecov; \
    codecov --help >/dev/null; \
    rm -f \
        /tmp/codecov.asc \
        /tmp/codecov.gpg \
        /tmp/codecov.gpg~ \
        codecov.SHA256SUM \
        codecov.SHA256SUM.sig

# Coveralls
# ....................................
RUN curl -fL https://coveralls.io/coveralls-linux.tar.gz | tar -xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/coveralls && \
    coveralls --version

# 5. GUI, Graphics & AppImage Dependencies (Photino, Inkscape, ImageMagick, AppImage build tools)
# ..........................................................................................
RUN apt update && \
    apt install -y --no-install-recommends \
    libgtk-3-dev libwebkit2gtk-4.0-dev libnotify-dev \
    inkscape imagemagick \
    binutils desktop-file-utils fakeroot fuse libfuse2 patchelf squashfs-tools zsync libgdk-pixbuf2.0-dev && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/*

# 6. PowerShell Modules from PSGallery
# ...................................
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
# .................................
COPY ./includes/modules/ /root/.local/share/powershell/Modules/
COPY ./includes/acsiilogo-template.txt /root/.config/powershell/acsiilogo-template.txt
COPY ./includes/Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# Final sanity check and cache cleanup
# ..................................
RUN pwsh -NoProfile -Command "Write-Host 'Verifying installations...'; dotnet --version; nuget help | select -First 1; rustc --version; go version; elixir --version" && \
    rm -rf /root/.cache /root/.local/share/NuGet /tmp/*

CMD ["pwsh"]
