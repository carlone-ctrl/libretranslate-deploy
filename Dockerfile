FROM libretranslate/libretranslate:latest

# Exponer el puerto que LibreTranslate usa
EXPOSE 5000

# Comando para iniciar LibreTranslate
CMD ["./start.sh"]
