import { defineStore } from 'pinia'
import type {Pet } from '../types/pet.ts'
import { createPet } from '../types/pet.ts'


export const usePetStore = defineStore('pet', {
    state: () => ({
        pet: createPet() as Pet

    }),
    getters: {
        petHunger: (state) => {
            return state.pet.stats.hunger
        },  
        
        petHappiness: (state) => {
            return state.pet.stats.happiness
        },

        petHygiene: (state) => {
            return state.pet.stats.hygiene
        },
    },

    actions: {
        setPetName(name: string) {
            this.pet.name = name
        },

        updateHunger(hunger: number) {
            this.pet.stats.hunger = Math.min(Math.max(0, this.pet.stats.hunger + hunger), 100)
        },

        updateHappiness(happiness: number) {
            this.pet.stats.happiness = Math.min(Math.max(0, this.pet.stats.happiness + happiness), 100)
        },

        updateHygiene(hygiene: number) {
            this.pet.stats.hygiene = Math.min(Math.max(0, this.pet.stats.hygiene + hygiene), 100)
        },

        decayPetStats(){
            let newHunger = -this.pet.type.decayRates.hunger
            let newHappiness = -this.pet.type.decayRates.happiness
            let newHygiene = -this.pet.type.decayRates.hygiene

            this.updateHunger(newHunger)
            this.updateHappiness(newHappiness)
            this.updateHygiene(newHygiene)
        }
    }

})
