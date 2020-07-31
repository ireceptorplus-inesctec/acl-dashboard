<template>
    <v-card
     height="100%"
     class="overflow-hidden"
     style="position: relative;"
    >
        <v-navigation-drawer
         width="100%"
         absolute
         permanent
         :color="color"
         dark
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
             v-for="(item, index) in items"
             :key="item.title"
             link
             v-on:click="goto(index)"
             :class="item.selected"
            >
                <v-list-item-icon>
                    <v-icon>{{ item.icon }}</v-icon>
                </v-list-item-icon>

                <v-list-item-content>
                    <v-list-item-title>{{ item.title }}</v-list-item-title>
                </v-list-item-content>
                
            </v-list-item>
        </v-navigation-drawer>

    </v-card>
</template>

<script>
import router from '@/router'
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
                { title: 'Resource requests', icon: 'create_new_folder', linkto: '/requests', selected: '' },
                { title: 'My resources', icon: 'folder', linkto: '/resources', selected: '' },
                { title: 'Shared with me', icon: 'folder_shared', linkto: '/shared', selected: '' },
            ],
            color: "#1d1d1d",
            selected: null
        }
    },
    methods: {
        goto (index) {
            this.items[this.selected].selected = ''
            this.selected = index
            this.items[this.selected].selected = 'selected'
            router.push(this.items[this.selected].linkto)
        },
        highlight_selected () {
            switch (window.location.pathname) {
                case '/requests':
                    this.items[0].selected = 'selected'
                    this.selected = 0
                    break;
            
                case '/resources':
                    this.items[1].selected = 'selected'
                    this.selected = 1
                    break;
            
                case '/shared':
                    this.items[2].selected = 'selected'
                    this.selected = 2
                    break;
            
                default:
                    this.items[0].selected = ''
                    this.items[1].selected = ''
                    this.items[2].selected = ''
                    this.selected = null
                    break;
            }
        },
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
                // this.get_user_info()
            })
        },
        logout() {
            // TODO - ver se fica assim
            localStorage.removeItem('access-token')
            localStorage.removeItem('refresh-token')
            keycloak.logout()
            // this.$emit('user-is-logged')
        }
    },
    mounted () {
        this.highlight_selected(),
        this.get_user_info()
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
</style>