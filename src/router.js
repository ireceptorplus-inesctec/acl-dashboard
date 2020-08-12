import VueRouter from 'vue-router'

import ResourceRequests from './views/ResourceRequests'
import MyResources from './views/MyResources'
import SharedWithMe from './views/SharedWithMe'
import VueConfig from '../vue.config';

const router = new VueRouter({
    mode: 'history',
    base: VueConfig.publicPath,
    routes: [
        { path: '/requests', name: "requests", component: ResourceRequests },
        { path: '/resources', name:"resources", component: MyResources },
        { path: '/shared', name: "shared", component: SharedWithMe },
        { path: '*', redirect: 'requests' },
    ]
})

export default router