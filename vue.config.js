module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  publicPath: (process.env.NODE_ENV === 'production' && process.env.BUILD_ENV != 'docker')
    ? '/acl-dashboard/'
    : '/'
}

console.log("Deployment envirnoment: ", process.env.NODE_ENV)