<template>
    <div class="pet-widget">
        <p>🙂: {{ pet.stats.happiness }}</p>
        <p>🍗: {{ pet.stats.hunger }}</p>
        <p>🛁: {{ pet.stats.hygiene }}</p>
        <p>💰: {{ gameStore.playerStore.player?.currency ?? 0 }}</p>
    </div>
</template> 

<script setup lang="ts">
import { useGameStore } from '../../stores/gameStore';
import { createPet } from '../../types/pet';

const gameStore = useGameStore()
const pet = gameStore.playerStore.player?.pet ?? createPet()

</script>