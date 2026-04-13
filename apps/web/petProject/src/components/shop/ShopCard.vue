<script setup lang="ts">
//import BaseCard from '../shared/BaseCard.vue';
import BaseButton from '../shared/BaseButton.vue';
import type { ShopItem } from '../../types/shop.ts';
import { useGameStore } from '../../stores/gameStore.ts';

const gameStore = useGameStore()

const {data} = defineProps<{
    data: ShopItem
}>()

const item = gameStore.items[data.itemID]!


function buyItem() {
    gameStore.buyItem(data)
}

</script>

<template>
    <div class="shop-card">
        <div class="item-image">{{ item.image }}</div>
        <div class="item-name">{{ item.name }}</div>
        <div class="item-price">{{ data.price }} coins</div>

        <BaseButton :text="'Buy'" @click="buyItem"/>
    </div>
</template>

<style scoped>
.shop-card{
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