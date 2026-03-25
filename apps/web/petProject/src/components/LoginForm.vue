<template>
    <form @submit.prevent="login">
        <h1>Pet Managememt Game</h1>
        <p>Username: <input v-model="username" placeholder="Username"> </p>
        <p>Password: <input v-model="password" type="password" placeholder="Password"></p>
        <div class="login-button">
            <button>Login</button>
        </div>
    </form>
</template>

<script setup lang="ts">
import {ref} from 'vue'
import { useNavigation } from '../composables/navigation'
const username = ref("")
const password = ref("")

const {login} = useNavigation()

</script>
