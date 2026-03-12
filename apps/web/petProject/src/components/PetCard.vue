<template>
    <div class="pet-card">
        <h2>{{ type.name }}</h2>
        <img :src="type.image" alt="type.name" class="pet-image"/>
        <div class="pet-hunger">
            <PetStat>
                <template #stat-name>Hunger 🍗: </template>
                <template #stat-value>{{ pet.hunger.toFixed(0) }}</template>
            </PetStat>
        </div>
        <div class="pet-happiness">
            <PetStat>
                <template #stat-name>Happiness 🙂: </template>
                <template #stat-value>{{ pet.happiness.toFixed(0) }}</template>
            </PetStat>
        </div> 
        <div class="pet-hygiene">
            <PetStat>
                <template #stat-name>Hygiene 🛁: </template>
                <template #stat-value>{{ pet.hygiene.toFixed(0) }}</template>
            </PetStat>
        </div>
    </div>
</template>

<script setup lang="ts">
    import PetStat from './PetStat.vue'
    import { usePetStore } from '../stores/petStore';

    const petStore = usePetStore()

    const pet = petStore.pet
    const type = petStore.petTypes[pet.type]
    
</script>