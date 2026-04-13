import { defineStore} from 'pinia'
import type { Player } from '../types/player.ts'

export const usePlayerStore = defineStore('player', {
    state: () => ({
        player: null as Player | null
    }),
    getters: {
        hasPet: (state) => {
            return !!state.player?.pet
        }
    },
    actions: {
        setPlayer(player: Player | null) {
            this.player = player
        },

        addItemToInventory(itemID: string) {
            const existingItem = this.player?.inventory?.items[itemID]
            if (existingItem) {
                existingItem.quantity += 1
            } else {
                this.player!.inventory!.items[itemID] = {itemID: itemID, quantity: 1, userID: this.player?.id!}
            }
        },

        removeItemFromInventory(itemID: string) {
            const existingItem = this.player?.inventory?.items[itemID]

            if (existingItem) {
                existingItem.quantity -= 1
                if (existingItem.quantity <= 0 && this.player) {
                   delete this.player!.inventory!.items[itemID] 
                }
            } else {
                console.log("item not found in inventory")
            }
        },

         income(multiplier: number = 1){
            this.player!.currency += 100 * multiplier
        }
    }
})