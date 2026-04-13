<template>
    <div class="pet-type-cards" @click="handleClick">
        <v-window :key="petType.id">
            <v-window-item  class="pet-type-card">
                <v-card>
                    <v-card-title class="text-center">{{ petType.name }}</v-card-title>
                    <v-card-text class="text-center">{{ petType.image }}</v-card-text>
                     <v-card-text class ="text-center">
                        <p>Decay Rates</p>
                        <div class="pet-stats">
                        <PetStat>
                            <template #stat-name>Hunger 🍗: </template>
                            <template #stat-value>{{ petType.decayRates.hunger.toFixed(0) }}</template>
                        </PetStat>
                        <PetStat>
                            <template #stat-name>Happiness 🙂: </template>
                            <template #stat-value>{{ petType.decayRates.happiness.toFixed(0) }}</template>
                        </PetStat>
                        <PetStat>
                            <template #stat-name>Hygiene 🛁: </template>
                            <template #stat-value>{{ petType.decayRates.hygiene.toFixed(0) }}</template>
                        </PetStat>
                        </div>
                    </v-card-text>
                </v-card>
            </v-window-item>
        </v-window>
    </div>
</template>

<script setup lang="ts">
import type { PetType } from '../../types/pet';
import PetStat from './PetStat.vue'

    const props = defineProps<{
        petType: PetType
    }>()


    const emit = defineEmits<{
        (e: 'prev-pet'): void
        (e: 'next-pet'): void
    }>()

    const handleClick = (e: MouseEvent) => {
        const el = e.currentTarget as HTMLElement
        const rect = el.getBoundingClientRect()
        const x = e.clientX - rect.left
        const width = rect.width

        if(x < width / 2) {
            emit('prev-pet')
        } else {
            emit('next-pet')
        }
        console.log("Card clicked!")
    }
</script>

<style scoped>

.pet-type-cards {
    background-color: blue;
    height: 100%;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;

}

.pet-stats{
    display: inline-flex;
    align-items: space-around;
     justify-content: space-around;
     width: 75%;
}

.carousel-item{
    background-color: orange;

}

.carousel-controls{
    position: absolute;
    inset: 0;
    display: flex;
}

.prev{
    background-color: red;
    width: 50%;
    height: 100%;
    background: transparent;
}

.next{
    background-color: orange;
    width: 50%;
    height: 100%;
    background: transparent;
}


.v-card{
    background-color: purple;
    height: 100%;
}

.v-carousel-item{
    background-color: red;

}



</style>
