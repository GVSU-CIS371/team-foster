import { defineStore} from 'pinia'
import type { Player } from '../types/player.ts'
import {toPlayer} from '../types/player.ts'
import { CollectionNames, startCollectionListener, startDocListener } from '../utilities/dbService.ts'
import { toInventory, toInventoryItem } from '../types/inventory.ts'
import {toPet} from '../types/pet.ts'

export const usePlayerStore = defineStore('player', {
    state: () => ({
        player: null as Player | null,
        playerListener: null as null | (() => void),
        inventoryListener: null as null | (() => void),
        invItemListener: null as null | (() => void),
        petListener: null as null | (() => void)
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
        },

        startPlayerListener(userID: string){
            this.playerListener = startDocListener(CollectionNames.Users, userID, (data) => {
                var player = toPlayer(data)
                if (player.pet == null && this.player?.pet != null){
                    player.pet = this.player?.pet
                }

                if (player.inventory == null && this.player?.inventory != null){
                    player.inventory = this.player?.inventory
                }

                this.player = player
            })
        },

        startInventoryListener(userID: string){
            this.inventoryListener = startDocListener(CollectionNames.Inventories, userID, (data) => {
                var inv = toInventory(data)
                
                if (this.player && this.player.inventory){
                    inv.items = this.player?.inventory?.items

                    this.player.inventory = inv
                }
            })

            let filters = {
                user_id: {op: "==", value: userID!}, 
            }
            
            this.invItemListener = startCollectionListener(CollectionNames.InventoryItems, filters, (items) =>{
                console.log("INV ITEM LISTENER", items)
                if (this.player?.inventory){
                    items.forEach( item => {
                        console.log(item)
                        this.player!.inventory!.items[item.item_id] = toInventoryItem(item)
                    })
                    console.log("inventory after update", this.player.inventory.items)
                }
            })
        },

        startPetListener(userID: string){
                console.log("START PET LISTENER" + userID)
                this.petListener = startDocListener(CollectionNames.Pets, userID, (data) => {
                    console.log(userID)
                    if(this.player)
                        this.player!.pet = toPet(data)
                })
        }
    }
})