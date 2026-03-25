<template>
    <div class="pet-page">
        <h1>Pet View</h1>
        <PetCard/>
        <NavBar/>
        <PetActionWidget/>
    </div>
</template>

<script setup lang="ts">
    import PetCard from '../components/pet/PetCard.vue';
    import NavBar from '../components/navigation/NavBar.vue';
    import PetActionWidget from '../components/pet/PetActionWidget.vue';

</script>