# Use Debian latest as the base image
FROM debian:12.9-slim

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

RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.5/powershell_7.4.5-1.deb_amd64.deb -O /tmp/powershell.deb && \
    dpkg -i /tmp/powershell.deb && \
    apt install -f -y  # Fix dependencies if needed

# Install PowerShell 7.4.5
#RUN apt install -y powershell

# Install NuGet
RUN apt install -y nuget

# Install Chocolatey (using the script)
# RUN mkdir -p /opt/chocolatey && \
#     curl -L https://chocolatey.org/install.ps1 -o /opt/chocolatey/install.ps1 && \
#     chmod +x /opt/chocolatey/install.ps1 && \
#     pwsh -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; /opt/chocolatey/install.ps1"

# Install .net 8SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --channel 8.0

# Set environment variables globally for all shells
ENV DOTNET_ROOT=/root/.dotnet
ENV PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools


# Install PowerShell Modules from PSGallery
RUN pwsh -command 'Find-Module -Name Pester -RequiredVersion 5.5.0 -Repository PSGallery | Install-Module -Force' && \
    pwsh -command 'Find-Module -Name PSScriptAnalyzer -Repository PSGallery | Install-Module -Force' && \
    pwsh -command 'Find-Module -Name powershell-yaml -Repository PSGallery | Install-Module -Force'

RUN wget -qO- 'https://keybase.io/codecovsecurity/pgp_keys.asc' | gpg --no-default-keyring --keyring /root/trustedkeys.gpg --import && \
    wget 'https://uploader.codecov.io/latest/linux/codecov' && \
    wget 'https://uploader.codecov.io/latest/linux/codecov.SHA256SUM' && \
    wget 'https://uploader.codecov.io/latest/linux/codecov.SHA256SUM.sig' && \
    gpg --no-default-keyring --keyring /root/trustedkeys.gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM    
RUN shasum -a 256 -c codecov.SHA256SUM && \
    chmod +x codecov && \
    mv codecov /usr/local/bin/codecov && \
    codecov --help

# Verify installations
RUN pwsh -Command '$PSVersionTable.PSVersion.ToString()' && \
    pwsh -command 'nuget help | select -First 1' && \
    pwsh -command 'dotnet --info'

# copy quicklog dependency for: psmpacker, nupsforge
COPY ./includes/modules/quicklog /root/.local/share/powershell/Modules/quicklog
# copy psmpacker
COPY ./includes/modules/psmpacker /root/.local/share/powershell/Modules/psmpacker
# copy nupsforge
COPY ./includes/modules/nupsforge /root/.local/share/powershell/Modules/nupsforge
# copy csverfy
COPY ./includes/modules/csverify /root/.local/share/powershell/Modules/csverify

# Copy local cmdlets to /root/.config/powershell
COPY ./includes/modules/colorconsole /root/.local/share/powershell/Modules/colorconsole
COPY ./includes/modules/gitautoversion /root/.local/share/powershell/Modules/gitautoversion
COPY ./includes/acsiilogo-template.txt /root/.config/powershell/acsiilogo-template.txt
# copy template profile
COPY ./includes/Microsoft.PowerShell_profile.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1

# Set PowerShell as the default shell
CMD ["pwsh"]

# Custom profile 
#ENTRYPOINT ["pwsh", "-File", "/root/.config/powershell/Microsoft.PowerShell_profile.ps1"]
#ENTRYPOINT ["pwsh"]
