<template>
    <v-select
        v-model="study"
        :items="studies_names"
        dark
        label="Study"
        class="selectable"
    >
    </v-select>
</template>

<script>
const axios = require('axios')
    export default {
        name: 'StudyPicker',
        data() {
            return {
                study: null,
                studies: null,
                studies_names: null,
            }
        },
        watch: {
            study: function(val) {
                this.$emit('select_study', this.studies[this.studies_names.indexOf(val)].name)
            },
        },
        methods: {
            /**
             * Requests and retreives all studies, placing the response in studies
             */
            get_studies () {
                let url = process.env.VUE_APP_MAPPINGS_BASE_PATH + 'study'
                axios.get(url)
                .then((response) => {
                    this.studies = response.data
                    this.get_studies_names(this.studies)
                })
                .catch(() => {
                    this.studies = []
                    this.studies_names = []
                })
            },
            /**
             * Creates array with studies names, placing the response in studies_names
             * @param studies Array of studies to get names from
             */
            get_studies_names (studies) {
                var names = []
                for (let i = 0; i < studies.length; i++) {
                    names.push(studies[i].name)
                }
                this.studies_names = names
            },
        },
        mounted() {
            this.get_studies()
        },
    }
</script>