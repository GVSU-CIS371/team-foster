<template>
    <form @submit.prevent="login">
        <p>Pet Managememt Game</p>
        <p>Username: <input v-model="username" placeholder="Username"> </p>
        <p>Password: <input v-model="password" type="password" placeholder="Password"></p>
        <div class="login-button">
            <button>Login</button>
        </div>
    </form>
</template>

<script setup lang="ts">
import {ref} from 'vue'

const username = ref("")
const password = ref("")
const emit = defineEmits<{
    (e: 'login-success'): void
}>()
function login(){
    console.log(username.value, password.value)
    emit('login-success')
}

</script>

<style>

</style>
