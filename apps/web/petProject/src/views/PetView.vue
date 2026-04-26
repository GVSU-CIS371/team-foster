<template>
    <div class="pet-page">
        <div class="pet-section">
            <h1>Pet View</h1>
            <div class="pet-card">
            <PetCard v-if="pet && petType" :pet="pet" :petType = "petType" />
            </div>
            <div class="controls">
            <BaseButton :text="'Items'" @click="openInventory" />
            <PetActionWidget/>
            <BaseButton :text="'Shop'" @click="openShop" />
            </div> 
            <div class="logout-button">
                    <NavigationButton to="logout" text="Logout" />
            </div>
        </div>

        <v-dialog v-model="showInventory" transition="dialog-bottom-transition">
            <div class="sheet-container">
                <v-card class="sheet">
                <v-card-title>Inventory</v-card-title>
                    <v-card-text>
                        <div v-if="gameStore.playerStore.player?.inventory && Object.values(gameStore.playerStore.player?.inventory.items).length === 0">
                            Your inventory is empty.
                        </div>
                        <div v-else>
                            <div class="inv-items">
                                <v-row class="ga-4" align="stretch" justify="center">
                                    <v-col v-for="invItem in inventoryItems" :key="invItem.itemID" :data="invItem"
                                    cols="12" sm="6" lg="4" class="d-flex">
                                <InventoryCard :data="invItem" class="flex-grow-1"/>
                                </v-col>
                                </v-row>
                            </div>
                        </div>
                    </v-card-text>
                </v-card>
            </div>
        </v-dialog>
    
    <v-dialog v-model="showShop" transition="dialog-bottom-transition" width="50%">
      <div class="sheet-container">
        <v-card class="sheet" rounded="xl">
          <v-card-title class="title">Shop</v-card-title>
          <v-card-subtitle class="subtitle"> Wallet: {{ gameStore.playerStore.player?.currency }} coins</v-card-subtitle>
            <v-card-text class="shop-content">
                <div v-if="gameStore.shopStore.shop && gameStore.shopStore?.shop?.items.length === 0">
                The shop is currently out of stock. Please check back later.
                </div>
                <div v-else>
                    <div class="shop-items" >
                        <v-row class="ga-4" align="stretch" justify="center">
                            <v-col v-for="shopItem in gameStore.shopStore.shop?.items" :key="shopItem.itemID" :data="shopItem"
                            cols="12" sm="6" md="6" lg="4" class="d-flex">
                        <ShopCard :data="shopItem" class="flex-grow-1"/> 
                        </v-col>
                        </v-row>
                    </div>
                </div>
            </v-card-text>
        </v-card>
      </div>
    </v-dialog>

    </div>


</template>

<script setup lang="ts">
    import { ref, computed } from 'vue';     
    import PetCard from '../components/pet/PetCard.vue';
    import NavigationButton from '../components/navigation/NavigationButton.vue';
    import PetActionWidget from '../components/pet/PetActionWidget.vue';
    import { useGameStore } from '../stores/gameStore.ts';
    import BaseButton from '../components/shared/BaseButton.vue';
    import ShopCard from '../components/shop/ShopCard.vue';
    import InventoryCard from '../components/inventory/InventoryCard.vue';


    const gameStore = useGameStore()

    const showInventory = ref(false)
    const showShop = ref(false)

    const pet = computed(() => {
        console.log(gameStore.playerStore.player?.pet)
        return gameStore.playerStore.player?.pet ?? null
    })

    const petType = computed(() => {
        if(pet.value){
            return gameStore.petStore.petTypes[pet.value.typeID]!
        }
        return null
    })
    
    const openInventory = () => {
        showInventory.value = true
    }

    const openShop = () => {
        showShop.value = true
    }

    const inventoryItems = computed(() => 
        Object.values(gameStore.playerStore.player?.inventory?.items ?? {})
    )


</script>

<style scoped>

.sheet{
    width: 100%;
}

.pet-section{
    margin: auto 0;
        display:flex;
    flex-direction: column;
    gap: 1rem;
}

.subtitle {
    font-size: 1rem;
    padding: 0 0 0 2rem;
}

.title{
    font-size: 2rem;
    padding: 0.5rem 1rem;
}

.shop-items{
    gap: 1rem;
}

.item-image{
    font-size: 3rem;
}

.shop-content{
    margin: 1rem;
}

.pet-page{
    display:flex;
    flex-direction: column;
    min-height: 100vh;
    justify-content: flex-start;
}

.pet-card{
    display:flex;
    justify-content: center;
} 
.sheet-container {
    display: flex;
    justify-content: center;
    align-items:start;
    overflow: auto;
    scrollbar-width: none;
    
}

.controls{
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 0.5rem;
    justify-content: center;
}

.v-card-text {
    pointer-events: auto !important;
}
</style>