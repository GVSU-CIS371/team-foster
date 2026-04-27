<template>
    <div class="pet-type-cards" @click="handleClick">
        <v-window :key="petType.id">
            <v-window-item  class="pet-type-card">

                    <v-card-title class="pet-name">{{ petType.name }}</v-card-title>
                    <div class="middle">
                    <div class="prev-arrow"><</div>
                    <v-card-text class="pet-type-image">{{ petType.image }}</v-card-text>
                    <div class="next-arrow">></div>
                    </div>
                     <v-card-text class ="decay-stats">
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

.pet-type-head {
    display: inline flex;
    gap: 10rem;
}

.prev-arrow, .next-arrow {
    font-size: clamp(5em, 5vw, 10em);
}

.middle{
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    gap: 2rem;
}

.pet-type-cards {
    width: 100%;
    max-width: 50rem;

    display: flex;
    flex-direction: column;

    justify-content: center;
    align-items: center;

    padding: 1rem;
    box-sizing: border-box;

    border: 3px solid white;
    border-radius: 30px;
}

.pet-name {
    font-size: 250%;
} 

.pet-type-image{
    font-size: clamp(15rem, 10vw, 30rem);
}
.decay-stats{
    font-size: 1rem;
}

.pet-stats{
    display: inline-flex;
    align-items: space-around;
    gap: 1rem;
    width: 75%;

}


.carousel-controls{
    position: absolute;
    inset: 0;
    display: flex;
}

.prev{
    width: 50%;
    height: 100%;
    background: transparent;
}

.next{
    width: 50%;
    height: 100%;
    background: transparent;
}

</style>
