<template>
    <div class="create-pet-page">
   
        <div class="pet-page">
        <h1>Create Pet</h1>
        <CreatePetForm @pet-created="goToPet()"/>
        <NavigationButton to="logout" text="Logout" />
        </div>  

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
    width: 100%;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: auto 0;

}


.pet-page{
    margin: auto 0;
}

</style>