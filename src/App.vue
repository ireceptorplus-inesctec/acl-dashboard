<template>
  <div>
    <div>
      <div id="sidebar">
        <!-- <Sidebar @user-is-logged="changeLoginStatus"/> -->
        <Sidebar/>
      </div>
      <div id="app" data-app>
        <router-view class="view"></router-view>
      </div>
    </div>
  </div>
  
</template>

<script>
import Sidebar from '@/components/Sidebar'

export default {
  name: 'App',
  components: {
    Sidebar
  },
  data () {
    return {
    }
  },
  // methods: {
  //   changeLoginStatus() {

  //     console.log('TODO')
  //   }
  // }
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
