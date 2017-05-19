FROM ubuntu:14.04

# Install Dependencies
RUN apt-get update \
	&& apt-get install -y curl gettext libunwind8 libcurl4-openssl-dev libicu-dev libssl-dev git

# Install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

RUN echo "deb http://download.mono-project.com/repo/debian wheezy/snapshots/4.2.3.4 main" > /etc/apt/sources.list.d/mono-xamarin.list \
	&& apt-get update \
	&& apt-get install -y mono-devel ca-certificates-mono fsharp mono-vbnc nuget \
	&& rm -rf /var/lib/apt/lists/*



# Install .NET Core
RUN mkdir -p /opt/dotnet \
    && curl -Lsfo /opt/dotnet/dotnet-install.sh https://raw.githubusercontent.com/dotnet/cli/rel/1.1.0/scripts/obtain/dotnet-install.sh \
    && bash /opt/dotnet/dotnet-install.sh --version 1.0.0-preview2-003131 --install-dir /opt/dotnet \
    && ln -s /opt/dotnet/dotnet /usr/local/bin

# Install NuGet
RUN mkdir -p /opt/nuget \
    && curl -Lsfo /opt/nuget/nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe

# Prime dotnet
RUN mkdir dotnettest \
    && cd dotnettest \
    && dotnet new \
    && dotnet restore \
    && dotnet build \
    && cd .. \
    && rm -r dotnettest


# Display info installed components
RUN mono --version
RUN dotnet --info
