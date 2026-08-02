FROM python:3.10-slim

# تثبيت الأدوات والمكتبات الأساسية للتشغيل
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    wget \
    libcurl4 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# تحميل وتفكيك سيرفر BombSquad الرسمي
RUN wget https://files.ballistica.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_v1.7.35.tar.gz -O server.tar.gz \
    && tar -xzf server.tar.gz --strip-components=1 \
    && rm server.tar.gz

# نسخ ملف الإعدادات
COPY config.py /app/config.py

# فتح منفذ الـ Web Service
EXPOSE 10000

# تشغيل السيرفر
CMD ["./bombsquad_server"]
