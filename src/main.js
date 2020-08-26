import Vue from 'vue'
import App from './App.vue'
import VueLogger from 'vuejs-logger'

import VueRouter from 'vue-router'
import router from './router'

import keycloak from './plugins/keycloak'
import vuetify from './plugins/vuetify';

import 'material-design-icons-iconfont/dist/material-design-icons.css'
// const axios = require('axios')

Vue.config.productionTip = false

Vue.use(VueRouter)

const loggerOptions = {
  isEnabled: true,
  logLevel: Vue.config.productionTip ? 'error': 'debug',
  stringifyArguments: false,
  showLogLevel: true,
  showMethodName: true,
  separator: '|',
  showConsoleColors: true
}

Vue.use(VueLogger, loggerOptions)

// new Vue({
//   render: h => h(App),
// }).$mount('#app')

keycloak.init({ onLoad: 'login-required' }).then((auth) => {

  if (!auth) {
    window.location.reload()
  } else {
    Vue.$log.info("Authenticated")
  }

  keycloak.loadUserInfo().then(() => {
    localStorage.setItem('access-token', keycloak.token)
    // localStorage.setItem('KEYCLOAK_SESSION', process.env.VUE_APP_KEYCLOAK_REALM + '/' + profile.sub + '/' + keycloak.sessionId)
    // localStorage.setItem('AUTH_SESSION_ID', keycloak.sessionId + '.keycloak')
    // localStorage.setItem('KEYCLOAK_IDENTITY', keycloak.idToken)
    localStorage.setItem('refresh-token', keycloak.refreshToken)
    localStorage.setItem('server', 'turnkey')
    new Vue({
      router,
      vuetify,
      icons: {
        iconfont: 'md'
      },
      render: h => h(App)
    }).$mount('#app')
  })

  setInterval(() => {
    // if (localStorage.getItem('access-token') &&
    //     localStorage.getItem('refresh-token')) {
    //       let url = process.env.VUE_APP_BACKEND_URL + 'refresh/' + localStorage.getItem('server')
    //       let data = 'refresh_token=' + localStorage.getItem('refresh-token')

    //       axios.post(url, data)
    //       .then((response) => {
    //         localStorage.setItem('access-token', response.data.access_token)
    //         localStorage.setItem('refresh-token', response.data.refresh_token)
    //         Vue.$log.debug('Token refreshed ' + response.data)
    //       })
    //       .catch(() => {
    //         Vue.$log.error('Failed to refresh token')
    //       })
    //     }
  // }, 60000)
    keycloak.updateToken(70).then((refreshed) => {

      if (refreshed) {
        Vue.$log.debug('Token refreshed ' + refreshed)
      } else {
        Vue.$log.warn('Token not refreshed, valid for '
        + Math.round(keycloak.tokenParsed.exp + keycloak.timeSkew - new Date().getTime() / 1000)
        + ' seconds')
      }

    }).catch(() => {
      Vue.$log.error('Failed to refresh token')
    })
  }, 25000)
  
}).catch(() => {
  Vue.$log.error('Authenticated failed')
})
