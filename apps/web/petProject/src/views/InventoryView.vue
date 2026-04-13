<script setup lang="ts">
// import InventoryCard from '../components/inventory/InventoryCard.vue';
import NavBar from '../components/navigation/NavBar.vue';
import PetWidget from '../components/pet/PetStatWidget.vue';
//import { usePlayerStore } from '../stores/playerStore';

//const playerStore = usePlayerStore();
//const inventory = playerStore.player?.inventory?.items ?? {}
</script>

<template>
    <div class="inventory-page">
        <h1>Inventory View</h1>
        <NavBar/>
        <PetWidget/>
<!--         <InventoryCard
            v-for="item in inventory"
            :key="item.item.id"
            :name="item.item.name"
            :data="item"
        /> -->

    </div> 
</template>