# -------- STAGE 1: Build --------
    FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
    WORKDIR /app
    
    # Copiamos el csproj y restauramos dependencias
    COPY FacturaFly.csproj ./
    RUN dotnet restore
    
    # Copiamos el resto y publicamos la app
    COPY . ./
    RUN dotnet publish -c Release -o /out
    
    # -------- STAGE 2: Runtime con NGINX --------
    FROM nginx:alpine AS runtime
    ENV PORT 80
    EXPOSE 80
    
    # Copiamos archivos estáticos generados por Blazor a nginx
    COPY --from=build /out/wwwroot /usr/share/nginx/html
    
    # Iniciamos NGINX
    CMD ["nginx", "-g", "daemon off;"]
    