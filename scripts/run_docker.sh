#!/bin/sh

echo "Replacing env constants in JS"

for file in /usr/share/nginx/html/js/app*.js* /usr/share/nginx/html/index.html;
do
  echo "Processing $file ...";

  sed -i 's|PUBLIC_PATH_DOCKER|'${PUBLIC_PATH}'|g' $file
  sed -i 's|VUE_APP_KEYCLOAK_URL_DOCKER|'${VUE_APP_KEYCLOAK_URL}'|g' $file
  sed -i 's|VUE_APP_KEYCLOAK_REALM_DOCKER|'${VUE_APP_KEYCLOAK_REALM}'|g' $file
  sed -i 's|VUE_APP_KEYCLOAK_CLIENT_ID_DOCKER|'${VUE_APP_KEYCLOAK_CLIENT_ID}'|g' $file
  sed -i 's|VUE_APP_MIDDLEWARE_URL_DOCKER|'${VUE_APP_MIDDLEWARE_URL}'|g' $file
done

echo "Public Path configured to: $PUBLIC_PATH"

nginx -g 'daemon off;'