<template>
    <div class="login-page">
        <LoginForm @login-success="login()"/>
    </div>
</template>

<script setup lang="ts">
import LoginForm from '../components/LoginForm.vue'
import { useNavigation } from '../composables/navigation.ts';

const {login} = useNavigation()
</script>
