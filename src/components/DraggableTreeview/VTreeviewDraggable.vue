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
                default: function () {
                    return []
                }
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
            return this.mode === 'dark' ? "theme--dark" : "theme-light";
          },

          hasSlotPrepend () {
            return !!this.$scopedSlots['prepend'] || !!this.$slots['prepend'];
          },

          hasSlotAppend () {
            return !!this.$scopedSlots['append'] || !!this.$slots['append'] ;
          },
          mode: function() {
            return this.$store.state.mode
          }
        },
        watch: {
            value(value) {
                this.localValue = [...value];
            }
        },
        methods: {
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

<style lang="sass">
  @import 'vuetify/src/components/VTreeview/VTreeview.sass'
</style>
