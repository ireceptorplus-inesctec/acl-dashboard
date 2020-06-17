import VueRouter from 'vue-router'

import ResourceRequests from './views/ResourceRequests'
import MyResources from './views/MyResources'
import SharedWithMe from './views/SharedWithMe'

const router = new VueRouter({
    mode: 'history',
    base: __dirname,
    routes: [
        { path: '/requests', component: ResourceRequests },
        { path: '/resources', component: MyResources },
        { path: '/shared', component: SharedWithMe },
        { path: '*', redirect: '/requests' },
    ]
})

export default router