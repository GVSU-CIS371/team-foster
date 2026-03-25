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

        addItemToInventory(item: any) {
            const existingItem = this.player?.inventory.items.find(i => i.item.id === item.id)
            if (existingItem) {
                existingItem.quantity += 1
            } else {
                this.player?.inventory.items.push({item: item, quantity: 1})
            }
        },

        removeItemFromInventory(item: any) {
            const existingItem = this.player?.inventory.items.find(i => i.item.id === item.id)
            if (existingItem) {
                existingItem.quantity -= 1
                if (existingItem.quantity <= 0 && this.player) {
                    this.player.inventory.items = this.player.inventory.items.filter(i => i.item.id !== item.id)
                }
            }
        }
    }
})