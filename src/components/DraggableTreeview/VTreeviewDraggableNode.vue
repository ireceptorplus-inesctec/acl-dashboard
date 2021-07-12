<template>
    <div :class="['v-treeview-node v-treeview-node--click', {'v-treeview-node--leaf' : !hasChildren}]">
        <div class="v-treeview-node__root" @click="open = !open">
            <div v-for="levelNr in levelsToAdd" :key="levelNr" class="v-treeview-node__level"></div>
            <button v-if="hasChildren" type="button"  class="v-icon notranslate v-treeview-node__toggle v-icon--link mdi mdi-menu-down arrow-open"
                :class="{
                      'v-treeview-node__toggle--open': open,
                      'theme--dark': mode === 'dark',
                      'theme--light': mode === 'light'
                    }"
            />
            <div class="v-treeview-node__content">
                <div v-if="hasSlotPrepend" class="v-treeview-node__prepend">
                    <slot name="prepend" v-bind="{ item: value, open }" />
                </div>
                <div class="v-treeview-node__label">
                    <slot name="label" v-bind="{ item: value, open }">
                        {{ value.name }}
                    </slot>
                </div>
                <div v-if="hasSlotAppend" class="v-treeview-node__append">
                    <slot name="append" v-bind="{ item: value, open }" />
                </div>
            </div>
        </div>
        <div v-if="hasChildren && open" class="v-treeview-node__children v-treeview-node__children__draggable">
            <draggable
                :group="group"
                :value="value.children"
                ghost-class="ghost"
                @change="changed"
            >
                <v-treeview-draggable-node
                    v-for="child in value.children"
                    :key="child.id"
                    :group="group"
                    :level="level+1"
                    :value="child"
                    :root_node="root_node"
                    :changed="changed"
                >
                    <template v-if="hasSlotPrepend" v-slot:prepend="{ item, open }">
                        <slot name="prepend" v-bind="{ item, open }" />
                    </template>
                    <template v-slot:label="{ item, open }">
                        <slot name="label" v-bind="{ item, open }" />
                    </template>
                    <template v-if="hasSlotAppend" v-slot:append="{ item, open }">
                        <slot name="append" v-bind="{ item, open }" />
                    </template>
                </v-treeview-draggable-node>
            </draggable>
        </div>
    </div>
</template>

<script>
    import draggable from "vuedraggable";
    export default {
        name: "VTreeviewDraggableNode",
        components: {
            draggable
        },
        props: {
            value: {
                type: Object,
                default: function () {
                    return {
                        id: 0,
                        name: "",
                        children: []
                    }
                }
            },
            root: {
                type: Boolean,
                default: function () {
                  return false;
                }
            },
            level: {
              type: Number,
              default: function () {
                return 0;
              }
            },
            group: {
                type: String,
                default: null
            },
            root_node: {
                type: Array,
                default: function () {
                    return []
                }
            },
            changed: {
              type: Function,
              default: function () {
                return () => {}
              }
            },
        },
        data() {
            return {
                open: false,
                localValue: { ...this.value }
            };
        },
        computed: {
            hasChildren: function () {
                return this.value.children != null && this.value.children.length > 0;
            },
            hasSlotPrepend () {
              return !!this.$scopedSlots['prepend'] || !!this.$slots['prepend'];
            },
            hasSlotAppend () {
              return !!this.$slots['append'] || !!this.$scopedSlots['append'];
            },
            isDark: function () {
                return this.mode === 'dark';
            },
            levelsToAdd: function () {
              return this.level + (this.hasChildren ? 0 : 1);
            },
            mode: function() {
                return this.$store.state.mode
            }
        },
        watch: {
            value: function (value) {
              this.localValue = { ...value };
            }
        },
        mounted() {
            if (this.value.is_open) {
                this.open = true
            }
        }
    };
</script>

<style scoped>
    .arrow-open {
        -webkit-transform: rotate(-90deg);
        -moz-transform: rotate(-90deg);
        -ms-transform: rotate(-90deg);
        -o-transform: rotate(-90deg);
        transform: rotate(-90deg);
        display: inline-block;
    }
    .v-treeview-node__toggle--open {
        -webkit-transform: rotate(0deg);
        -moz-transform: rotate(0deg);
        -ms-transform: rotate(0deg);
        -o-transform: rotate(0deg);
        transform: rotate(0deg);
        display: inline-block;
    }
</style>
