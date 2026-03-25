<template>
    <div class="pet-card">
        <h1>{{ pet.name }}</h1>
        <h2>{{ pet.type.name }}</h2>
        <img :src="pet.type.image" alt="type.name" class="pet-image"/>
        <div class="pet-hunger">
            <PetStat>
                <template #stat-name>Hunger 🍗: </template>
                <template #stat-value>{{ pet.stats.hunger.toFixed(0) }}</template>
            </PetStat>
        </div>
        <div class="pet-happiness">
            <PetStat>
                <template #stat-name>Happiness 🙂: </template>
                <template #stat-value>{{ pet.stats.happiness.toFixed(0) }}</template>
            </PetStat>
        </div> 
        <div class="pet-hygiene">
            <PetStat>
                <template #stat-name>Hygiene 🛁: </template>
                <template #stat-value>{{ pet.stats.hygiene.toFixed(0) }}</template>
            </PetStat>
        </div>
    </div>
</template>

<script setup lang="ts">
    import PetStat from './PetStat.vue'
    import { useGameStore } from '../../stores/gameStore';

    const gameStore = useGameStore()

    const pet = gameStore.petStore.pet
</script>