<template>
    <div v-if="is_study">
        <v-row>
            <v-col
             cols="12"
             sm="6"
             md="10">
                <v-select
                 v-model="template"
                 :items="templates_names"
                 :dark="(mode === 'dark')"
                 label="Template"
                 class="selectable"
                >
                </v-select>
            </v-col>
            <v-col
             cols="6"
             md="1">
                <v-btn
                 class="mx-2 delIcon"
                 fab
                 :dark="(mode === 'dark')"
                 small
                 v-on:click="save_template">
                    <v-icon
                     :dark="(mode === 'dark')"
                    >
                        mdi-floppy
                    </v-icon>
                </v-btn>
            </v-col>
            <v-col
             cols="6"
             md="1">
                <v-btn
                 class="mx-2 delIcon"
                 fab
                 :dark="(mode === 'dark')"
                 small
                 v-on:click="delete_template">
                    <v-icon
                     :dark="(mode === 'dark')"
                    >
                        mdi-delete
                    </v-icon>
                </v-btn>
            </v-col>
        </v-row>
        <new-template-dialog :open="new_template_open" v-on:close="new_template_close" v-on:input="new_template_close"></new-template-dialog>
    </div>
</template>

<script>
import NewTemplateDialog from "./NewTemplateDialog"
const axios = require('axios')
    export default {
        name: 'TemplatePicker',
        components: {
            NewTemplateDialog
        },
        data() {
            return {
                template: null,
                templates: null,
                templates_names: null,
                new_template_open: false
            }
        },
        props: {
            is_study: {
                type: String,
                default: function() { return null }
            },
            get_mappings_from_tree: {
                type: Function,
                default: function() {}
            }
        },
        watch: {
            template: function(val) {
                if (val) {
                    let index = this.templates_names.indexOf(val)
                    if (this.templates[index]) {
                        this.$emit('select_template', this.templates[index].id)
                    }
                }
            },
            is_study: function() {
                this.template = null
            }
        },
        methods: {
            /**
             * Requests and retreives all templates, placing the response in templates
             */
            get_templates () {
                this.template = null
                let url = process.env.VUE_APP_MAPPINGS_BASE_PATH + 'templates'
                axios.get(url)
                .then((response) => {
                    this.templates = response.data
                    this.get_templates_names(response.data)
                })
                .catch(() => {
                    this.templates = []
                    this.templates_names = []
                })
            },
            /**
             * Creates array with templates names, placing the response in templates_names
             * Adds option to save current settings as new template
             * @param templates Array of templates to get names from
             */
            get_templates_names (templates) {
                var names = []
                for (let i = 0; i < templates.length; i++) {
                    names.push(templates[i].name)
                }
                this.templates_names = names
            },
            new_template_close(name) {
                if (name != null) {
                    this.create_template(name, this.get_mappings_from_tree())
                }
                this.new_template_open = false
                this.get_templates()
            },
            save_template() {
                this.new_template_open = true
            },
            create_template(name, mappings) {
                let post_template = {
                    name: name,
                    mappings: mappings
                }
                let url = process.env.VUE_APP_MAPPINGS_BASE_PATH + 'templates'
                axios.post(url, post_template)
                .then((response) => {
                    console.log(response)
                    this.get_templates()
                })
                .catch((e) => {
                    console.log(e)
                })
            },
            delete_template() {
                if (!confirm("Do you really want to delete?"))
                    return
                var filtered = this.templates.filter(e => e.name == this.template)
                if (filtered.length < 0) {
                    console.log('template not found')
                    return
                }
                let url = process.env.VUE_APP_MAPPINGS_BASE_PATH + 'templates/' + filtered[0].id
                axios.delete(url)
                .then((response) => {
                    console.log(response)
                    this.get_templates()
                })
                .catch((e) => {
                    console.log(e)
                })
            }
        },
        mounted() {
            this.get_templates()
        },
        computed: {
            mode: function() {
                return this.$store.state.mode
            }
        }
    }
</script>