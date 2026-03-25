<template>
    <BaseButton :text="'Feed'" @click="feedPet"/>
    <BaseButton :text="'Play'" @click="playWithPet"/>
    <BaseButton :text="'Clean'" @click="cleanPet"/>
</template>

<script setup lang="ts">
import BaseButton from '../shared/BaseButton.vue';
import { useGameStore } from '../../stores/gameStore';

const gameStore = useGameStore()

function feedPet() {
    console.log("Feeding pet...")
    let food = gameStore.playerStore.player?.inventory.items.find(invItem => invItem.item.type === "Food") ?? null
    if(food) {
        gameStore.useItem(food)
    } else {
        console.log("No food available!") 
    }
}

function playWithPet() {
    console.log("Playing with pet...")
    let toy = gameStore.playerStore.player?.inventory.items.find(invItem => invItem.item.type === "Toy") ?? null
    if(toy) {
        gameStore.useItem(toy)
    } else {
        console.log("No toy available!")   
    }
}   

function cleanPet() {
    console.log("Cleaning pet...")
    let cleaner = gameStore.playerStore.player?.inventory.items.find(invItem => invItem.item.type === "Hygiene") ?? null
    if(cleaner) {
        gameStore.useItem(cleaner)
    } else {
        console.log("No hygiene item available!")
    }
}

</script>