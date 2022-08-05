<template>
    <div v-if="selected !== null" class="details_list">
        <h1 v-if="details && details.length > 0" class="title">Shared with</h1>
        <div v-else-if="details === null" class="text-center">
            <v-progress-circular
                indeterminate
                color="primary"
            ></v-progress-circular>
        </div>
        <h1 v-else class="title">Not being shared</h1>
        <div v-if="details !== null" class="listing">
            <v-list
             :style="(mode === 'dark') ? 'background: #37474F;' : 'background: #ffffff;'"
             three-line
             avatar>
                <v-list-item v-for="(detail, index) in details" :key="index" :dark="(mode === 'dark')">
                    <v-list-item-avatar>
                        <v-icon large>{{ user_photo }}</v-icon>
                    </v-list-item-avatar>

                    <v-list-item-content class="permission-item">
                        <v-list-item-subtitle>Username:</v-list-item-subtitle>
                        <v-list-item-title>{{ detail.user }}</v-list-item-title>
                        <v-list-item-subtitle v-if="detail.email">Email:</v-list-item-subtitle>
                        <v-list-item-title>{{ detail.email }}</v-list-item-title>
                        <v-list-item-subtitle>Scopes:</v-list-item-subtitle>
                        <p v-for="(scope, i) in detail.scopes" :key="i">
                            {{ scope }}
                        </p>
                    </v-list-item-content>

                    <v-list-item-avatar v-on:click="revoke(index)">
                        <v-icon large class="delico">delete</v-icon>
                    </v-list-item-avatar>
                </v-list-item>
            </v-list>
        </div>
    </div>
</template>

<script>
const axios = require('axios')

export default {
    name: "ResourceDetails",
    props: {
        resources: Array,
        selected: Number,
        details: Array
    },
    data () {
        return {
            user_photo: 'person',
            color: "#fafafa"
        }
    },
    methods: {
        revoke(index) {
            if (!confirm("Are you sure you want to revoke access permissions for this user?")) {
                return;
            }

            var owner_id = this.resources[this.selected].owner.id

            var requester = this.details[index].user

            var resource_id = this.resources[this.selected]._id

            let url = process.env.VUE_APP_MIDDLEWARE_URL + 'authz/revoke'

            let data = 'owner_id=' + owner_id +
                        '&requester=' + requester +
                        '&resource_id=' + resource_id

            axios.post(url, data)
            .then(() => {
                this.$emit('refresh')
            })
            .catch((e) => {
                alert('Error revoking access')
                console.error(e)
            })
        }
    },
    computed: {
        mode: function() {
            return this.$store.state.mode
        }
    }
}
</script>

<style scoped>
    .details_list {
        padding-top: 5%;
    }

    .title {
        text-align: center;
        font-size: 300%;
    }

    .name {
        margin-left: 15%;
    }

    .delico {
        color: #800000;
    }

    .permission-item {
        overflow: auto;
    }
</style>