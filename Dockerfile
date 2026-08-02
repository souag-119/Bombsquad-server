FROM python:3.11-slim

# تثبيت الأدوات والمكتبات اللازمة للعبة
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    libcurl4 \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# جلب أحدث سيرفر BombSquad وتحميله
RUN DOWNLOAD_URL=$(curl -s https://ballistica.net/downloads | grep -oP 'https://files\.ballistica\.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_[^"]+\.tar\.gz' | head -n 1) \
    && if [ -z "$DOWNLOAD_URL" ]; then DOWNLOAD_URL="https://files.ballistica.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_v1.7.36.tar.gz"; fi \
    && wget "$DOWNLOAD_URL" -O server.tar.gz \
    && tar -xzf server.tar.gz --strip-components=1 \
    && rm server.tar.gz

# ربط python3.14 و python3 بحزمة Python 3.11 الحالية (التي تحتوي على tomllib)
RUN ln -sf $(which python3) /usr/bin/python3.14 && \
    ln -sf $(which python3) /usr/local/bin/python3.14

# نسخ ملف الإعدادات
COPY config.py /app/config.py

# فتح المنفذ الخاص بـ Render
EXPOSE 10000

# تشغيل السيرفر بدون شاشة تفاعلية
CMD ["./bombsquad_server", "-no-stdin"]
