FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    libcurl4 \
    libssl3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# تحميل وتفكيك أحدث إصدار لسيرفر BombSquad
RUN DOWNLOAD_URL=$(curl -s https://ballistica.net/downloads | grep -oP 'https://files\.ballistica\.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_[^"]+\.tar\.gz' | head -n 1) \
    && if [ -z "$DOWNLOAD_URL" ]; then DOWNLOAD_URL="https://files.ballistica.net/bombsquad/builds/BombSquad_Server_Linux_x86_64_v1.7.36.tar.gz"; fi \
    && wget "$DOWNLOAD_URL" -O server.tar.gz \
    && tar -xzf server.tar.gz --strip-components=1 \
    && rm server.tar.gz

# ربط بيئة Python المدمجة التابعة لـ BombSquad مع النظام
RUN ln -sf /app/dist/bin/python3.14 /usr/bin/python3.14 && \
    ln -sf /app/dist/bin/python3.14 /usr/local/bin/python3.14

# تعيين مسارات المكتبات المدمجة لضمان عمل Python 3.14 المدمج
ENV LD_LIBRARY_PATH="/app/dist/lib:/app/dist/syslibs:$LD_LIBRARY_PATH"
ENV PYTHONPATH="/app/dist/ba_data/python:/app"

COPY config.py /app/config.py

EXPOSE 43210/udp

CMD ["./bombsquad_server"]
