<template>
    <div v-if="is_study">
        <v-select
            v-model="template"
            :items="templates_names"
            dark
            label="Template"
            class="selectable"
        >
        </v-select>
        <new-template-dialog :open="new_template_open" v-on:close="new_template_close"></new-template-dialog>
    </div>
</template>

<script>
import NewTemplateDialog from "./NewTemplateDialog"
const axios = require('axios')
const new_template = '+ save new template'
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
                type: Number,
                default: function() { return 0 }
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
                    } else {
                        this.new_template_open = true
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

                this.templates_names.push(new_template)
            },
            new_template_close(name) {
                this.create_template(name, this.get_mappings_from_tree())
                this.new_template_open = false
                this.get_templates()
            },
            create_template(name, mappings) {
                console.log('TODO - POST create template')
                console.log(name)
                console.log(mappings)
            }
        },
        mounted() {
            this.get_templates()
        },
    }
</script>