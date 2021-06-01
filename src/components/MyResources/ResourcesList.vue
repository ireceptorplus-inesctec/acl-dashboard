<template>
    <div class="resources_list">
        <h1 class="title">My resources</h1>
        <div class="listing">
            <v-list
             :dark="(mode === 'dark')"
             rounded
             :color="color"
             three-line
             avatar
             >
                <v-list-item-group
                 v-for="(resource, index) in resources"
                 :key="index"
                 :style="(mode === 'dark') ? 'background: #2d2d2d;' : 'background: #ffffff;'">
                    <v-list-item
                     :id="resource._id"
                     link
                     v-on:click="open_resource(index)"
                     :dark="(mode === 'dark')"
                        >
                        <v-list-item-avatar class="avatar">
                            <v-img src="@/assets/icons/dna.png"></v-img>
                        </v-list-item-avatar>

                        <v-list-item-content class="name">
                            <v-list-item-title>{{ resource.name }}</v-list-item-title>
                        </v-list-item-content>

                        <v-list-item-content>
                            <v-list-item-subtitle>Scopes:</v-list-item-subtitle>
                            <p
                            v-for="(scope, i) in resource.scopes"
                            :key="i"
                            >
                                {{ scope.name }}
                            </p>
                        </v-list-item-content>

                        <v-list-item-content class="arrow">
                            <v-icon v-if='selected == index'>close</v-icon>
                            <v-icon v-else>arrow_forward_ios</v-icon>
                        </v-list-item-content>
                    </v-list-item>
                    <div
                     v-if="selected == index">
                        <h2 class="share_title">Share resource</h2>
                        <v-select
                            v-model="selected_scopes"
                            :items="scopes"
                            chips
                            label="Scopes"
                            multiple
                        ></v-select>
                        <v-row>
                            <v-col cols="12" sm="10">
                                <v-text-field
                                v-model="to_share_with"
                                label="Username/E-Mail"
                                :dark="(mode === 'dark')"
                                />
                            </v-col>
                            <v-col cols="12" sm="2">
                            <v-btn class="mx-2 button"
                                fab
                                :dark="(mode === 'dark')"
                                @click="share_with(index)"
                                >
                                    <v-icon
                                     :dark="(mode === 'dark')"
                                     >
                                     add
                                    </v-icon>
                                </v-btn>
                            </v-col>
                        </v-row>
                    </div>
                </v-list-item-group>
            </v-list>
        </div>
    </div>
</template>

<script>
const axios = require('axios')

export default {
    name: "ResourcesList",
    props: {
        resources: Array,
        selected: Number
    },
    data () {
        return {
            resource_icon: 'folder',
            color: "#2d2d2d",
            to_share_with: null,
            selected_scopes: null
        }
    },
    methods: {
        open_resource(index) {
            if (index == this.selected) {
                document.getElementById(this.resources[this.selected]._id).style.background = '#2d2d2d'
                this.$emit('select-resource', null)
            } else {
                if (this.selected != null) {
                    document.getElementById(this.resources[this.selected]._id).style.background = '#2d2d2d'
                }
                this.$emit('select-resource', index)
                document.getElementById(this.resources[index]._id).style.background = '#1d1d1d'
            }
        },
        getCookie(name) {
            var nameEQ = name + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
            }
            return null;
        },
        // share_with(index) {
        //     if (!this.to_share_with || !this.selected_scopes || this.selected_scopes.length == 0) {
        //         alert("Invalid user/scope")
        //         return
        //     }
        //             // https://ireceptorplus.inesctec.pt/auth/realms/iReceptorPlus/account/resource/7c75e6e9-b105-428f-a77e-58a5047fbf0b/share
        //     let url = process.env.VUE_APP_KEYCLOAK_URL +
        //             'realms/' +
        //             process.env.VUE_APP_KEYCLOAK_REALM +
        //             '/account/resource/' +
        //             this.resources[index]._id +
        //             '/share'

        //     let config = {
        //         // headers: {
        //         //     'Authorization': 'Bearer ' + localStorage.getItem('access-token')
        //         // },
        //         // Cookie: "KEYCLOAK_IDENTITY=eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI5YjdkNTE1ZS1mZGM0LTQ3MmUtYTIxNy0xNmE5NWU5YzEyN2QifQ.eyJqdGkiOiJjNTcyNjQ1OC0yYTdmLTQ5ZmYtOTFkMi05MTk1YmI4YjA0NDIiLCJleHAiOjE1OTQ0MjY0NjYsIm5iZiI6MCwiaWF0IjoxNTk0MzkwNDY2LCJpc3MiOiJodHRwczovL2lyZWNlcHRvcnBsdXMuaW5lc2N0ZWMucHQvYXV0aC9yZWFsbXMvaVJlY2VwdG9yUGx1cyIsInN1YiI6IjVkYWU4MjhlLWZkMmEtNGI1Mi1hOGIwLTdlOTg5NGI1NDYxNyIsInR5cCI6IlNlcmlhbGl6ZWQtSUQiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiIyZWMzNDA4ZS1hNmU4LTQ2MDQtYjE0Ni0zYWQ5MGQ3ZjlmZjciLCJzdGF0ZV9jaGVja2VyIjoibTNHWXZmMkJwVWpSTjV4Q3RCMm9QY19tdF9KaWVjQ3Q2SGpLSG9sM1NBayJ9.c7Hwat2n_KqKwqX8iiCEvk84sbhm1ePCrPhwfnKORIU" +
        //         //         ";KEYCLOAK_SESSION=iReceptorPlus/5dae828e-fd2a-4b52-a8b0-7e9894b54617/2ec3408e-a6e8-4604-b146-3ad90d7f9ff7" +
        //         //         ";AUTH_SESSION_ID=2ec3408e-a6e8-4604-b146-3ad90d7f9ff7.keycloak",
        //         Cookie: "KEYCLOAK_IDENTITY=" + localStorage.getItem("KEYCLOAK_IDENTITY") +
        //                 ";KEYCLOAK_SESSION=" + localStorage.getItem("KEYCLOAK_SESSION") +
        //                 ";AUTH_SESSION_ID=" + localStorage.getItem("AUTH_SESSION_ID"),
        //         withCredentials: true
        //     }

        //     console.log(config)

        //     let scope_ids = []
        //     this.selected_scopes.forEach((scope) => {
        //         let i = 0
        //         while (scope != this.resources[index].scopes[i].name) {
        //             i++
        //         }

        //         scope_ids.push(this.resources[index].scopes[i].id)

        //     })
        //     let data = 'user_id=' + this.to_share_with

        //     scope_ids.forEach(id => {
        //         data += '&scope_id=' + id
        //     })

        //     axios.post(url, data, config)
        //     .then(() => {
        //         this.$emit('refresh')
        //     })
        //     .catch((e) => {
        //         console.log(e.response.data)
        //         alert('Error giving access for ' + ' scope, maybe you have a pending request for that permission?')
        //     })

            
        // },
        share_with(index) {
            if (!this.to_share_with || !this.selected_scopes || this.selected_scopes.length == 0) {
                alert("Invalid user/scope")
                return
            }

            let url = process.env.VUE_APP_BACKEND_URL +
                    'give_access/' + localStorage.getItem('server') + '/' +
                    null

            this.selected_scopes.forEach((scope) => {
                let data = 'resource_id=' + this.resources[index]._id +
                        '&requester=' + this.to_share_with +
                        '&scope_name=' + scope

                axios.post(url, data)
                .then(() => {
                    this.$emit('refresh')
                })
                .catch(() => {
                    alert('Error giving access for ' + scope + ' scope, maybe you have a pending request for that permission?')
                })
            })

            
        },
    },
    computed: {
        scopes: function() {
            try {
            let names = []
            this.resources[this.selected].scopes.forEach((scope) => {
                names.push(scope.name)
            })
            return names
            } catch (e) {
                return null
            }
        },
        mode: function() {
            return this.$store.state.mode
        }
    }
}
</script>

<style scoped>
    .v-list-item-content {
        flex: 0;
    }

    .resources_list {
        padding: 5%;
    }

    .title {
        text-align: center;
        font-size: 300%;
    }

    .arrow {
        margin: 0 !important;
        position: absolute;
        right: 5%;
        top: 50%;
        -ms-transform: translateY(-50%);
        transform: translateY(-50%);
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

    .share_title {
        margin-left: 5%;
    }
</style>