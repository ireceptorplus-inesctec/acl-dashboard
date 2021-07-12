<template>
    <div class="pending">
        <h1 v-if="pending_list !== null && pending_list.length > 0" class="title">Pending requests</h1>
        <h1 v-else class="title">No requests to show</h1>
        <div class="listing" v-if="pending_list !== null && pending_list.length > 0">
            <v-text-field
                v-model="to_search"
                label="Search"
                clearable>
                    <label>name/scope</label>
            </v-text-field>
            <v-list
             :style="(mode === 'dark') ? 'background: #37474F;' : 'background: #ffffff;'"
             rounded
             three-line
             avatar>
                <v-list-item
                 v-for="(pending, index) in to_show"
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
            color: "#2d2d2d",
            to_search: ""
        }
    },
    methods: {
        get_pending_requests () {
            let url = process.env.VUE_APP_BACKEND_URL +
                    'pending_requests'

            axios.get(url)
            .then((response) => {
                this.pending_list = response.data
            })
            .catch(() => {
                this.pending_list = []
            })
        },
        accept(index) {
            let url = process.env.VUE_APP_BACKEND_URL +
                    'give_access/' +
                    this.pending_list[index].id

            let data = 'resource_id=' + this.pending_list[index].resource +
                        '&requester_id=' + this.pending_list[index].requester +
                        '&scope_name=' + this.pending_list[index].scopeName

            axios.post(url, data)
            .then(() => {
                this.get_pending_requests()
            })
            .catch(() => {
                alert('Error accepting request')
            })
        },
        deny(index) {
            let url = process.env.VUE_APP_BACKEND_URL +
                    'deny/' +
                    this.pending_list[index].id

            axios.delete(url)
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