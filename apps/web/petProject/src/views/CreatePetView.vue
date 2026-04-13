<template>
    <div class="create-pet-page">
        <CreatePetForm @pet-created="goToPet()"/>
        <NavigationButton to="logout" text="Logout" />
    </div>
</template>

<script setup lang="ts">
import CreatePetForm from '../components/pet/CreatePetForm.vue'
import NavigationButton from '../components/navigation/NavigationButton.vue';
import { useNavigation } from '../utilities/navigation.ts';

const { goToPet } = useNavigation()
</script>

<style scoped>

.create-pet-page{
    background-color: pink;
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
}

</style>