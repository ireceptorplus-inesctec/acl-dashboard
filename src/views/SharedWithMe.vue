<template>
  <div class="shared">
    <h1 class="title">Shared with me</h1>
    <div class="listing">
      <v-list
      :dark="(mode === 'dark')"
      rounded
      :color="color"
      three-line
      avatar>
        <v-list-item
        v-for="(shared, index) in shared_list"
        :key="index"
        link
        :id="shared.id">
            <v-list-item-avatar class="avatar">
              <v-img src="@/assets/icons/dna.png"></v-img>
            </v-list-item-avatar>

            <v-list-item-content class="name">
              <v-list-item-title>{{ shared.resourceName }}</v-list-item-title>
              <v-list-item-title>from {{ shared.ownerName }}</v-list-item-title>
            </v-list-item-content>

            <v-list-item-content>
              <v-list-item-subtitle>Scope:</v-list-item-subtitle>
              <p>{{ shared.scopeName }}</p>
            </v-list-item-content>
        </v-list-item>
      </v-list>
    </div>
  </div>
</template>

<script>

const axios = require('axios')

  export default {
    name: 'SharedWithMe',
    data () {
      return {
        shared_list: null,
        color: "#2d2d2d"
      }
    },
    methods: {
      get_shared_with_me () {
        let url = process.env.VUE_APP_BACKEND_URL +
                'shared_with_me/' + localStorage.getItem('server')

        axios.get(url)
        .then((response) => {
          this.shared_list = response.data
        })
        .catch(() => {
          this.shared_list = []
        })
      }
    },
    mounted() {
      this.get_shared_with_me()
    },
    computed: {
        mode: function() {
          return this.$store.state.mode
        }
    }
  }
</script>

<style scoped>
  .shared {
    height: 100%;
    width: 50%;
    position: absolute;
    top: 0;
    left: 0;
    padding: 5%;
    overflow-x: hidden;
  }

  .title {
    text-align: center;
    font-size: 300%;
  }

  .avatar {
    margin: 0 !important;
    position: absolute;
    left: 5%;
    top: 50%;
    -ms-transform: translateY(-50%);
    transform: translateY(-50%);
  }

  .name {
    margin-left: 15%;
  }
</style>