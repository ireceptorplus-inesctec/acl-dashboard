<template>
    <div class="resources_list">
        <h1 v-if="resources !== null && resources.length > 0" class="title">
            My resources
        </h1>
        <h1 v-else class="title">No resources owned</h1>
        <div class="listing" v-if="resources !== null && resources.length > 0">
            <v-text-field v-model="to_search" label="Search" clearable>
                <label>name/scope</label>
            </v-text-field>
            <v-list
                :style="
                    mode === 'dark'
                        ? 'background: #37474F;'
                        : 'background: #ffffff;'
                "
                avatar
            >
                <v-list-item-group
                    v-for="(resource, index) in to_show"
                    :key="index"
                    :style="
                        mode === 'dark'
                            ? 'background: #37474F;'
                            : 'background: #ffffff;'
                    "
                >
                    <v-list-item
                        :id="resource._id"
                        link
                        v-on:click="open_resource(index)"
                        :dark="mode === 'dark'"
                    >
                        <v-list-item-avatar>
                            <v-img
                                v-if="mode === 'dark'"
                                src="@/assets/icons/dna.png"
                            ></v-img>
                            <v-img
                                v-else
                                src="@/assets/icons/dna-light.png"
                            ></v-img>
                        </v-list-item-avatar>

                        <v-list-item-content>
                            <v-list-item-title>{{resource.name}}</v-list-item-title>
                        </v-list-item-content>

                        <v-list-item-content class="avatar">
                            <v-btn color="default" small v-if="selected == index">Close</v-btn>
                            <v-icon v-else>arrow_forward_ios</v-icon>
                        </v-list-item-content>
                    </v-list-item>
                    <div v-if="selected == index">
                        <h2 class="resource-label">Name</h2>
                        <div class="resource-title">
                            {{ resources[selected].name }}
                        </div>

                        <h2 class="resource-label">Share Resource</h2>
                        <v-select
                            v-model="selected_scopes"
                            :items="scopes"
                            chips
                            label="Scopes"
                            multiple
                        ></v-select>

                        <v-text-field
                            v-model="to_share_with"
                            label="Username/e-mail"
                            :dark="mode === 'dark'"
                        />

                        <v-btn
                            color="primary"
                            class="mx-2 button btn-submit white--text"
                            @click="share_with(index)"
                        >
                            <v-icon :dark="mode === 'dark'">add</v-icon> Share
                        </v-btn>
                        <v-btn
                            color="blue-grey"
                            class="mx-2 button btn-submit white--text"
                            @click="change_owner(index)"
                        >
                            <v-icon :dark="mode === 'dark'">swap_horiz</v-icon>
                            Change owner
                        </v-btn>
                    </div>
                </v-list-item-group>
            </v-list>
        </div>
    </div>
</template>

<script>
const axios = require("axios");

export default {
    name: "ResourcesList",
    props: {
        resources: Array,
        selected: Number,
    },
    data() {
        return {
            resource_icon: "folder",
            color: "#37474F",
            to_share_with: null,
            selected_scopes: null,
            to_search: "",
        };
    },
    methods: {
        open_resource(index) {
            if (index == this.selected) {
                if (this.mode === "dark") {
                    document.getElementById(
                        this.resources[this.selected]._id
                    ).style.background = "#37474F";
                } else {
                    document.getElementById(
                        this.resources[this.selected]._id
                    ).style.background = "#fafafa";
                }
                this.$emit("select-resource", null);
            } else {
                if (this.selected != null) {
                    if (this.mode === "dark") {
                        document.getElementById(
                            this.resources[this.selected]._id
                        ).style.background = "#37474F";
                    } else {
                        document.getElementById(
                            this.resources[this.selected]._id
                        ).style.background = "#fafafa";
                    }
                }
                this.$emit("select-resource", index);
                if (this.mode === "dark") {
                    document.getElementById(
                        this.resources[index]._id
                    ).style.background = "#37474F";
                } else {
                    document.getElementById(
                        this.resources[index]._id
                    ).style.background = "#fafafa";
                }
            }
        },
        getCookie(name) {
            var nameEQ = name + "=";
            var ca = document.cookie.split(";");
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == " ") c = c.substring(1, c.length);
                if (c.indexOf(nameEQ) == 0)
                    return c.substring(nameEQ.length, c.length);
            }
            return null;
        },
        share_with(index) {
            if (
                !this.to_share_with ||
                !this.selected_scopes ||
                this.selected_scopes.length == 0
            ) {
                alert("Invalid user/scope");
                return;
            }

            let url =
                process.env.VUE_APP_MIDDLEWARE_URL +
                process.env.VUE_APP_AUTHZ_BASE_PATH +
                "give_access/null";

            this.selected_scopes.forEach((scope) => {
                let data =
                    "resource_id=" +
                    this.resources[index]._id +
                    "&requester_id=" +
                    this.to_share_with +
                    "&scope_name=" +
                    scope;

                axios
                    .post(url, data)
                    .then(() => {
                        this.$emit("refresh");
                    })
                    .catch(() => {
                        alert(
                            "Error giving access for " +
                                scope +
                                " scope, maybe you have a pending request for that permission?"
                        );
                    });
            });
        },
        change_owner(index) {
            if (!confirm("You are about to change the ownership of this resource to another user. You will no longer be able to access it directly.\nAre you sure you want to proceed?"))  {
                return;
            }

            if (!this.to_share_with) {
                alert("Invalid user");
                return;
            }

            let url =
                process.env.VUE_APP_MIDDLEWARE_URL +
                process.env.VUE_APP_AUTHZ_BASE_PATH +
                "change_owner/" +
                this.resources[index]._id +
                "/" +
                this.to_share_with;

            axios
                .post(url, "")
                .then(() => {
                    this.$emit("refreshall");
                })
                .catch(() => {
                    alert("Error changing owner, maybe user doesn't exist?");
                });
        },
    },
    computed: {
        scopes: function() {
            try {
                let names = [];
                this.resources[this.selected].scopes.forEach((scope) => {
                    names.push(scope.name);
                });
                return names;
            } catch (e) {
                return null;
            }
        },
        mode: function() {
            return this.$store.state.mode;
        },
        to_show: function() {
            if (this.resources === null || this.resources.length === 0) {
                return [];
            }
            return this.resources.filter((res) => {
                for (let i = 0; i < res.scopes.length; i++) {
                    if (
                        res.scopes[i].name
                            .toLowerCase()
                            .includes(this.to_search.toLowerCase())
                    ) {
                        return true;
                    }
                }
                return res.name
                    .toLowerCase()
                    .includes(this.to_search.toLowerCase());
            });
        },
    },
};
</script>

<style scoped>
.v-list-item-content {
    flex: 0;
}

.resource-label {
    margin-top: 20px;
    margin-bottom: 20px;
}

.resource-title {
    text-align: left;
    font-size: 100%;
}

.avatar {
    padding-right: 10px;
    flex: unset;
}

.btn-submit {
    margin-bottom: 10px;
}
</style>
