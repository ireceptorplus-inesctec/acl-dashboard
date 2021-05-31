<template>
    <v-card
     height="100%"
     class="overflow-hidden low"
     style="position: relative;"
    >
        <v-navigation-drawer
         width="100%"
         permanent
         :color="(mode === 'dark') ? color.dark : color.light"
        >
            <v-list-item>
                <v-list-item-avatar>
                    <v-icon x-large>{{ user_photo }}</v-icon>
                </v-list-item-avatar>

                <v-list-item-content class="user-data">
                    <v-list-item-title>{{ user_name }}</v-list-item-title>
                    <v-list-item-subtitle v-if="user_mail">{{ user_mail }}</v-list-item-subtitle>
                </v-list-item-content>

                <v-list-item
                 class="logout"
                 v-on:click="logout()">
                    <v-list-item-icon>
                        <v-icon>logout</v-icon>
                    </v-list-item-icon>
                </v-list-item>
            </v-list-item>

            <v-divider/>

            <v-list-item
             v-for="item in items"
             :key="item.title"
             :to="{ name: item.linkto }"
             :class="item.selected"
             link
            >
                <v-list-item-icon>
                    <v-icon>{{ item.icon }}</v-icon>
                </v-list-item-icon>

                <v-list-item-content>
                    <v-list-item-title>{{ item.title }}</v-list-item-title>
                </v-list-item-content>

            </v-list-item>
            <v-select
             v-model="selected"
             :items="servers"
             :dark="mode === 'dark'"
             label="Choose server"
             class="selectable">
            </v-select>
            <v-switch
             v-model="modeswitch"
             flat
             :label="`Dark Mode (${mode === 'dark' ? 'ON' : 'OFF'})`"
             class="themetoggle"
            ></v-switch>
        </v-navigation-drawer>
        <!-- <v-navigation-drawer
         width="100%"
         height="10%"
         :color="color"
         dark
        > -->
            <!-- <v-select
             v-model="selected"
             :items="servers"
             dark
             label="Choose server"
             class="to_front">
            </v-select> -->
            <!-- <v-menu open-on-hover right offset-y class="to_right">
                <template v-slot:activator="{ on, attrs }">
                    <v-btn
                     color="primary"
                     dark
                     v-bind="attrs"
                     v-on="on"
                    >
                        {{ selected_server }}
                    </v-btn>
                </template> -->
                <!-- <v-list>
                    <v-list-item
                     v-for="(server, index) in servers"
                     :key="index"
                     @click="change()">
                        <v-list-item-title>{{ server.title }}</v-list-item-title> -->
                        <!-- <v-btn
                         color="primary"
                         dark
                         v-for="(server, index) in servers"
                         :key="index"
                         @click="change(index)"
                        >
                            {{ server }}
                        </v-btn>
                        <h3 class="curr">Current server: {{ this.selected }}</h3> -->
                    <!-- </v-list-item>
                </v-list> -->
        <!-- </v-navigation-drawer> -->

    </v-card>
</template>

<script>
import keycloak from '../plugins/keycloak'

const axios = require('axios')

export default {
    name: 'Sidebar',
    data () {
        return {
            user_photo: "person",
            user_name: null,
            user_mail: null,
            items: [
                { title: 'Resource requests', icon: 'create_new_folder', linkto: 'requests', selected: '' },
                { title: 'My resources', icon: 'folder', linkto: 'resources', selected: '' },
                { title: 'Shared with me', icon: 'folder_shared', linkto: 'shared', selected: '' },
                { title: 'Manage studies', icon: 'build', linkto: 'manage', selected: '' },
            ],
            color: {
                dark: '#546E7A',
                // light: '#78909C'
                light: '#ffffff'
            },
            selected: null,
            servers: ['adc-middleware'],
            modeswitch: false
        }
    },
    methods: {
        change(index) {
            localStorage.setItem('server', this.servers[index])
            this.selected = this.servers[index]
            return
        },
        // highlight_selected () {
        //     switch (window.location.pathname) {
        //         case '/requests':
        //             this.items[0].selected = 'selected'
        //             this.selected = 0
        //             break;

        //         case '/resources':
        //             this.items[1].selected = 'selected'
        //             this.selected = 1
        //             break;

        //         case '/shared':
        //             this.items[2].selected = 'selected'
        //             this.selected = 2
        //             break;

        //         default:
        //             this.items[0].selected = ''
        //             this.items[1].selected = ''
        //             this.items[2].selected = ''
        //             this.selected = null
        //             break;
        //     }
        // },
        get_user_info () {
            let url = process.env.VUE_APP_KEYCLOAK_URL +
                    'realms/' +
                    process.env.VUE_APP_KEYCLOAK_REALM +
                    '/protocol/openid-connect/userinfo'
            let config = {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('access-token')
                }
            }

            axios.get(url, config)
            .then((response) => {
                if (response.data['name']) {
                    this.user_name = response.data['name']
                } else {
                    this.user_name = response.data['preferred_username']
                }

                if (response.data['email']) {
                    this.user_mail = response.data['email']
                }
            })
            .catch(() => {
                this.user_name = "Could not retreive user info"
            })
        },
        logout() {
            localStorage.removeItem('access-token')
            localStorage.removeItem('refresh-token')
            keycloak.logout()
        }
    },
    mounted () {
        this.get_user_info()
        this.selected = localStorage.getItem('server')
    },
    watch: {
        selected: function(val) {
            localStorage.setItem('server', val)
        },
        modeswitch: function(val) {
            if (val === true) {
                this.$store.state.mode = 'dark';
            } else {
                this.$store.state.mode = 'light';
            }
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
.user-data {
    padding-left: 30px;
}

.v-list-item {
    padding-top: 10px;
    padding-bottom: 10px;
}

.v-list-item__icon {
    padding-left: 20px;
    padding-right: 20px;
}

.selected {
    background: #2d2d2d;
}

.logout {
    position: absolute;
    right: 0;
}

.selectable {
    width: 50%;
    position: absolute;
    left: 25%;
}

.themetoggle {
    width: 50%;
    position: absolute;
    left: 25%;
    bottom: 0%;
    padding-bottom: 20px;
}
</style>