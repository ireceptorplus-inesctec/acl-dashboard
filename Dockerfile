FROM node:16.15.0-alpine3.15 as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build-docker

FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY --from=build-stage /app/scripts /tmp/scripts
COPY --from=build-stage /app/scripts/default.conf /etc/nginx/conf.d/default.conf
CMD [ "sh", "/tmp/scripts/run_docker.sh" ]