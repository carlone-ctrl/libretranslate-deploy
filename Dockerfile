# Usar una imagen base de Python
FROM python:3.9-slim

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar el archivo de requisitos a /app
COPY requirements.txt /app/

# Instalar las dependencias de Python
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar el archivo app.py a /app
COPY app.py /app/

# Copiar la carpeta libretranslate-deploy a /app/libretranslate-deploy
COPY libretranslate-deploy /app/libretranslate-deploy

# Definir el comando para ejecutar tu aplicación
CMD ["python", "app.py"]
