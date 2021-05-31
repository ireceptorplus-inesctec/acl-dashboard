<template>
  <div>
    <div>
      <div id="sidebar">
        <!-- <Sidebar @user-is-logged="changeLoginStatus"/> -->
        <Sidebar/>
      </div>
      <div id="app" data-app :class="(mode === 'dark') ? '' : 'light'">
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
  mounted() {
    // setInterval(() => {
    //   this.$store.commit('changetheme')
    // }, 1000)
  },
  computed: {
      mode: function() {
        return this.$store.state.mode
      }
  }
  // methods: {
  //   changeLoginStatus() {

  //     console.log('TODO')
  //   }
  // }
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

/* width */
::-webkit-scrollbar {
  width: 15px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #1d1d1d;
}

/* Handle */
::-webkit-scrollbar-thumb {
  background:#3a3a3a;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background:#bbbbbb;
}
</style>
