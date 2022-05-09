<template>
  <div id="resources">
    <ResourcesList v-bind:class="{'list': !details, 'list list-with-details': details}" :resources=resources :selected=selected @select-resource="change_selected" @refresh="get_details" @refreshall="refreshall"></ResourcesList>
    <ResourceDetails class="details" :resources=resources :selected=selected :details=details @refresh="get_details"></ResourceDetails>
  </div>
</template>

<script>
import ResourcesList from '@/components/MyResources/ResourcesList'
import ResourceDetails from '@/components/MyResources/ResourceDetails'
const axios = require('axios')

export default {
    name: "MyResources",
    components: {
      ResourcesList,
      ResourceDetails
    },
    data () {
        return {
            resources: null,
            selected: null,
            details: null
        }
    },
    methods: {
        get_my_resources () {
            let url = process.env.VUE_APP_MIDDLEWARE_URL + 'authz/own_resources'

            axios.get(url)
            .then((response) => {
                this.resources = response.data
                this.add_selected_property()
            })
            .catch(() => {
                this.resources = []
            })
        },
        add_selected_property() {
          this.resources.forEach(resource => {
            resource.selected = ''
          });
        },
        change_selected(to) {
          this.selected = to
          if (to !== null) {
            this.get_details()
          }
        },
        get_details() {
          var id = this.resources[this.selected]._id

          let url = process.env.VUE_APP_MIDDLEWARE_URL + 'authz/resource_details'

          let data = 'resource_id=' + id

          axios.post(url, data)
          .then((response) => {
              let temp_details = []

              response.data.forEach((ticket) => {
                let index = temp_details.findIndex(element => element['user'] == ticket['requesterName'])
                if (index >= 0) {
                    temp_details[index]['scopes'].push(ticket['scopeName'])
                } else {
                    temp_details.push({
                        'user': ticket['requesterName'],
                        'scopes': [
                          ticket['scopeName']
                        ]
                    })
                }
              })
              this.details = temp_details
          })
          .catch(() => {
              this.details = null
          })
        },
        refreshall() {
          this.selected = null
          this.get_my_resources()
        }
    },
    watch: {
        selected: function(val) {
            if (val === null) {
                this.details = null
            }
        }
    },
    mounted () {
        this.get_my_resources()
    }
}
</script>

<style scoped>
  #resources {
    height: 100%;
    padding: 5%;
  }

  .list {
    height: 100%;
    width: 100%;
    overflow-x: hidden;
  }

  .list-with-details {
    width: 70%;
  }

  .details {
    height: 100%;
    width: 30%;
    position: absolute;
    top: 0;
    right: 0;
    overflow-x: hidden;
  }
</style>
