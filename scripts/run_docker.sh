#!/bin/sh

echo "Replacing env constants in JS"

for file in dist/js/app.*.js* dist/$ROOT_DIR/index.html dist/precache-manifest*.js;
do
  echo "Processing $file ...";

  sed -i 's|PUBLIC_PATH_DOCKER|'${PUBLIC_PATH}'|g' $file
  sed -i 's|VUE_APP_KEYCLOAK_URL_DOCKER|'${VUE_APP_KEYCLOAK_URL}'|g' $file
  sed -i 's|VUE_APP_KEYCLOAK_REALM_DOCKER|'${VUE_APP_KEYCLOAK_REALM}'|g' $file
  sed -i 's|VUE_APP_KEYCLOAK_CLIENT_ID_DOCKER|'${VUE_APP_KEYCLOAK_CLIENT_ID}'|g' $file
  sed -i 's|VUE_APP_MIDDLEWARE_URL_DOCKER|'${VUE_APP_MIDDLEWARE_URL}'|g' $file
done

echo "Here's the public path"
echo $PUBLIC_PATH

http-server dist