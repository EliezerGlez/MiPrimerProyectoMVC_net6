# Establecer la imagen base para el runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Establecer la imagen para el build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MiPrimerProyectoMVC/MiPrimerProyectoMVC.csproj", "MiPrimerProyectoMVC/"]
RUN dotnet restore "MiPrimerProyectoMVC/MiPrimerProyectoMVC.csproj"
COPY . .
WORKDIR "/src/MiPrimerProyectoMVC"
RUN dotnet build "MiPrimerProyectoMVC.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MiPrimerProyectoMVC.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MiPrimerProyectoMVC.dll"]
