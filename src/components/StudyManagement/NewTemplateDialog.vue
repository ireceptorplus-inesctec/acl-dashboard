<template>
    <v-dialog v-if="open" v-model="open" max-width="600px" v-on:input="close_card">
      <v-card>
        <v-card-title>
          <span class="headline">Choose a name for the new template</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-text-field v-model="template_name" label="Template name" required></v-text-field>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer>
            <v-btn color="blue darken-1" text @click="save_template">Save</v-btn>
          </v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>
</template>

<script>
    export default {
        name: 'NewTemplateDialog',
        data() {
            return {
                template_name: null
            }
        },
        props: {
            open: Boolean,
            default: function() { return false }
        },
        methods: {
            save_template() {
                this.$emit('close', this.template_name)
            },
            close_card() {
                this.$emit('close', null)
            }
        }
    }
</script>