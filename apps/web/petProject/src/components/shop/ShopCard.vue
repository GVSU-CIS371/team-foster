<script setup lang="ts">
import BaseCard from '../shared/BaseCard.vue';
import BaseButton from '../shared/BaseButton.vue';
import type { ShopItem } from '../../types/shop.ts';
import { useGameStore } from '../../stores/gameStore.ts';

const {name, data} = defineProps<{
    name: string,
    data: ShopItem
}>()

const gameStore = useGameStore()

function buyItem() {
    gameStore.buyItem(data)
}

</script>

<template>
    <div class = "shop-card">
        <BaseCard :name="name" :data="data">
            <BaseButton :text="'Buy'" @click="buyItem"/>
        </BaseCard>
    </div>
</template>