<template>
    <div class="create-pet-page">
        <CreatePetForm @pet-created="goToPet()"/>
        <NavigationButton to="logout" text="Logout" />
    </div>  
</template>

<script setup lang="ts">
import CreatePetForm from '../components/CreatePetForm.vue'
import NavigationButton from '../components/navigation/NavigationButton.vue';
import { useNavigation } from '../composables/navigation.ts';

const { goToPet } = useNavigation()
</script>