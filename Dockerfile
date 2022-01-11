FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
COPY ["./src/SecurityHeadersTalk.csproj", "src/"]
RUN dotnet restore "src/SecurityHeadersTalk.csproj"
COPY . .
RUN dotnet build "./src/SecurityHeadersTalk.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./src/SecurityHeadersTalk.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SecurityHeadersTalk.dll"]
