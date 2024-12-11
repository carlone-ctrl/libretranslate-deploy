# Usa la imagen oficial de LibreTranslate como base
FROM libretranslate/libretranslate:latest

# Exponer el puerto que LibreTranslate usa
EXPOSE 5000

# El comando predeterminado que la imagen usa para iniciar LibreTranslate
CMD ["libretranslate"]
