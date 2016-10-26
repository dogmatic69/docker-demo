FROM node

WORKDIR /app

ENV PORT=1234

EXPOSE $PORT


COPY . /app

RUN npm install -g pm2 && npm install && npm dedupe

RUN apt update && apt install -y w3m w3m-img

ENTRYPOINT /app/start.sh
