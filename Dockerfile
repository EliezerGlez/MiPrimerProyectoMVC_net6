# Establecer la imagen base para el runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Establecer la imagen para el build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MiPrimerProyectoMVC_net6/MiPrimerProyectoMVC_net6.csproj", "MiPrimerProyectoMVC_net6/"]
RUN dotnet restore "MiPrimerProyectoMVC_net6/MiPrimerProyectoMVC_net6.csproj"
COPY . .
WORKDIR "/src/MiPrimerProyectoMVC_net6"
RUN dotnet build "MiPrimerProyectoMVC_net6.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MiPrimerProyectoMVC_net6.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MiPrimerProyectoMVC_net6.dll"]
