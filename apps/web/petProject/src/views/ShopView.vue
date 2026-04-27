<script setup lang="ts">
import NavBar from '../components/navigation/NavBar.vue';
import PetWidget from '../components/pet/PetStatWidget.vue';
import ShopCard from '../components/shop/ShopCard.vue';
import { useGameStore } from '../stores/gameStore.ts';

const gameStore = useGameStore()
const shopItems = gameStore.shopStore.shopItems ?? []

</script>

<template>
    <div class="shop-page">
        <h1>Shop View</h1>
        <NavBar/>
        <PetWidget/>

        <ShopCard
            v-for="sItem in shopItems"
            :key="sItem.itemID"
            :data="sItem"
        />
    </div>
</template>