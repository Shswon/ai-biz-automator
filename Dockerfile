FROM n8nio/n8n:latest

USER root

# Install python3, pip, and ffmpeg using Debian's native package manager since n8n base is Debian-based
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install edge-tts without breaking system packages constraint error
RUN pip3 install --no-cache-dir edge-tts --break-system-packages

USER node
