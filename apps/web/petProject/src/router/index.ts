import {createRouter, createWebHistory} from 'vue-router'
import LoginView from '../views/LoginView.vue'
import InventoryView from '../views/InventoryView.vue'
import PetView from '../views/PetView.vue'


const routes = [
    { path: '/', redirect: '/login' },
    { path: '/login', component: LoginView },
    { path: '/inventory', component: InventoryView },
    { path: '/pet', component: PetView }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router