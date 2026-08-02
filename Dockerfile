FROM ubuntu:22.04

# تثبيت مكتبات النظام الأساسية وتثبيت python3 لتأمين البيئة
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    libcurl4 \
    libssl3 \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# تحميل وتفكيك سيرفر BombSquad الرسمي
RUN DOWNLOAD_URL=$(curl -s https://ballistica.net/downloads | grep -oP 'https://files\.ballistica\.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_[^"]+\.tar\.gz' | head -n 1) \
    && if [ -z "$DOWNLOAD_URL" ]; then DOWNLOAD_URL="https://files.ballistica.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_v1.7.36.tar.gz"; fi \
    && wget "$DOWNLOAD_URL" -O server.tar.gz \
    && tar -xzf server.tar.gz --strip-components=1 \
    && rm server.tar.gz

# إنشاء رابط رمزي لـ python3.14 ليتعرف عليه أي سكريبت فرعي
RUN ln -sf $(which python3) /usr/bin/python3.14 && \
    ln -sf $(which python3) /usr/local/bin/python3.14

# نسخ ملف الإعدادات
COPY config.py /app/config.py

# إعداد المسارات المباشرة لمكتبات اللعبة
ENV PYTHONPATH="/app/dist/ba_data/python:/app"

# فتح منفذ الـ Web Service
EXPOSE 10000

# تشغيل محرك السيرفر مباشرة
CMD ["python3", "-m", "bacommon.servermanager", "-no-stdin"]
