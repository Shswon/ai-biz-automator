FROM n8nio/n8n:latest

USER root

# Install Python3, pip, and ffmpeg
RUN apk add --no-cache python3 py3-pip ffmpeg curl

# Install edge-tts cleanly
RUN pip3 install edge-tts --break-system-packages

USER node
