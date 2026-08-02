FROM ubuntu:22.04

# تثبيت مكتبات النظام الأساسية
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    libcurl4 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# تحميل وتفكيك سيرفر BombSquad الرسمي
RUN DOWNLOAD_URL=$(curl -s https://ballistica.net/downloads | grep -oP 'https://files\.ballistica\.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_[^"]+\.tar\.gz' | head -n 1) \
    && if [ -z "$DOWNLOAD_URL" ]; then DOWNLOAD_URL="https://files.ballistica.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_v1.7.36.tar.gz"; fi \
    && wget "$DOWNLOAD_URL" -O server.tar.gz \
    && tar -xzf server.tar.gz --strip-components=1 \
    && rm server.tar.gz

# نسخ ملف الإعدادات
COPY config.py /app/config.py

# فتح منفذ الـ Web Service
EXPOSE 10000

# تشغيل السيرفر باستخدام بيئة Python المدمجة مع اللعبة ذاتها
CMD ["./bombsquad_server", "-no-stdin"]
