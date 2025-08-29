# Use Debian latest as the base image
FROM debian:12.11-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && \
    apt install -y \
    curl \
    wget \
    gnupg \
    apt-transport-https \
    software-properties-common \
    ca-certificates \
    git

RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.5.1/powershell_7.5.1-1.deb_amd64.deb -O /tmp/powershell.deb && \
    dpkg -i /tmp/powershell.deb && \
    apt install -f -y  # Fix dependencies if needed

# Install PowerShell 7.4.5
#RUN apt install -y powershell

# Install NuGet
# NOTE: the default repo only has nuget 2.8.x as debian only has stable packages that are well tested which in turn could be quite old.
#// TODO: Install nuget directly using the official nuget install script or download the latest binary from nuget.org
#// TODO: nuget exe is a windows binary, so we need mono to run this
#// TODO: update nupsforge with sitch param to check if is Linux and run mono
#RUN apt install -y nuget
# RUN apt update && apt install -y ca-certificates gnupg wget && \
#     gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
#     echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/debian stable-bookworm main" > /etc/apt/sources.list.d/mono-official-stable.list && \
#     apt update && \
#     apt install -y mono-complete && \
#     rm -rf /var/lib/apt/lists/* && \
#     wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -O /usr/local/bin/nuget.exe && \
#     echo '#!/bin/bash' > /usr/local/bin/nuget && \
#     echo 'mono /usr/local/bin/nuget.exe "$@"' >> /usr/local/bin/nuget && \
#     chmod +x /usr/local/bin/nuget
RUN apt update && apt install -y mono-complete wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -O /usr/local/bin/nuget.exe && \
    echo '#!/bin/bash' > /usr/local/bin/nuget && \
    echo 'mono /usr/local/bin/nuget.exe "$@"' >> /usr/local/bin/nuget && \
    chmod +x /usr/local/bin/nuget
    
# Install .NET SDK v8.0.412
# FROM: https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian?tabs=dotnet9
RUN wget https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-x64.tar.gz -O /tmp/dotnet-sdk-8.0.412-linux-x64.tar.gz && \
    mkdir -p /root/.dotnet && \
    tar zxf /tmp/dotnet-sdk-8.0.412-linux-x64.tar.gz -C /root/.dotnet && \
    rm /tmp/dotnet-sdk-8.0.412-linux-x64.tar.gz

# Set environment variables globally for all shells
ENV DOTNET_ROOT=/root/.dotnet
ENV PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"

# Install PowerShell Modules from PSGallery
RUN pwsh -command 'Find-Module -Name Pester -RequiredVersion 5.5.0 -Repository PSGallery | Install-Module -Force' && \
    pwsh -command 'Find-Module -Name PSScriptAnalyzer -Repository PSGallery | Install-Module -Force' && \
    pwsh -command 'Find-Module -Name powershell-yaml -Repository PSGallery | Install-Module -Force'

# Install Codecov Uploader
RUN wget -qO- 'https://keybase.io/codecovsecurity/pgp_keys.asc' | gpg --no-default-keyring --keyring /root/trustedkeys.gpg --import && \
    wget 'https://uploader.codecov.io/latest/linux/codecov' && \
    wget 'https://uploader.codecov.io/latest/linux/codecov.SHA256SUM' && \
    wget 'https://uploader.codecov.io/latest/linux/codecov.SHA256SUM.sig' && \
    gpg --no-default-keyring --keyring /root/trustedkeys.gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM    
RUN shasum -a 256 -c codecov.SHA256SUM && \
    chmod +x codecov && \
    mv codecov /usr/local/bin/codecov && \
    codecov --version

# Install Coverails
RUN curl -L https://coveralls.io/coveralls-linux.tar.gz | tar -xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/coveralls && \
    coveralls --version

# Verify installations
RUN pwsh -Command '$PSVersionTable.PSVersion.ToString()' && \
    pwsh -command 'nuget help | select -First 1' && \
    pwsh -command 'dotnet --info'

# copy dependencies for: psmpacker, nupsforge
COPY ./includes/modules/quicklog /root/.local/share/powershell/Modules/quicklog
COPY ./includes/modules/tadpol /root/.local/share/powershell/Modules/tadpol
COPY ./includes/modules/shelldock /root/.local/share/powershell/Modules/shelldock
COPY ./includes/modules/colorconsole /root/.local/share/powershell/Modules/colorconsole
COPY ./includes/modules/gitautoversion /root/.local/share/powershell/Modules/gitautoversion

# copy csverfy checksum module
COPY ./includes/modules/csverify /root/.local/share/powershell/Modules/csverify
# copy psmpacker module builder
COPY ./includes/modules/psmpacker /root/.local/share/powershell/Modules/psmpacker
# copy nupsforge package builder
COPY ./includes/modules/nupsforge /root/.local/share/powershell/Modules/nupsforge
# Copy custom ascii artwork cmdlets
COPY ./includes/acsiilogo-template.txt /root/.config/powershell/acsiilogo-template.txt
# copy template profile
COPY ./includes/Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# Set PowerShell as the default shell
CMD ["pwsh"]

# Custom profile 
#ENTRYPOINT ["pwsh", "-File", "/root/.config/powershell/Microsoft.PowerShell_profile.ps1"]
#ENTRYPOINT ["pwsh"]
