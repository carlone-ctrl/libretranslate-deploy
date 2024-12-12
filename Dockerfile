# Usar una imagen base de Python
FROM python:3.9-slim

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar el archivo de requisitos y otros archivos necesarios al contenedor
COPY requirements.txt /app/

# Instalar las dependencias de Python
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar el resto de tu aplicación al contenedor
COPY libretranslate-deploy /app

# Definir el comando para ejecutar tu aplicación
CMD ["python", "app.py"]
