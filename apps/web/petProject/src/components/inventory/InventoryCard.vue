<template>
    <div class="inventory-card" v-if="item">
        <div class="item-image">{{ item.image }}</div>
        <div class="item-name">{{ item.name }}</div>
        <div class="item-effect">Effect Value: {{ item.effectValue }}</div>
        <div class="item-quantity">Quantity: {{ data.quantity }}</div>
    </div>
</template> s

<script setup lang="ts">
import {computed, toRefs, watch} from 'vue';
import type { InventoryItem } from '../../types/inventory.ts';
import { useGameStore } from '../../stores/gameStore.ts';

const props = defineProps<{
    data: InventoryItem
}>()

watch(()=> props.data.quantity, (newVal) => {
    console.log("InventoryCard prop changed: ", newVal)
})

const {data} = toRefs(props)

const gameStore = useGameStore()

const item = computed(() => gameStore.items[data.value.itemID])

function useItem() {
    gameStore.useItem(data.value.itemID)
}



</script>



<style scoped>
.inventory-card{
    display: flex;
    flex-direction: column;
    border: 3px solid white;
    border-radius: 25px;
    align-items: center;
    margin: 1em auto;
}

.item-image{
    font-size:500%;
}

.item-name{
    font-size: 3em;
}
</style>