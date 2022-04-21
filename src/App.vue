<template>
<v-app>
  <Navigation/>
  <v-content>
    <router-view class="view"></router-view>
  </v-content>
</v-app>
</template>

<script>
import Navigation from '@/components/Navigation'

export default {
  name: 'App',
  components: {
    Navigation
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
.v-application {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.light {
  background: #ffffff !important;
  color: #263238 !important;
}
</style>
