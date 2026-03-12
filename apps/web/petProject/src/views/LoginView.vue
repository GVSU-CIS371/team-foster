<template>
    <div class="login-page">
        <LoginForm @login-success="goToPet"/>
    </div>
</template>

<script setup lang="ts">
import LoginForm from '../components/LoginForm.vue'
import {useRouter} from 'vue-router'

const router = useRouter()

function goToPet(){
    router.push('/pet')
}   
</script>
