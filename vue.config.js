module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  publicPath: process.env.NODE_ENV === 'production'
    ? '/acl-dashboard/'
    : '/'
}

console.log("Deployment envirnoment: ", process.env.NODE_ENV)