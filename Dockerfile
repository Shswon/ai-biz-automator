FROM n8nio/n8n:latest

USER root

# Install Python3, pip, and ffmpeg for Debian/Ubuntu based image
RUN apt-get update && apt-get install -y python3 python3-pip ffmpeg curl

# Install edge-tts cleanly
RUN pip3 install edge-tts --break-system-packages

USER node
