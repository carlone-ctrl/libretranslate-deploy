FROM libretranslate/libretranslate:latest

# Cambiar al usuario root para instalar dependencias
USER root

# Exponer el puerto que LibreTranslate usa
EXPOSE 5000

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y curl git python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Copiar el código fuente al contenedor
COPY . /app

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar las dependencias de Python
RUN pip3 install -r requirements.txt

# Cambiar al usuario libretranslate para ejecutar la aplicación
USER libretranslate

# Comando para ejecutar la aplicación
CMD ["python3", "app.py"]
