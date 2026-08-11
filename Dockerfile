FROM node:18-alpine

USER root

# Install Python3, pip, ffmpeg, and curl
RUN apk add --no-cache python3 py3-pip ffmpeg curl

# Install n8n globally and edge-tts
RUN npm install n8n -g && \
    pip3 install edge-tts --break-system-packages

USER node

EXPOSE 5678

CMD ["n8n", "start"]
