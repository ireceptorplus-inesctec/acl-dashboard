import Vue from 'vue'
import VueX from 'vuex'
import App from './App.vue'
import VueLogger from 'vuejs-logger'

import VueRouter from 'vue-router'
import router from './router'

import keycloak from './plugins/keycloak'
import vuetify from './plugins/vuetify';

import 'material-design-icons-iconfont/dist/material-design-icons.css'

const axios = require('axios')

Vue.config.productionTip = false

Vue.use(VueRouter)
Vue.use(VueX)

const store = new VueX.Store({
  state: {
    mode: 'light'
  },
  mutations: {
    changetheme (state) {
      state.mode = state.mode === 'dark' ? 'light' : 'dark'
    }
  }
})

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

keycloak.init({ onLoad: 'login-required', 'checkLoginIframe': false }).then((auth) => {

  if (!auth) {
    window.location.reload()
  } else {
    Vue.$log.info("Authenticated")
  }

  keycloak.loadUserInfo().then(() => {
    localStorage.setItem('access-token', keycloak.token)
    localStorage.setItem('refresh-token', keycloak.refreshToken)
    new Vue({
      router,
      vuetify,
      store,
      icons: {
        iconfont: 'md'
      },
      render: h => h(App)
    }).$mount('#app')
  })

  axios.interceptors.request.use(function (config) {
    return keycloak.updateToken(50)
      .then(function(refreshed) {
        if (refreshed) {
          Vue.$log.debug('Token refreshed ' + refreshed)
        } else {
          Vue.$log.debug('Token not refreshed, valid for '
          + Math.round(keycloak.tokenParsed.exp + keycloak.timeSkew - new Date().getTime() / 1000)
          + ' seconds')
        }
        config.headers.Authorization = 'Bearer ' + keycloak.token
        return Promise.resolve(config)
      }).catch(function() {
        Vue.$log.error('Failed to refresh token')
      })
  }, function (error) {
    return Promise.reject(error)
  })

}).catch(() => {
  Vue.$log.error('Authenticated failed')
})
