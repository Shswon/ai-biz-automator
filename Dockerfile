FROM python:3.10-slim

WORKDIR /app

# Install system dependencies including ffmpeg
RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install edge-tts cleanly
RUN pip install --no-cache-dir edge-tts

EXPOSE 7860

CMD ["python", "-c", "print('AI Biz Automator Ready!')"]
