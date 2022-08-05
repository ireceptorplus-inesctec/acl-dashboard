FROM node:16.16-alpine3.16 as build-stage

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build-docker

FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY --from=build-stage /app/scripts /tmp/scripts
COPY --from=build-stage /app/scripts/default.conf /etc/nginx/conf.d/default.conf

ENV NGINX_PORT=8081
EXPOSE 8081

CMD [ "sh", "/tmp/scripts/run_docker.sh" ]