FROM python:3.10-slim

# تثبيت المكتبات والأدوات المطلوب
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    wget \
    libcurl4 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# جلب أحدث سيرفر BombSquad وتحميله
RUN DOWNLOAD_URL=$(curl -s https://ballistica.net/downloads | grep -oP 'https://files\.ballistica\.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_[^"]+\.tar\.gz' | head -n 1) \
    && if [ -z "$DOWNLOAD_URL" ]; then DOWNLOAD_URL="https://files.ballistica.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_v1.7.36.tar.gz"; fi \
    && wget "$DOWNLOAD_URL" -O server.tar.gz \
    && tar -xzf server.tar.gz --strip-components=1 \
    && rm server.tar.gz

# ربط النسخ لتفادي مشاكل المسارات
RUN ln -sf $(which python3) /usr/local/bin/python3.14 && \
    ln -sf $(which python3) /usr/bin/python3.14

# نسخ ملف Configuration
COPY config.py /app/config.py

# فتح المنفذ المطلوب لـ Render
EXPOSE 10000

# تشغيل السيرفر مع إظهار تفاصيل الأخطاء كاملة في الـ Logs
CMD ["./bombsquad_server"]
