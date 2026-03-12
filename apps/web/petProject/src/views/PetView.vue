<template>
    <div class="pet-page">
        <h1>Pet View</h1>
        <PetCard/>
        <button @click="goToInventory">Inventory</button>
    </div>
</template>

<script setup lang="ts">
    import PetCard from '../components/PetCard.vue';
    import {useRouter} from 'vue-router'
    import { usePetStore } from '../stores/petStore';

    const router = useRouter()
    const petStore = usePetStore()

    function goToInventory(){
        router.push('/inventory')
    }   
</script>