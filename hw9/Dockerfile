FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["OzWebApp/OzWebApp.csproj", "OzWebApp/"]
RUN dotnet restore "OzWebApp/OzWebApp.csproj"
COPY . .
WORKDIR "/src/OzWebApp"
RUN dotnet build "OzWebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OzWebApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OzWebApp.dll"]
