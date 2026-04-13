<template>
    <div class="inventory-card">
        <BaseCard :name="name" :data="data">
            <BaseButton :text="'Use'" @click="useItem"/>
        </BaseCard>
    </div>
</template>

<script setup lang="ts">
import BaseCard from '../shared/BaseCard.vue';
import BaseButton from '../shared/BaseButton.vue';
import type { InventoryItem } from '../../types/inventory.ts';
import { useGameStore } from '../../stores/gameStore.ts';

const {name, data} = defineProps<{
    name: string,
    data: InventoryItem
}>()

const gameStore = useGameStore()

function useItem() {
    gameStore.useItem(data.itemID)
}

</script>