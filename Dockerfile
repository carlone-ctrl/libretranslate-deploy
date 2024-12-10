# Usa la imagen oficial de LibreTranslate como base
FROM libretranslate/libretranslate:latest

# Instala dependencias adicionales (si es necesario)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Asegúrate de que el script de inicio tenga permisos de ejecución
RUN chmod +x /start.sh

# Exponer el puerto que LibreTranslate usa
EXPOSE 5000

# Comando para iniciar LibreTranslate
CMD ["./start.sh"]
