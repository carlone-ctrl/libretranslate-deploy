# Usa la imagen oficial de LibreTranslate como base
FROM libretranslate/libretranslate:latest

# Exponer el puerto
EXPOSE 5000

# Comando para ejecutar el servicio
CMD ["./start.sh"]
