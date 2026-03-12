import { defineStore } from 'pinia'
import crowImg from '/pets/crow.svg'
import pandaImg from '/pets/panda.svg'

const petTypes = {
    crow: {
        name: 'Crow',
        image: crowImg,

        hungerDecay: 1,
        happinessDecay: 0.5,
        hygieneDecay: 0.8
    },

    panda: {
        name: 'Panda',
        image: pandaImg,

        hungerDecay: 0.8,
        happinessDecay: 0.7,
        hygieneDecay: 0.6
    }
}

type PetType = keyof typeof petTypes

export const usePetStore = defineStore('pet', {
    state: () => ({
        petTypes,
        
        pet: {
            type: 'crow' as PetType,
            hunger: 90,
            happiness: 80,
            hygiene: 70
        }

    }),
    actions: {
        tick() {
            const type = this.petTypes[this.pet.type]

            this.pet.hunger -= type.hungerDecay
            this.pet.happiness -= type.happinessDecay
            this.pet.hygiene -= type.hygieneDecay
            
            // Ensure stats don't go below 0
            this.pet.hunger = Math.max(this.pet.hunger, 0)
            this.pet.happiness = Math.max(this.pet.happiness, 0)
            this.pet.hygiene = Math.max(this.pet.hygiene, 0)
        }
    }
})