var publicPath = "/";

if (process.env.PUBLIC_PATH) {
  publicPath = process.env.PUBLIC_PATH;
} else {
  if (process.env.NODE_ENV === 'production') {
    publicPath = "/acl-dashboard/";
  } else if (process.env.NODE_ENV === 'docker') {
    publicPath = "PUBLIC_PATH_DOCKER";
  } else {
    publicPath = "/";
  }
}

module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  publicPath: publicPath
}

console.log("Deployment envirnoment: ", process.env.NODE_ENV)
console.log("Public Path: ", process.env.PUBLIC_PATH)
console.log("Auth Service: ", process.env.VUE_APP_KEYCLOAK_URL)
