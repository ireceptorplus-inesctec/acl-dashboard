<template>
  <div class="shared">
    <h1 v-if="shared_list !== null && shared_list.length > 0" class="title">Shared with me</h1>
    <div v-else-if="shared_list === null" class="text-center">
        <v-progress-circular
            indeterminate
            color="primary"
        ></v-progress-circular>
    </div>
    <h1 v-else class="title">No resources shared with me</h1>
    <div class="listing" v-if="shared_list !== null && shared_list.length > 0">
      <v-text-field
        v-model="to_search"
        label="Search"
        clearable>
          <label>name/scope/username/email</label>
      </v-text-field>
      <v-list
      :style="(mode === 'dark') ? 'background: #37474F;' : 'background: #ffffff;'"
      avatar>
        <v-list-item
        v-for="(shared, index) in resources"
        :key="index"
        :id="shared.id"
        link>
            <v-list-item-avatar class="avatar">
              <v-img
                  v-if="mode === 'dark'"
                  src="@/assets/icons/dna.png"
              ></v-img>
              <v-img
                  v-else
                  src="@/assets/icons/dna-light.png"
              ></v-img>
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
        color: "#2d2d2d",
        to_search: ""
      }
    },
    methods: {
      get_shared_with_me () {
        let url = process.env.VUE_APP_MIDDLEWARE_URL + 'authz/shared_with_me'

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
        },
        resources: function() {
          if (this.shared_list === null || this.shared_list.length === 0) {
            return []
          }

          return this.shared_list.filter(res => {
              return res.resourceName.toLowerCase().includes(this.to_search.toLowerCase()) ||
                res.requesterName.toLowerCase().includes(this.to_search.toLowerCase()) ||
                res.scopeName.toLowerCase().includes(this.to_search.toLowerCase())
          })
        }
    }
  }
</script>

<style scoped>
  .shared {
    padding: 5%;
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