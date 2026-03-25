import {createRouter, createWebHistory} from 'vue-router'
import LoginView from '../views/LoginView.vue'
import CreatePetView from '../views/CreatePetView.vue'
import InventoryView from '../views/InventoryView.vue'
import PetView from '../views/PetView.vue'
import ShopView from '../views/ShopView.vue'
import { useGameStore } from '../stores/gameStore'


const routes = [
    { path: '/', redirect: '/login' },
    { path: '/login', component: LoginView },
    { path: '/create', component: CreatePetView },
    { path: '/inventory', component: InventoryView },
    { path: '/pet', component: PetView },
    { path: '/shop', component: ShopView }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach((to) => {
    const gameStore = useGameStore()
    const hasPet = gameStore.playerStore.hasPet
    const loggedIn = gameStore.loggedIn
    let result

    if (!loggedIn && to.path !== '/login') {
        result = '/login'
    } else if (loggedIn && to.path === '/login') {
        result = '/pet'
    } else if (to.path === '/create' && hasPet) {
        result = '/pet'
    } else if (to.path === '/pet' && !hasPet) {
        result = '/create'
    } else {
        result = true
    }

    return result
})

export default router