FROM node:16.15.0-alpine3.15

ENV BUILD_ENV=docker

WORKDIR /app

COPY package*.json ./

RUN npm install -g http-server

RUN npm install

COPY . .

RUN npm run build-docker

RUN rm -r node_modules .git

RUN npm cache clean --force

RUN chmod +x scripts/run_docker.sh

CMD [ "sh", "./scripts/run_docker.sh" ]