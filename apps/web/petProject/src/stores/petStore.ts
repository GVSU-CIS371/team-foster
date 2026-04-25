import { defineStore } from 'pinia'
import type {Pet, PetType } from '../types/pet.ts'
import { createPet, toPet } from '../types/pet.ts'
import { CollectionNames, startDocListener } from '../utilities/dbService.ts'


export const usePetStore = defineStore('pet', {
    state: () => ({
        pet: null as Pet | null,
        petTypes: {} as Record <string, PetType>

    }),
    getters: {
        petHunger: (state) => {
            return state.pet?.stats.hunger
        },  
        
        petHappiness: (state) => {
            return state.pet?.stats.happiness
        },

        petHygiene: (state) => {
            return state.pet?.stats.hygiene
        },
    },

    actions: {
        setPetName(name: string) {
            this.pet!.name = name
        },

        updateHunger(hunger: number) {
            console.log("update pet hunger")
            this.pet!.stats.hunger = Math.min(Math.max(0, this.pet!.stats.hunger + hunger), 100)
        },

        updateHappiness(happiness: number) {
            this.pet!.stats.happiness = Math.min(Math.max(0, this.pet!.stats.happiness + happiness), 100)
        },

        updateHygiene(hygiene: number) {
            this.pet!.stats.hygiene = Math.min(Math.max(0, this.pet!.stats.hygiene + hygiene), 100)
        },

        decayPetStats(multiplier: number = 1){ 
            let typeID = this.pet?.typeID
            console.log("Decaying pet stats for typeID:", typeID)

            let petType = this.petTypes[this.pet?.typeID ?? ""]!
            let newHunger = -petType.decayRates.hunger * multiplier
            let newHappiness = -petType.decayRates.happiness * multiplier
            let newHygiene = -petType.decayRates.hygiene * multiplier

            this.updateHunger(newHunger)
            this.updateHappiness(newHappiness)
            this.updateHygiene(newHygiene)
        },

        
    }

})
