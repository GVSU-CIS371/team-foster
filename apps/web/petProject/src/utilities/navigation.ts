import { useRouter } from 'vue-router'
import { computed } from 'vue'
import { useGameStore } from '../stores/gameStore'
//import { testPlayer } from '../types/mockData'

function useNavigation() {
    const router = useRouter()
    
    const gameStore = useGameStore()

    function goToPet(){
        router.push('/pet')
    }

    function goToLogin(){
        router.push('/login')
    }

    function goToCreate(){
        router.push('/create')
    }

    function goToInventory(){
        router.push('/inventory')
    }

    function goToShop(){
        router.push('/shop')
    }

    function goBack(){
        router.back()
    }

    function logout(){
        gameStore.loggedIn = false
        gameStore.stopPetTimer()
        goToLogin()
    }

    function login(){
        console.log("Logging in...")
        gameStore.loggedIn = true
        if (gameStore.playerStore.hasPet)  {
            gameStore.startPetTimer()
            goToPet()
        } else {
            goToCreate()
        }
    }

    const currentPage = computed(() => router.currentRoute.value.path)

    return {
        logout,
        login,
        goToPet,
        goToLogin,
        goToCreate,
        goToInventory,
        goToShop,
        goBack,
        currentPage
    }
}

export { useNavigation }