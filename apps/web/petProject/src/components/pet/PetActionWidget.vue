<template>
    <BaseButton :text="'Feed'" @click="feedPet"/>
    <BaseButton :text="'Play'" @click="playWithPet"/>
    <BaseButton :text="'Clean'" @click="cleanPet"/>
</template>

<script setup lang="ts">
import BaseButton from '../shared/BaseButton.vue';
import { useGameStore } from '../../stores/gameStore';
import { findItemByType } from '../../types/inventory';

const gameStore = useGameStore()
const inventory = gameStore.playerStore.player?.inventory
const items = gameStore.items

function feedPet() {
    console.log("Feeding pet...")
    console.log(inventory)
    if(inventory){
        let food = findItemByType(inventory, items, "Food")
        if(food) {

            gameStore.useItem(food.itemID)
        } else {
            console.log("No food available!") 
        }
    }   
}

function playWithPet() {
    console.log("Playing with pet...")
    if(inventory){
        let toy = findItemByType(inventory, items, "Toy")
        if(toy) {
            gameStore.useItem(toy.itemID)
        } else {
            console.log("No toy available!")   
        }
    }
}   

function cleanPet() {
    console.log("Cleaning pet...")
    if(inventory){
        let cleaner = findItemByType(inventory, items, "Hygiene")
        if(cleaner) {
            gameStore.useItem(cleaner.itemID)
        } else {
            console.log("No hygiene item available!")
        }
    }
}

</script>