<template>
<v-app>
  <div>
    <div>
      <div id="sidebar">
        <Sidebar/>
      </div>
      <div id="app" data-app :class="(mode === 'dark') ? '' : 'light'">
        <router-view class="view"></router-view>
      </div>
    </div>
  </div>
</v-app>
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
  computed: {
      mode: function() {
        return this.$store.state.mode
      }
  }
}
</script>

<style>
.light {
  background: #ffffff !important;
  color: #263238 !important;
}

#login {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: #37474F;
  color: #CFD8DC;
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
  background: #37474F;
  color: #CFD8DC;
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
  z-index: -1;
  top: 0;
  left: 0;
  overflow-x: hidden;
}
</style>
