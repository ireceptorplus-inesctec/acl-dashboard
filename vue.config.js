var publicPath = "/";

if (process.env.PUBLIC_PATH) {
  publicPath = process.env.PUBLIC_PATH;
} else {
  publicPath = (process.env.NODE_ENV === 'production')  ? '/acl-dashboard/'  : '/'
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
