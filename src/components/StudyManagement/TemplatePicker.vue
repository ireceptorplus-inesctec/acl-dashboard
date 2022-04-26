<template>
    <div v-if="is_study">
        <v-row class="template-buttons">
            <v-col cols="8">
                <v-select
                    v-model="template"
                    :items="templates_names"
                    :dark="mode === 'dark'"
                    label="Template"
                    class="selectable"
                >
                </v-select>
            </v-col>
            <v-col cols="4" align-self="center">
                <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn
                            class="white--text"
                            color="blue-grey darken-2"
                            :dark="mode === 'dark'"
                            small
                            v-on:click="save_template"
                            v-bind="attrs"
                            v-on="on"
                        >
                            <v-icon :dark="mode === 'dark'">
                                mdi-bookmark
                            </v-icon>
                        </v-btn>
                    </template>
                    Save as new template
                </v-tooltip>
                <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn
                            class="white--text"
                            color="red darken-2"
                            :dark="mode === 'dark'"
                            small
                            v-on:click="delete_template"
                            v-bind="attrs"
                            v-on="on"
                        >
                            <v-icon :dark="mode === 'dark'">
                                mdi-delete
                            </v-icon>
                        </v-btn>
                    </template>
                    Delete selected template
                </v-tooltip>
            </v-col>
        </v-row>
        <new-template-dialog
            v-model="new_template_open"
            v-on:close="new_template_close"
            v-on:input="new_template_close"
        ></new-template-dialog>
        <v-snackbar v-model="snackbar">
            {{ snackbar_text }}
            <template v-slot:action="{ attrs }">
                <v-btn text v-bind="attrs" @click="snackbar = false">
                Close
                </v-btn>
            </template>
        </v-snackbar>
    </div>
</template>

<script>
import NewTemplateDialog from "./NewTemplateDialog";
const axios = require("axios");
export default {
    name: "TemplatePicker",
    components: {
        NewTemplateDialog,
    },
    data() {
        return {
            template: null,
            templates: null,
            templates_names: null,
            new_template_open: false,
            snackbar: false,
            snackbar_text: ""
        };
    },
    props: {
        is_study: {
            type: String,
            default: function() {
                return null;
            },
        },
        get_mappings_from_tree: {
            type: Function,
            default: function() {},
        },
    },
    watch: {
        template: function(val) {
            if (val) {
                let index = this.templates_names.indexOf(val);
                if (this.templates[index]) {
                    this.$emit("select_template", this.templates[index].id);
                }
            }
        },
        is_study: function() {
            this.template = null;
        },
    },
    methods: {
        /**
         * Requests and retreives all templates, placing the response in templates
         */
        get_templates() {
            this.template = null;
            let url =
                process.env.VUE_APP_MIDDLEWARE_URL +
                process.env.VUE_APP_MAPPINGS_BASE_PATH +
                "templates";
            axios
                .get(url)
                .then((response) => {
                    this.templates = response.data;
                    this.get_templates_names(response.data);
                })
                .catch(() => {
                    this.templates = [];
                    this.templates_names = [];
                });
        },
        /**
         * Creates array with templates names, placing the response in templates_names
         * Adds option to save current settings as new template
         * @param templates Array of templates to get names from
         */
        get_templates_names(templates) {
            var names = [];
            for (let i = 0; i < templates.length; i++) {
                names.push(templates[i].name);
            }
            this.templates_names = names;
        },
        new_template_close(name) {
            if (name != null) {
                this.create_template(name, this.get_mappings_from_tree());
            }
            this.new_template_open = false;
            this.get_templates();
        },
        save_template() {
            this.new_template_open = true;
        },
        create_template(name, mappings) {
            let post_template = {
                name: name,
                mappings: mappings,
            };
            let url =
                process.env.VUE_APP_MIDDLEWARE_URL +
                process.env.VUE_APP_MAPPINGS_BASE_PATH +
                "templates";
            axios
                .post(url, post_template)
                .then(() => {
                    this.snackbar_text = `Template ${name} created successfully`;
                    this.snackbar = true;
                    this.get_templates();
                })
                .catch((e) => {
                    this.snackbar_text = `An error occured while creating the template.`;
                    this.snackbar = true;
                    console.error(e);
                });
        },
        delete_template() {
            if (!confirm("Are you sure you want to delete the selected template?")) return;
            var filtered = this.templates.filter(
                (e) => e.name == this.template
            );
            if (filtered.length < 0) {
                console.log("template not found");
                return;
            }
            let url =
                process.env.VUE_APP_MIDDLEWARE_URL +
                process.env.VUE_APP_MAPPINGS_BASE_PATH +
                "templates/" +
                filtered[0].id;
            axios
                .delete(url)
                .then(() => {
                    this.snackbar_text = `Template deleted successfully`;
                    this.snackbar = true;
                    this.get_templates();
                })
                .catch((e) => {
                    this.snackbar_text = `An error occured while deleting the template.`;
                    this.snackbar = true;
                    console.error(e);
                });
        },
    },
    mounted() {
        this.get_templates();
    },
    computed: {
        mode: function() {
            return this.$store.state.mode;
        },
    },
};
</script>

<style scoped>
.template-buttons {
    vertical-align: bottom;
}
</style>
