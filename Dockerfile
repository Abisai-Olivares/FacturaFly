# 1) Build con .NET 9 SDK
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copia sólo el csproj y restaura (cache layer)
COPY FacturaFly.Client/FacturaFly.Client.csproj ./FacturaFly.Client/
RUN dotnet restore FacturaFly.Client/FacturaFly.Client.csproj

# Copia el resto del código y publica
COPY . .
WORKDIR /app/FacturaFly.Client
RUN dotnet publish -c Release -o /out

# 2) Sirve estáticos con NGINX
FROM nginx:alpine AS runtime
# Opcional: ajusta el puerto con la variable de Railway
ENV PORT 80
EXPOSE 80

# Copia la carpeta wwwroot generada al directorio público de nginx
COPY --from=build /out/wwwroot /usr/share/nginx/html

# Arranca nginx en foreground
CMD ["nginx", "-g", "daemon off;"]
