FROM microsoft/dotnet:3.0-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:3.0-sdk AS build
WORKDIR /src
COPY ["sample/sample.csproj", "sample/"]
RUN dotnet restore "sample/sample.csproj"
COPY . .
WORKDIR "/src/sample"
RUN dotnet build "sample.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "sample.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "sample.dll"]
