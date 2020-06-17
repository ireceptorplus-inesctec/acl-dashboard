<template>
  <div>
    <div v-if="logged">
      <div id="sidebar">
        <Sidebar @user-is-logged="changeLoginStatus"/>
      </div>
      <div id="app">
        <router-view class="view"></router-view>
      </div>
    </div>
    <Login v-else id="login" @user-is-logged="changeLoginStatus">
    </Login>
  </div>
  
</template>

<script>
import Sidebar from '@/components/Sidebar'
import Login from '@/components/Login'
import jwt_decode from 'jwt-decode'

export default {
  name: 'App',
  components: {
    Sidebar,
    Login
  },
  data () {
    return {
      logged: false
    }
  },
  methods: {
    changeLoginStatus(to) {
      this.logged = to
    }
  },
  mounted() {
    if (localStorage.getItem('refresh-token')) {
      var decoded = jwt_decode(localStorage.getItem('refresh-token'))
      if (decoded.exp < (new Date().getTime() + 1) / 1000) {
        this.changeLoginStatus(false)
      } else {
        this.changeLoginStatus(true)
      }
    }
  }
}
</script>

<style>
#login {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: #2d2d2d;
  color: #ffffff;
  height: 100%;
  width: 100%;
  position: fixed;
  top: 0;
  right: 0;
  overflow-x: hidden;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: #2d2d2d;
  color: #ffffff;
  height: 100%;
  width: 80%;
  position: fixed;
  top: 0;
  right: 0;
  overflow-x: hidden;
}

#sidebar {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: #1d1d1d;
  height: 100%;
  width: 20%;
  position: fixed;
  z-index: 1;
  top: 0;
  left: 0;
  overflow-x: hidden;
}
</style>
