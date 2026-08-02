FROM ubuntu:22.04

# تثبيت الحزم الأساسية
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# تنزيل ملفات السيرفر الرسمية وفك الضغط
RUN wget https://files.ballistica.net/bombsquad/builds/BombSquad_Server_Linux_64bit_v1.7.35.tar.gz \
    && tar -xzf BombSquad_Server_Linux_64bit_v1.7.35.tar.gz \
    && mv BombSquad_Server_Linux_64bit_v1.7.35/* . \
    && rm -rf BombSquad_Server_Linux_64bit_v1.7.35*

# نسخ ملف الإعدادات
COPY config.py /app/config.py

EXPOSE 43210/udp

CMD ["./bombsquad_server"]
