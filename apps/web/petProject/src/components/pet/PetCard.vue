<template>
    <div class="pet-card">
        <v-window>
        <v-window-item class="pet-details">
            <v-card-title class="pet-name">{{ pet.name }}</v-card-title>
            <v-card-text class="pet-type-name">{{ petType.name }}</v-card-text>
            <div class="pet-stats">
            <PetStat>
                <template #stat-name>Hunger 🍗: </template>
                <template #stat-value>{{ pet.stats.hunger.toFixed(0) }}</template>
            </PetStat>
            <PetStat>
                <template #stat-name>Happiness 🙂: </template>
                <template #stat-value>{{ pet.stats.happiness.toFixed(0) }}</template>
            </PetStat>
            <PetStat>
                <template #stat-name>Hygiene 🛁: </template>
                <template #stat-value>{{ pet.stats.hygiene.toFixed(0) }}</template>
            </PetStat>
            </div>
            <v-card-text class="pet-image">{{  petType.image }}</v-card-text>

        </v-window-item> 
        </v-window>   
    </div>
</template>

<script setup lang="ts">
    import PetStat from './PetStat.vue'
    import type { Pet } from '../../types/pet';
    import type { PetType } from '../../types/pet';

    const props = defineProps<{
        pet: Pet,
        petType: PetType
    }>()
</script>

<style scoped>
.pet-card {
    background-color: transparent;
    height: 100%;
    width: 100%;
    max-width: 50em;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 3px solid white;
    border-radius: 30px;

}

.pet-name {
    font-size: clamp(1rem, 10vw, 2rem);
} 

.pet-type-name {
    font-size: clamp(1rem, 10vw, 2rem);
}

.pet-stats {
    display: inline-flex;
    align-items: space-around;
    justify-content: space-around;
    width:75%
}

.pet-image {
    font-size: clamp(8rem, 20vw, 20rem);
    line-height: 1;
}

</style>
