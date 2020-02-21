FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["DockerApplication/DockerApplication.csproj", "DockerApplication/"]
RUN dotnet restore "DockerApplication/DockerApplication.csproj"
COPY . .
WORKDIR "/src/DockerApplication"
RUN dotnet build "DockerApplication.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DockerApplication.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerApplication.dll"]