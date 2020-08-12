import * as Keycloak from 'keycloak-js';

let initOptions = {
    url: process.env.VUE_APP_KEYCLOAK_URL,
    realm: process.env.VUE_APP_KEYCLOAK_REALM,
    clientId: process.env.VUE_APP_KEYCLOAK_CLIENT_ID,
    onLoad: 'login-required',
    checkLoginIframe: false
  }

let keycloak = Keycloak(initOptions);

export default keycloak;
