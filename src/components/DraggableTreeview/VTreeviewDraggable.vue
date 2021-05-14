<template>
    <draggable
        :value="localValue"
        :group="group"
        class="v-treeview v-treeview-draggable"
        :class="themeClassName"
        ghost-class="ghost"
        @change="changed"
    >
        <v-treeview-draggable-node
            v-for="item in value"
            :key="item.id"
            :group="group"
            :value="item"
            :root_node="localValue"
            :changed="changed"
        >
            <template v-if="hasSlotPrepend" v-slot:prepend="{ item, open }">
                <slot name="prepend" v-bind="{ item, open }"></slot>
            </template>
            <template v-slot:label="{ item, open }">
                <slot name="label" v-bind="{ item, open }"></slot>
            </template>
            <template v-if="hasSlotAppend" v-slot:append="{ item, open }">
                <slot name="append" v-bind="{ item, open }"></slot>
            </template>
        </v-treeview-draggable-node>
    </draggable>
</template>

<script>
    // import Vue, { PropType } from "vue";
    import draggable from "vuedraggable";
    import VTreeviewDraggableNode from "./VTreeviewDraggableNode.vue";
    export default {
        components: {
            draggable,
            VTreeviewDraggableNode
        },
        props: {
            value: {
                type: Array,
                // type: Array as PropType<{ id: string | number }[]>,
                default: function () {
                    return []
                }
                // default: (): { id: string | number }[] => {
                //    return [];
                // }
            },
            group: {
                type: String,
                default: null
            },
            scope: {
              type: String,
              default: null
            },
            add_leaf: {
              type: Function,
              default: function() {}
            },
            remove_leaf: {
              type: Function,
              default: function() {}
            },
            classes: {
              type: Array,
              default: function() { return [] }
            },
        },
        data() {
            return {
                localValue: [...this.value],
            };
        },
        computed: {
          themeClassName: function () {
            return this.$vuetify.theme.isDark ? "theme--dark" : "theme--light";
          },

          hasSlotPrepend () {
            return !!this.$scopedSlots['prepend'] || !!this.$slots['prepend'];
          },

          hasSlotAppend () {
            //let result = !!this.$slots['append'] || !!this.$scopedSlots['append'];
//            console.log('append-root', !!this.$scopedSlots['append']);
            return !!this.$scopedSlots['append'] || !!this.$slots['append'] ;
          },
        },
        watch: {
            value(value) {
//                console.log('WatchValue/DraggableTreeView: this.localValue', this.localValue, 'value', value);
                this.localValue = [...value];
            }
        },
        methods: {
            // updateValue: function (value) {
            //     this.localValue = value;
            //     this.$emit("input", this.localValue);
            //     console.log('updateValue: ')
            //     console.log(value)
            // },
            // updateItem: function (itemValue) {
            //     const index = this.localValue.findIndex(v => v.id === itemValue.id);
            //     this.$set(this.localValue, index, itemValue);
            //     this.$emit("input", this.localValue);
            //     console.log('updateItem - itemValue: ')
            //     console.log(itemValue)
            //     console.log('updateItem - localValue: ')
            //     console.log(this.localValue)
            // },
            changed: function(changed) {
              if (changed.added) {
                if (this.check_has_parent(changed.added.element)) {
                  this.add_leaf(this.localValue, this.scope, changed.added.element)
                } else {
                  this.localValue.push(changed.added.element)
                  this.$emit("input", this.localValue)
                }
              } else if (changed.removed) {
                if (this.classes.some(e => e.name == changed.removed.element.name)) {
                  var cloned_children = Object.assign([], changed.removed.element.children);
                  cloned_children.forEach((ch) => {
                    this.remove_leaf(this.localValue, this.scope, ch)
                  })
                }
                if (this.check_has_parent(changed.removed.element)) {
                  this.remove_leaf(this.localValue, this.scope, changed.removed.element)
                } else {
                  let index = this.localValue.findIndex(v => v.id == changed.removed.element.id)
                  this.localValue.splice(index, 1)
                  this.$emit("input", this.localValue)
                }
              }
            },
            check_has_parent: function(element) {
              return (Object.prototype.hasOwnProperty.call(element, 'field_name') && element.field_name.split('.').length > 1)
                || element.id.split('.').length > 1
            },
        }
    }
</script>
