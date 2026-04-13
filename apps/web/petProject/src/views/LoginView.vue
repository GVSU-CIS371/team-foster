<template>
    <div class="login-page">
    <form @submit.prevent="loginHandler">
        <h1>Pet Management Game</h1>
        <p class="username">Username: <input v-model="username" placeholder="Username"> </p>
        <p class="password">Password: <input v-model="password" type="password" placeholder="Password"></p>
        <div class="login-button">
            <v-btn type="submit">Login</v-btn>
        </div>
    </form>    </div>
</template>

<script setup lang="ts">
import{ref} from 'vue';
import { useNavigation } from '../utilities/navigation.ts';
import {loginUser} from '../utilities/authService.ts'
import { useGameStore } from '../stores/gameStore.ts';

const gameStore = useGameStore()
const {login} = useNavigation()
const password = ref("")
const username = ref("")

const loginHandler = async () =>{

    if(!username.value.includes("@")) {
        const user = await loginUser(username.value + "@test.com", password.value)
        console.log(user)
        
        if(user){
            await gameStore.initialize(user.uid, username.value + "@test.com")
            login()
        }
    }
}
</script>


<style scoped>
.login-page {
    height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.username, .password{
    padding: 1em;
}
</style>
 