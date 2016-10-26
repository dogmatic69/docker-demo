FROM node

WORKDIR /app

ENV PORT=1234

EXPOSE $PORT


COPY . /app

RUN npm install -g pm2 && npm install && npm dedupe

ENTRYPOINT /app/start.sh
