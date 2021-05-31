<template>
    <div class="pending">
        <h1 class="title">Pending requests</h1>
        <div class="listing">
            <v-list
             :dark="(mode === 'dark')"
             rounded
             :color="color"
             three-line
             avatar>
                <v-list-item
                 v-for="(pending, index) in pending_list"
                 :key="index"
                 link
                 :id="pending.id">
                     <v-list-item-avatar class="avatar">
                        <v-img src="@/assets/icons/dna.png"></v-img>
                     </v-list-item-avatar>

                     <v-list-item-content class="name">
                         <v-list-item-title>{{ pending.resourceName }}</v-list-item-title>
                         <v-list-item-title>by {{ pending.requesterName }}</v-list-item-title>
                     </v-list-item-content>

                     <v-list-item-content>
                         <v-list-item-subtitle>Scope:</v-list-item-subtitle>
                         <p>{{ pending.scopeName }}</p>
                     </v-list-item-content>

                    <v-list-item-content class="accept" v-on:click="accept(index)">
                        <v-icon large class="accico">check</v-icon>
                    </v-list-item-content>

                    <v-list-item-content class="deny" v-on:click="deny(index)">
                        <v-icon large class="denico">close</v-icon>
                    </v-list-item-content>
                </v-list-item>
            </v-list>
        </div>
    </div>
</template>

<script>

const axios = require('axios')

export default {
    name: "PendingRequests",
    data () {
        return {
            pending_list: null,
            color: "#2d2d2d"
        }
    },
    methods: {
        get_pending_requests () {
            let url = process.env.VUE_APP_BACKEND_URL +
                    'pending_requests/' + localStorage.getItem('server')

            let config = {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('access-token')
                }
            }

            axios.get(url, config)
            .then((response) => {
                this.pending_list = response.data
            })
            .catch(() => {
                this.pending_list = []
            })
        },
        accept(index) {
            let url = process.env.VUE_APP_BACKEND_URL +
                    'give_access/' + localStorage.getItem('server') + '/' +
                    this.pending_list[index].id

            let config = {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('access-token')
                }
            }

            let data = 'resource_id=' + this.pending_list[index].resource +
                        '&requester_id=' + this.pending_list[index].requester +
                        '&scope_name=' + this.pending_list[index].scopeName

            axios.post(url, data, config)
            .then(() => {
                this.get_pending_requests()
            })
            .catch(() => {
                alert('Error accepting request')
            })
        },
        deny(index) {
            let url = process.env.VUE_APP_BACKEND_URL +
                    'deny/' + localStorage.getItem('server') + '/' +
                    this.pending_list[index].id

            let config = {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('access-token')
                }
            }

            axios.delete(url, config)
            .then(() => {
                this.get_pending_requests()
            })
            .catch(() => {
                alert('Error denying request')
            })
        }
    },
    mounted () {
        this.get_pending_requests()
    },
    computed: {
        mode: function() {
            return this.$store.state.mode
        }
    }
}
</script>

<style scoped>
    .pending {
        padding: 5%;
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

    .accept {
        margin: 0 !important;
        position: absolute;
        right: 12%;
        top: 50%;
        -ms-transform: translateY(-50%);
        transform: translateY(-50%);
    }

    .deny {
        margin: 0 !important;
        position: absolute;
        right: 5%;
        top: 50%;
        -ms-transform: translateY(-50%);
        transform: translateY(-50%);
    }
</style>