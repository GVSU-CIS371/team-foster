import {defineStore} from 'pinia'
import { usePlayerStore } from './playerStore'
import { usePetStore } from './petStore'
import { useShopStore } from './shopStore'
import { createPet, createPetStats} from '../types/pet'
import type { PetType } from '../types/pet.ts'
import type { ShopItem } from '../types/shop.ts'
import type { InventoryItem } from '../types/inventory.ts'
import { testPetTypes } from '../types/mockData.ts'

const tickInterval = 10000 // 10 seconds

export const useGameStore = defineStore('game', {
    state: () => ({
        playerStore: usePlayerStore(),
        petStore: usePetStore(),
        shopStore: useShopStore(),
        petTypes: testPetTypes as Record <string, PetType>,
        timerId: null as number | null,
        loggedIn: false
    }),

    actions: {
        startPetTimer() {
            console.log("Starting pet timer...")
            if (this.timerId !== null) clearInterval(this.timerId)
            this.timerId = setInterval(() => {
                if (this.playerStore.hasPet)
                    this.petStore.decayPetStats()
            }, tickInterval)
        },

        stopPetTimer() {
            if (this.timerId) {
                clearInterval(this.timerId)
                this.timerId = null
            }
        },

        newPet(name: string, type: PetType | null) {
            if(type && this.playerStore.player) {
                this.playerStore.player.pet = createPet({name:name, type: type, stats: createPetStats({hunger: 100, happiness: 100, hygiene: 100})})
                this.petStore.pet = this.playerStore.player.pet
                this.startPetTimer()
            } 
        },

        buyItem(item: ShopItem) {
            if (this.playerStore.player&& this.playerStore.player.currency >= item.price) {
                this.playerStore.player.currency -= item.price
                this.playerStore.addItemToInventory(item.item)
            }
        },

        useItem(inventory: InventoryItem) {
            let item = inventory.item
            
            switch(item.type) {
                case 'Food':
                    this.petStore.updateHunger(item.effectValue)
                    break
                case 'Toy':
                    this.petStore.updateHappiness(item.effectValue)
                    break
                case 'Hygiene':
                    this.petStore.updateHygiene(item.effectValue)
                    break
            }

            this.playerStore.removeItemFromInventory(item)
        },



            
    }
})
