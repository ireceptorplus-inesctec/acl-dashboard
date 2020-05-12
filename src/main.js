import Vue from 'vue'
import App from './App.vue'
import VueLogger from 'vuejs-logger'

import Keycloak from 'keycloak-js'
import keycloakJson from './assets/keycloak.json'

Vue.config.productionTip = false

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

let initOptions = {
  url: keycloakJson['auth-server-url'],
  realm: keycloakJson['realm'],
  clientId: keycloakJson['resource'],
  onLoad: 'login-required'
}

let keycloak = Keycloak(initOptions)

keycloak.init({ onLoad: initOptions.onLoad }).then((auth) => {

  if (!auth) {
    window.location.reload()
  } else {
    Vue.$log.info("Authenticated")
  }

  new Vue({
    render: h => h(App),
  }).$mount('#app')

  localStorage.setItem('access-token', keycloak.token)
  localStorage.setItem('refresh-token', keycloak.refreshToken)

  setInterval(() => {
    keycloak.updateToken(70).success((refreshed) => {

      if (refreshed) {
        Vue.$log.debug('Token refreshed ' + refreshed)
      } else {
        Vue.$log.warn('Token not refreshed, valid for '
        + Math.round(keycloak.tokenParsed.exp + keycloak.timeSkew - new Date().getTime() / 1000)
        + ' seconds')
      }

    }).error(() => {
      Vue.$log.error('Failed to refresh token')
    })
  }, 60000)
  
}).catch(() => {
  Vue.$log.error('Authenticated failed')
})
