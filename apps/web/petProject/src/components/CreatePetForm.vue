<template>
    <h1>Create Pet</h1>
    <p>Name: <input v-model="petName" placeholder="Pet Name"></p>
    <p>Type: 
        <select v-model="petType">
            <option v-for="(type, id) in gameStore.petTypes" :key="id" :value="id">{{ type.name }}</option>
        </select>
    </p>
    <button @click="createPet">Create</button>
</template>

<script setup lang="ts">
import {ref} from 'vue'
import { useGameStore } from '../stores/gameStore.ts';


const petName = ref("")

const gameStore = useGameStore()

const petType = ref<string>(Object.keys(gameStore.petTypes)[0] ?? "")

const emit = defineEmits<{
    (e: 'pet-created'): void
}>()

const createPet = () => {
    console.log(gameStore.playerStore.player)

    if(petName.value && petType.value){
        const newPetType = gameStore.petTypes[petType.value] ?? null
        gameStore.newPet(petName.value, newPetType)
        emit('pet-created')
    }
}


</script>