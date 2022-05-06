FROM node:16.15.0-alpine3.15

WORKDIR /app

COPY package*.json ./

RUN npm install -g http-server
RUN npm install

COPY . .

ENV BUILD_ENV=docker

RUN npm run build

CMD [ "http-server", "dist" ]