# --- STAGE 1: Build con .NET 9 SDK ---
    FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
    WORKDIR /app
    
    # Copia el archivo .csproj con su nombre correcto
    COPY FacturaFly.Client.csproj ./
    RUN dotnet restore
    
    # Copia el resto del proyecto
    COPY . ./
    RUN dotnet publish -c Release -o /out
    
    # --- STAGE 2: Runtime con NGINX ---
    FROM nginx:alpine AS runtime
    ENV PORT 80
    EXPOSE 80
    
    # Copia los archivos publicados estáticos
    COPY --from=build /out/wwwroot /usr/share/nginx/html
    
    CMD ["nginx", "-g", "daemon off;"]
    
    