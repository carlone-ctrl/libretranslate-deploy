# Usa la imagen oficial de LibreTranslate como base
FROM libretranslate/libretranslate:latest

# Instala dependencias adicionales (si es necesario)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Exponer el puerto que LibreTranslate usa
EXPOSE 5000

# Establecer el ENTRYPOINT para iniciar LibreTranslate
ENTRYPOINT ["./venv/bin/libretranslate", "--host", "*", "--port", "5000"]
