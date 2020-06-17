<template>
    <div class="resources_list">
        <h1 class="title">My resources</h1>
        <div class="listing">
            <v-list
             dark
             rounded
             :color="color"
             three-line
             avatar>
                <v-list-item
                 v-for="(resource, index) in resources"
                 :key="index"
                 link
                 v-on:click="open_resource(index)"
                 :id="resource._id"
                 dark
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
                        <v-icon>arrow_forward_ios</v-icon>
                    </v-list-item-content>
                    
                </v-list-item>
            </v-list>
        </div>
    </div>
</template>

<script>
export default {
    name: "ResourcesList",
    props: {
        resources: Array,
        selected: Number
    },
    data () {
        return {
            resource_icon: 'folder',
            color: "#2d2d2d"
        }
    },
    methods: {
        open_resource(index) {
            if (index == this.selected) {
                document.getElementById(this.resources[this.selected]._id).style.background = '#2d2d2d'
                // CLOSE this.selected RESOURCE DETAILS
                this.$emit('select-resource', null)
            } else {
                if (this.selected != null) {
                    document.getElementById(this.resources[this.selected]._id).style.background = '#2d2d2d'
                    // CLOSE this.selected RESOURCE DETAILS
                }
                this.$emit('select-resource', index)
                document.getElementById(this.resources[index]._id).style.background = '#1d1d1d'
                // OPEN this.selected RESOURCE DETAILS
            }
        }
    }
}
</script>

<style scoped>
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
</style>