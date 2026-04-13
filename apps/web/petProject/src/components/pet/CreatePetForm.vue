<template>
    <div class="create-pet-form">
        <h1>Create Pet</h1>
        <div class="pet-type-card">
            <PetTypeCard :petType="currentPetType" @prev-pet="prevPet" @next-pet="nextPet"/>
        </div>
        <p>Name: <input v-model="petName" placeholder="Pet Name"></p>
        <div class="create-pet-button">
        <button @click="createPet">Create</button>
        </div>
    </div>
</template>

<script setup lang="ts">
import {ref, computed} from 'vue'
import { useGameStore } from '../../stores/gameStore.ts';
import PetTypeCard from './PetTypeCard.vue'

const petName = ref("")

const gameStore = useGameStore()

const petTypeID = ref<string>(Object.keys(gameStore.petStore.petTypes)[0] ?? "")

const currentPetType = computed(() => {
    return gameStore.petStore.petTypes[petTypeID.value]!
})

const emit = defineEmits<{
    (e: 'pet-created'): void
    (e: 'prev-pet'): void
    (e: 'next-pet'): void
}>()

const createPet = () => {
    console.log(gameStore.playerStore.player)

    if(petName.value && petTypeID.value){
        gameStore.newPet(petName.value, petTypeID.value)
        emit('pet-created')
    }
}

const prevPet = () => {
                console.log("Previous pet type")

    let petTypeKeys = Object.keys(gameStore.petStore.petTypes)
    let currentIndex = petTypeKeys.indexOf(petTypeID.value)
    if(currentIndex > 0){
        petTypeID.value = petTypeKeys[currentIndex - 1]!
    }
    else {
        petTypeID.value = petTypeKeys[petTypeKeys.length - 1]!
    }

    console.log(currentPetType.value.name)
}


const nextPet = () => {
                console.log("Next pet type")

    let petTypeKeys = Object.keys(gameStore.petStore.petTypes)
    let currentIndex = petTypeKeys.indexOf(petTypeID.value)
    if(currentIndex < petTypeKeys.length - 1){
        petTypeID.value = petTypeKeys[currentIndex + 1]!
    } else {
        petTypeID.value = petTypeKeys[0]!
    }

    console.log(currentPetType.value.name)
}

</script>

<style scoped>
 .create-pet-form {
    background-color: yellow;
    width: 50%;
    height: 100%;
    flex: 1;
    justify-items: center;
    align-items: center;
    display: flex;
    flex-direction: column;
}

.pet-type-card {
    background-color: green;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
}



.create-pet-button {
    margin: 2em;
}


.carousel-controls{
    position: absolute;
    justify-content: space-between;
    width: 100%;
}
</style>