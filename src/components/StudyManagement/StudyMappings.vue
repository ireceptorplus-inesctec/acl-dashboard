<template>
    <div>
        <v-row>
            <v-col>
                <span class="title">Field Mappings</span>
            </v-col>
            <v-col class="text-right">
                <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn
                        color="primary"
                        class="mx-2 postIcon"
                        :dark="(mode === 'dark')"
                        v-bind="attrs"
                        v-on="on"
                        v-on:click="update_mappings">
                            <v-icon :dark="(mode === 'dark')">mdi-floppy</v-icon>
                            Save Mappings
                        </v-btn>
                    </template>
                    Save current mappings to selected study
                </v-tooltip>
            </v-col>
        </v-row>
        <v-container fluid>
            <v-layout v-if="current_study.mappings" align-start justify-center>
                <div v-for="(scope, index) in tree_list" :key="scope.scope" class="one_tree_column">
                    <v-list two-line :class="[class_types[index % 2], (mode === 'dark') ? 'dark' : 'light']">
                        <h3 class="scopeTitle" :class="(mode === 'dark') ? 'dark' : 'light'">
                        {{scope.scope}}
                        </h3>
                        <v-treeview-draggable v-model="scope.tree" group="mappings" :scope="scope.scope" :add_leaf="add_leaf" :remove_leaf="remove_leaf" :classes="classes"></v-treeview-draggable>
                    </v-list>
                </div>
            </v-layout>
        </v-container>
    </div>
</template>

<script>
import VTreeviewDraggable from "../DraggableTreeview/VTreeviewDraggable"
const axios = require('axios')
    export default {
        name: 'StudyMappings',
        components: {
            VTreeviewDraggable,
        },
        data() {
            return {
                tree_list: [],
                scopes: null,
                classes: null,
                fields: null,
                color: ["#3A3A3A", "#1F1F1F"],
                class_types: ["odd", "even"],
                choice: null
            }
        },
        props: {
            current_study: {
                type: Object,
                default: function() { return {} }
            },
            snackbar: {
                type: Boolean,
                default: function() { return false }
            },
            snackbar_text: {
                type: String,
                default: function() { return "" }
            },
        },
        methods: {
            /**
             * Requests and retreives all scopes, placing the response in scopes
             */
            get_scopes() {
                let url = process.env.VUE_APP_MIDDLEWARE_URL + 'resource/scopes'
                axios.get(url)
                .then((response) => {
                    this.scopes = response.data
                })
                .catch(() => {
                    this.scopes = []
                })
            },
            /**
             * Requests and retreives all classes, placing the response in classes
             */
            get_classes () {
                let url = process.env.VUE_APP_MIDDLEWARE_URL + 'resource/class'
                axios.get(url)
                .then((response) => {
                    this.classes = response.data
                })
                .catch(() => {
                    this.classes = []
                })
            },
            /**
             * Requests and retreives all fields, placing the response in fields
             */
            get_fields() {
                let url = process.env.VUE_APP_MIDDLEWARE_URL + 'resource/fields'
                axios.get(url)
                .then((response) => {
                    this.fields = response.data
                })
                .catch(() => {
                    this.fields = []
                })
            },
            /**
             * Fills list of trees (tree_list) with mappings from current study (current_study).
             * For each class adds attribute is_open to force open on page load
             * Uses add_leaf to actually insert each node in the tree
             * Final list of trees consists of 1 object per scope with corresponding mappings tree
             */
            new_fields_tree() {
                this.tree_list = []
                for (let i = 0; i < this.current_study.mappings.length; i++) {
                    let mapping = this.current_study.mappings[i]
                    let scope_name = this.get_scope_name(mapping.scope)

                    let tree_obj = {
                        scope_id: mapping.scope,
                        scope: scope_name,
                        tree: []
                    }

                    for (let j = 0; j < this.classes.length; j++) {
                        let class_name = this.classes[j].name.toLowerCase()
                        tree_obj.tree.push({
                            id: scope_name + '.' + class_name,
                            is_open: true,
                            name: class_name,
                            children: []
                        })
                    }

                    let fields_names = this.get_fields_names_with_classes(mapping.fields)

                    for (let j = 0; j < fields_names.length; j++) {
                        let small_name_split = fields_names[j].name.split('.')
                        let small_name = small_name_split[small_name_split.length - 1]
                        let field_obj = {
                            id: fields_names[j].id,
                            name: small_name,
                            field_name: fields_names[j].name
                        }
                        this.add_leaf(tree_obj.tree, scope_name, field_obj)
                    }

                    this.tree_list.push(tree_obj)
                }
            },
            /**
             * Searches scopes by id and returns scope name
             * @param id Requesting scope id
             * @return Scope name
             */
            get_scope_name (id) {
                for (let i = 0; i < this.scopes.length; i++) {
                    if (this.scopes[i].id == id) {
                        return this.scopes[i].name
                    }
                }
            },
            /**
             * Creates array with fields names concatenated with corresponding class and a dot
             * Example: if class = 'class_a' and field name = 'field_a' function returns 'class_a.field_a'
             * @param ids Array of ids to get names from
             * @return Array of names
             */
            get_fields_names_with_classes (ids) {
                var fields_names = []
                for (let i = 0; i < ids.length; i++) {
                    for (let j = 0; j < this.fields.length; j++) {
                        if (ids[i] == this.fields[j].id) {
                            fields_names.push({
                                    name: this.get_class_name(this.fields[j].class_id).toLowerCase() + '.' + this.fields[j].name,
                                    id: this.fields[j].id
                                })
                            break
                        }
                    }
                }
                return fields_names
            },
            /**
             * Searches classes by id and returns class name
             * @param id Requesting class id
             * @return Class name
             */
            get_class_name (id) {
                for (let i = 0; i < this.classes.length; i++) {
                    if (this.classes[i].id == id) {
                        return this.classes[i].name
                    }
                }
            },
            /**
             * Gets all element ids from given tree.
             * @param tree Tree to get ids from
             */
            get_ids_from_tree(tree) {
                return this.get_ids_from_tree_ids(tree, [])
            },
            /**
             * Recursive method to extract all ids from a given tree with all its children.
             * @param tree Tree to get ids from
             * @param ids Initially empty array to store exctracted ids
             */
            get_ids_from_tree_ids(tree, ids) {
                for (var i = 0; i < tree.length; i++) {
                    // if (Object.prototype.hasOwnProperty.call(tree[i], 'id') && Number.isInteger(tree[i].id)) {
                    if (Object.prototype.hasOwnProperty.call(tree[i], 'id')) {
                        ids.push(tree[i].id)
                    }
                    if (Object.prototype.hasOwnProperty.call(tree[i], 'children') && tree[i].children.length > 0) {
                        ids = this.get_ids_from_tree_ids(tree[i].children, ids)
                    }
                }
                return ids
            },
            /**
             * Adds new element to a tree (localValue).
             * If the element is a leaf its id is numerical
             * If the element is a parent its id is a concatenation of the corresponding scope and "parent" name
             * If the element is a leaf and parents do not exist, any and all non-existing parents are created
             * @param localValue Tree where element is being added to
             * @param scope Scope name corresponding to tree
             * @param element Element being added to the tree (localValue)
             */
            add_leaf: function(localValue, scope, element) {
                // checks if element is already on tree (localValue), returns otherwise
                let ids = this.get_ids_from_tree(localValue)
                if (ids.includes(element.id)) {
                    return
                }

                if (this.classes.some(e => e.name == element.name)) {
                    element.children.forEach((ch) => {
                        this.add_leaf(localValue, scope, ch)
                    })
                    return
                }
                let split
                let new_id
                if (Object.prototype.hasOwnProperty.call(element, 'field_name')) {
                    split = element.field_name.split('.')
                    new_id = null
                } else {
                    split = element.id.split('.')
                    split.splice(0, 1)
                    new_id = scope + '.' + split.join('.')
                }
                let current_name = scope + '.' + split[0]
                let current_block = localValue[localValue.findIndex(v => v.id == current_name)]

                for (let i = 1; i < split.length - 1; i++) {
                    current_name += '.' + split[i]
                    let index = current_block.children.findIndex(v => v.id == current_name)

                    if (index == -1) {
                        let new_parent = {
                            id: current_name,
                            name: split[i],
                            children: []
                        }
                        current_block.children.push(new_parent)
                        current_block.children.sort(function(a, b) {
                            return a.id.toString().localeCompare(b.id.toString())
                        })
                        current_block = new_parent
                    } else {
                        current_block = current_block.children[index]
                    }
                }
                if (new_id) {
                    let merge_index = current_block.children.findIndex(v => v.id == new_id)
                    if (merge_index > -1) {
                        for (let i = 0; i < element.children.length; i++) {
                        this.add_leaf(localValue, scope, element.children[i])
                        }
                    } else {
                        let new_element = Object.assign({}, element)
                        new_element.id = new_id
                        current_block.children.push(new_element)
                        current_block.children.sort(function(a, b) {
                            return a.id.toString().localeCompare(b.id.toString())
                        })
                    }
                    return
                }
                current_block.children.push(element)
                current_block.children.sort(function(a, b) {
                    return a.id.toString().localeCompare(b.id.toString())
                })
            },
            /**
             * Removes element from a tree (localValue).
             * When searching for the element, all its parents are stored
             * If the element is a leaf and parent does not have more children, any and all empty parents are removed
             * @param localValue Tree where element is being added to
             * @param scope Scope name corresponding to tree
             * @param element Element being added to the tree (localValue)
             */
            remove_leaf: function(localValue, scope, element) {
                element = Object.assign({}, element)

                // existing ids outside current tree (localValue)
                let ids = []
                // existing scopes outside current tree (localValue)
                let other_scopes = []
                // fills previous arrays
                for (var i = 0; i < this.tree_list.length; i++) {
                    if (this.tree_list[i].scope != scope) {
                        ids = ids.concat(this.get_ids_from_tree(this.tree_list[i].tree))
                        other_scopes.push(this.tree_list[i].scope)
                    }
                }

                let split
                let parents = []
                if (Object.prototype.hasOwnProperty.call(element, 'field_name')) {
                    split = element.field_name.split('.')
                } else {
                    split = element.id.split('.')
                    split.splice(0, 1)
                }

                let current_name = scope + '.' + split[0]
                let first_index = localValue.findIndex(v => v.id == current_name)
                let current_block = localValue[first_index]
                parents.push(localValue[first_index])

                for (let i = 1; i < split.length - 1; i++) {
                    current_name += '.' + split[i]
                    let index = current_block.children.findIndex(v => v.id == current_name)
                    parents.push(current_block.children[index])
                    current_block = current_block.children[index]
                }

                current_name += '.' + split[split.length - 1]
                if (current_block.children.length > 0) {
                    let leaf_index = current_block.children.findIndex(v => v.field_name == split.join('.') || v.id == current_name)
                    // if id (Numerical) is found in another tree it is removed from current tree
                    if (ids.includes(current_block.children[leaf_index].id)) {
                        current_block.children.splice(leaf_index, 1)
                    } else {
                        // if id is not numerical, change scope part of "id" and check against ids array, if exists can be removed
                        if (!Number.isInteger(current_block.children[leaf_index].id) && current_block.children[leaf_index].id.includes('.')) {
                            let with_scp = current_block.children[leaf_index].id.split('.')
                            other_scopes.forEach((scp) => {
                                with_scp[0] = scp
                                if (ids.includes(with_scp.join('.'))) {
                                    current_block.children.splice(leaf_index, 1)
                                }
                            })
                        }
                    }
                }

                this.remove_empty_parents(parents)
            },
            /**
             * Removes empty parents after last leaf removal
             * @param parents Array of parent objects to check for emptiness
             */
            remove_empty_parents(parents) {
                for (let i = parents.length - 1; i > 0; i--) {
                    if (parents[i].children.length == 0) {
                        let remove_index = parents[i - 1].children.findIndex(v => v == parents[i])
                        parents[i - 1].children.splice(remove_index, 1)
                    }
                }
            },
            /**
             * Emits an event for mappings update.
             */
            update_mappings() {
                this.$emit('update_mappings')
            }
        },
        watch: {
            'current_study.mappings': function() {
                this.new_fields_tree()
            },
            ready: function() {
                this.new_fields_tree()
            },
            tree_list: function() {
                this.$emit('change_tree', this.tree_list)
            }
        },
        mounted() {
            this.get_scopes()
            this.get_classes()
            this.get_fields()
        },
        computed: {
            ready: function() {
                return this.scopes && this.classes && this.fields
            },
            mode: function() {
                return this.$store.state.mode
            }
        }
    }
</script>

<style>
    .postIcon {
        margin-left: 20px;
    }

    .scopeTitle {
        color: #ffffff;
        text-align: center;
        padding-bottom: 20px;
        padding-top: 10px;
        text-transform: capitalize;
        border-bottom: 1px solid #6f6f6f;
    }

    .one_tree_column {
        width: 33%;
    }

    .odd.dark {
        background: #263238 !important;
    }
    .odd.dark .scopeTitle {
        background: #263238 !important;
    }
    .odd.light {
        background: #F9F9F9 !important;
    }
    .odd.light .scopeTitle {
        background: #F9F9F9 !important;
    }

    .even.dark {
        background: #455A64 !important;
    }
    .even.dark .scopeTitle {
        background: #455A64 !important;
    }
    .even.light {
        background: #F1F1F1 !important;
    }
    .even.light .scopeTitle {
        background: #F1F1F1 !important;
    }
</style>