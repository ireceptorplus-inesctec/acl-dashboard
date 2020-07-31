<template>
  <div id="resources">
    <ResourcesList class="list" :resources=resources :selected=selected @select-resource="change_selected" @refresh="get_details"></ResourcesList>
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
        get_my_requests () {
            var interv = setInterval(() => {
                this.get_my_requests()
            }, 5000)
            let url = process.env.VUE_APP_BACKEND_URL + 'own_resources/' + localStorage.getItem('server')
            let config = {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('access-token')
                }
            }

            axios.get(url, config)
            .then((response) => {
                this.resources = response.data
                this.add_selected_property()
                clearInterval(interv)
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

          let url = process.env.VUE_APP_BACKEND_URL +
                      'resource_details/' + localStorage.getItem('server')

          let config = {
              headers: {
                  'Authorization': 'Bearer ' + localStorage.getItem('access-token')
              }
          }

          let data = 'resource_id=' + id

          axios.post(url, data, config)
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
        this.get_my_requests()
    }
}
</script>

<style scoped>
  #resources {
    height: 100%;
  }

  .list {
    height: 100%;
    width: 50%;
    position: absolute;
    top: 0;
    left: 0;
    overflow-x: hidden;
    /* background: red; */
  }

  .details {
    height: 100%;
    width: 50%;
    position: absolute;
    top: 0;
    right: 0;
    overflow-x: hidden;
    /* background: green; */
  }
</style>
