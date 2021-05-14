<template>
  <div class="study">
    <h1 class="title">Study manager</h1>
    <div class="listing">
      <v-row>
        <v-col
          cols="12"
          sm="6"
          md="9"
        >
          <study-picker v-on:select_study="show_study"></study-picker>
        </v-col>
        <v-col
          cols="6"
          md="3"
        >
          <template-picker :is_study="is_study" v-on:select_template="show_template" :get_mappings_from_tree="get_mappings_from_tree"></template-picker>
        </v-col>
      </v-row>
      <h2 class="subtitle">Mappings</h2>
      <div v-if="current_study">
        <study-mappings :current_study="current_study" v-on:change_tree="change_tree" v-on:update_mappings="update_mappings"></study-mappings>
      </div>
    </div>
  </div>
</template>

<script>
import StudyPicker from "../components/StudyManagement/StudyPicker"
import TemplatePicker from "../components/StudyManagement/TemplatePicker"
import StudyMappings from "../components/StudyManagement/StudyMappings"
const axios = require('axios')

  export default {
    name: 'StudyManagement',
    components: {
      StudyPicker,
      TemplatePicker,
      StudyMappings,
    },
    data () {
      return {
        is_study: null,
        current_study: null,
        tree_list: [],
        color: "#3A3A3A",
        mappings: null,
      }
    },
    methods: {
      /**
       * Requests and retreives all field mappings from a study, placing the response in current_study
       * @param study_id Requesting study id
       */
      show_study (study_id) {
        this.is_study = study_id
        let url = process.env.VUE_APP_MAPPINGS_BASE_PATH + 'study/' + study_id
        let config = {
            headers: {
                'Authorization': 'Bearer ' + localStorage.getItem('access-token')
            }
        }
        axios.get(url, config)
        .then((response) => {
          this.current_study = response.data
        })
        .catch(() => {
          this.current_study = []
        })
      },
      /**
       * Requests and retreives all field mappings from a template, replacing the current study with them.
       * @param template_id Requesting template id
       */
      show_template(template_id) {
        let url = process.env.VUE_APP_MAPPINGS_BASE_PATH + 'templates/' + template_id
        let config = {
            headers: {
                'Authorization': 'Bearer ' + localStorage.getItem('access-token')
            }
        }
        axios.get(url, config)
        .then((response) => {
          this.current_study.mappings = response.data.mappings
        })
        .catch(() => {
          this.selected_template = null
        })
      },
      /**
       * Writes shown mapping id's to an object
       * @param scope_obj Object representing a scope to write to
       * @param tree Tree representing screen's single column
       */
      add_children_ids(scope_obj, tree) {
        for (let i = 0; i < tree.length; i++) {
          if (Object.prototype.hasOwnProperty.call(tree[i], 'field_name')) {
            scope_obj.fields.push(tree[i].id);
          } else {
            if (tree[i].children.length > 0) {
              scope_obj = this.add_children_ids(scope_obj, tree[i].children)
            }
          }
        }
        return scope_obj
      },
      /**
       * Reads gloal list of trees (tree_list) and returns an id-only array of object
       * @returns Middleware compatible array of objects representing mappings per scope
       */
      get_mappings_from_tree() {
        let mappings_obj = []
        for (let i = 0; i < this.tree_list.length; i++) {
          let scope_obj = {
            scope: this.tree_list[i].scope_id,
            fields: []
          }
          scope_obj = this.add_children_ids(scope_obj, this.tree_list[i].tree)
          mappings_obj.push(Object.assign({}, scope_obj))
        }
        return mappings_obj
      },
      /**
       * Changes global tree list to new one
       * @param tree Tree to update with
       */
      change_tree(tree) {
        this.tree_list = tree
      },
      update_mappings() {
        var mapp = this.get_mappings_from_tree()
        this.current_study.mappings = mapp
        let url = process.env.VUE_APP_MAPPINGS_BASE_PATH + 'study/' + this.current_study.id
        let config = {
            headers: {
                'Authorization': 'Bearer ' + localStorage.getItem('access-token')
            }
        }
        axios.put(url, this.current_study, config)
        .then((response) => {
          console.log(response)
        })
        .catch((e) => {
          console.log(e)
        })
      }
    },
  }
</script>

<style scoped>
  .study {
    height: 100%;
    width: 90%;
    position: absolute;
    top: 0;
    left: 0;
    padding: 5%;
    overflow-x: hidden;
  }

  .title {
    text-align: center;
    font-size: 300%;
  }

  .subtitle {
    margin-top: 1%;
    font-size: 150%;
  }

  .scope {
    margin-top: 2%;
    font-size: 100%;
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

  .v-list-item__title {
    text-align: center;
  }

  .v-list-item__subtitle {
    color: #CBCBCB;
    text-align: center;
  }
</style>
