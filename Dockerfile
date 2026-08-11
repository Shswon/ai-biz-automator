FROM n8nio/n8n:latest

USER root

# Install Python3, pip, curl, and FFmpeg
RUN apk add --no-cache python3 py3-pip ffmpeg curl fonts-freefont

# Install Edge-TTS Python Package
RUN pip3 install edge-tts --break-system-packages

USER node
