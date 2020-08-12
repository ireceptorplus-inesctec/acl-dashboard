module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  publicPath: process.env.NODE_ENV === 'production'
    ? '/dashboard-acl/'
    : '/'
}

console.log("Deployment envirnoment: ", process.env.NODE_ENV)