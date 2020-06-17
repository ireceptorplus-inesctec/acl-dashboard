<template>
    <div>
        <v-card
         class="mx-auto login-card">
            <h1 class="title">Login</h1>
            <v-form
             class="fields">
                <v-text-field
                 v-model="username"
                 label="Username"
                 filled
                 shaped
                 dark
                ></v-text-field>
                <v-text-field
                 v-model="password"
                 :append-icon="show_password ? 'visibility' : 'visibility_off'"
                 :type="show_password ? 'text' : 'password'"
                 label="Password"
                 filled
                 shaped
                 dark
                 @click:append="show_password = !show_password"
                ></v-text-field>
                <div>
                    <a v-if="error" class="error">Invalid credentials</a>
                    <v-btn class="mx-2 button"
                     fab
                     dark
                     large
                     @click="login()"
                    >
                        <v-icon
                        dark
                        >
                            arrow_forward_ios
                        </v-icon>
                    </v-btn>
                </div>
            </v-form>
        </v-card>
    </div>
</template>

<script>
const axios = require('axios')

export default {
    name: "Login",
    data () {
        return {
            show_password: false,
            username: null,
            password: null,
            error: false
        }
    },
    methods: {
        login() {
            // TODO - remove immunedb
            let url = process.env.VUE_APP_BACKEND_URL + 'login/turnkey'
            let config = {
                headers: {
                    'content-type': 'application/x-www-form-urlencoded'
                }
            }
            let data = 'username=' + this.username +
                        '&password=' + this.password

            axios.post(url, data, config)
            .then((response) => {
                this.error = false
                localStorage.setItem('access-token', response.data.access_token)
                localStorage.setItem('refresh-token', response.data.refresh_token)
                this.$emit('user-is-logged', true)
            })
            .catch(() => {
                this.error = true
                this.$emit('user-is-logged', false)
            })

        }
    }
}
</script>

<style scoped>
.login-card {
    background: #1d1d1d;
    height: 350px;
    width: 600px;
    top: 50%;
    left: 50%;
    margin-top: -175px;
    margin-left: -300px;
    color: #ffffff;
}

.title {
    text-align: center;
    padding-top: 5%;
}

.fields {
    padding: 5%;
}

.button {
    position: absolute;
    right: 10%;
}

.error {
    color: red;
    padding-left: 5%;
}
</style>