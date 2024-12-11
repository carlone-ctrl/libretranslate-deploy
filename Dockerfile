# Usa la imagen oficial de LibreTranslate como base
FROM libretranslate/libretranslate:latest

# Exponer el puerto 5000
EXPOSE 5000

# Configura el servidor para escuchar en el puerto 5000
CMD ["bash", "-c", "./start.sh --host 0.0.0.0 --port 5000"
