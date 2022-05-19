<template>
    <div class="pending">
        <h1 v-if="pending_list !== null && pending_list.length > 0" class="title">Pending requests</h1>
        <div v-else-if="pending_list === null" class="text-center">
            <v-progress-circular
                indeterminate
                color="primary"
            ></v-progress-circular>
        </div>
        <h1 v-else class="title">There are currently no pending requests</h1>
        <div class="listing" v-if="pending_list !== null && pending_list.length > 0">
            <v-text-field  v-model="to_search" label="Search" clearable>
                <label>name/scope</label>
            </v-text-field>
            <v-list :style="(mode === 'dark') ? 'background: #37474F;' : 'background: #ffffff;'" avatar>
                <template v-for="(pending, index) in to_show">
                    <v-list-item :key="index" :id="pending.id" link>
                        <v-list-item-avatar>
                            <v-img src="@/assets/icons/dna-light.png"></v-img>
                        </v-list-item-avatar>

                        <v-list-item-content>
                            <v-list-item-title>{{ pending.resourceName }}</v-list-item-title>
                            <v-list-item-title>by <strong>{{ pending.requesterName }}</strong></v-list-item-title>
                        </v-list-item-content>

                        <v-list-item-content>
                            <v-list-item-subtitle>Scope:</v-list-item-subtitle>
                            <strong>{{ pending.scopeName }}</strong>
                        </v-list-item-content>

                        <v-list-item-action class="actions">
                            <v-btn class="ma-2 action-btn" small color="primary" v-on:click="accept(index)">
                            Accept
                            </v-btn>
                            <v-btn class="ma-2 action-btn white--text" small color="red lighten-1" v-on:click="deny(index)">
                            Deny
                            </v-btn>
                        </v-list-item-action>
                    </v-list-item>
                </template>
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
            color: "#2d2d2d",
            to_search: ""
        }
    },
    methods: {
        get_pending_requests () {
            let url = process.env.VUE_APP_MIDDLEWARE_URL + 'authz/pending_requests'

            axios.get(url)
            .then((response) => {
                this.pending_list = response.data
            })
            .catch((e) => {
                this.pending_list = []
                alert("An error occurred while trying to acquire pending requests.")
                console.log(e)
            })
        },
        accept(index) {
            let url = process.env.VUE_APP_MIDDLEWARE_URL +  'authz/give_access/' + this.pending_list[index].id

            let data = 'resource_id=' + this.pending_list[index].resource +
                        '&requester_id=' + this.pending_list[index].requester +
                        '&scope_name=' + this.pending_list[index].scopeName

            axios.post(url, data)
            .then(() => {
                this.get_pending_requests()
            })
            .catch((e) => {
                alert('Error accepting request')
                console.log(e)
            })
        },
        deny(index) {
            let url = process.env.VUE_APP_MIDDLEWARE_URL +  'authz/deny/' + this.pending_list[index].id

            axios.delete(url)
            .then(() => {
                this.get_pending_requests()
            })
            .catch((e) => {
                alert('Error denying request')
                console.log(e)
            })
        }
    },
    mounted () {
        this.get_pending_requests()
    },
    computed: {
        mode: function() {
            return this.$store.state.mode
        },
        to_show: function() {
            if (this.pending_list === null || this.pending_list.length === 0) {
                return []
            }
            return this.pending_list.filter(res => {
                return res.resourceName.toLowerCase().includes(this.to_search.toLowerCase()) ||
                  res.ownerName.toLowerCase().includes(this.to_search.toLowerCase()) ||
                  res.scopeName.toLowerCase().includes(this.to_search.toLowerCase())
            })
        }
    }
}
</script>

<style scoped>
    .pending {
        padding: 5%;
    }

    .actions {
        align-items: normal;
        flex-direction: row;
    }

    .action-btn {
        margin: 2px !important;
    }
</style>