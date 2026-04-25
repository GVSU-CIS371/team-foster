import {defineStore} from 'pinia'
import { usePlayerStore } from './playerStore'
import { usePetStore } from './petStore'
import { useShopStore } from './shopStore'
import { createPet, createPetStats, toPetType, toPet, toDbPet} from '../types/pet.ts'
import type { dbPet, dbPetType} from '../types/pet.ts'
import type { dbPlayer } from '../types/player.ts'
import { toPlayer, createDbPlayer, toDbPlayer} from '../types/player.ts'
import { toInventory, toItem, toInventoryItem, toDbInventoryItem, toDbInventory, createInventory } from '../types/inventory.ts'
import { toShop, toShopItem } from '../types/shop.ts'
import type { dbShop, ShopItem, dbShopItem } from '../types/shop.ts'
import type { Item, dbInventory, dbItem, dbInventoryItem } from '../types/inventory.ts'
import {getCollection,CollectionNames, getDocument, snapshotConverter} from "../utilities/dbService.ts"
import {updateDocument, updateCollection, addNamedDocument, deleteDocument} from "../utilities/dbService.ts"

const tickInterval = 10 // seconds

export const useGameStore = defineStore('game', {
    state: () => ({
        playerStore: usePlayerStore(),
        petStore: usePetStore(),
        shopStore: useShopStore(),
        items: {} as Record<string, Item>,
        timerId: null as number | null,
        loggedIn: false
    }),

    actions: {
        startPetTimer() {
            console.log("Starting pet timer...")
            if (this.timerId !== null) clearInterval(this.timerId)
            this.timerId = setInterval(() => {

                console.log("TIMER PLAYER: ", this.playerStore.player)
                this.playerStore.income()
                updateDocument(CollectionNames.Users, this.playerStore.player!.id, toDbPlayer(this.playerStore.player!))

                console.log("TIMER PET: ", this.petStore.pet)
                if (this.playerStore.hasPet){
                    this.petStore.decayPetStats()
                    updateDocument(CollectionNames.Pets, this.playerStore.player?.id ?? "", toDbPet(this.petStore.pet!))
                }
            }, tickInterval * 1000) // sec -> ms
        },

        stopPetTimer() {
            if (this.timerId) {
                clearInterval(this.timerId)
                this.timerId = null
            }
        },

        newPet(name: string, type: string | null) {
            if(type && this.playerStore.player) {
                this.playerStore.player.pet = createPet({id: this.playerStore.player.id ,name:name, typeID: type, stats: createPetStats({hunger: 100, happiness: 100, hygiene: 100})})
                this.petStore.pet = this.playerStore.player.pet
                let dbPet = toDbPet(this.petStore.pet)
                this.startPetTimer()

                updateDocument(CollectionNames.Pets, this.playerStore.player.id, dbPet)

                this.playerStore.startPetListener(this.playerStore.player.id)
            } 
        },

        

        buyItem(item: ShopItem) {
            if (this.playerStore.player&& this.playerStore.player.currency >= item.price) {
                let userID = this.playerStore.player.id
                this.playerStore.player.currency -= item.price
                this.playerStore.addItemToInventory(item.itemID)
                let invItem = this.playerStore.player.inventory?.items[item.itemID]
                if(invItem){
                    let dbItem = toDbInventoryItem(invItem)
                    let filters = {
                        user_id: {op: "==", value: userID}, 
                        item_id: {op: "==", value: dbItem.item_id}
                    }

                    updateCollection(CollectionNames.InventoryItems, dbItem, filters)
                    updateDocument(CollectionNames.Inventories, userID, toDbInventory(this.playerStore.player.inventory!))
                    updateDocument(CollectionNames.Users, userID, toDbPlayer(this.playerStore.player))
                }
            }
        },

        useItem(itemID: string) {
            let item = this.items[itemID]
            console.log(item)
            
            if (item){
            switch(item.type) {
                case 'Food':
                    this.petStore.updateHunger(item.effectValue!)
                    break
                case 'Toy':
                    this.petStore.updateHappiness(item.effectValue!)
                    break
                case 'Hygiene':
                    this.petStore.updateHygiene(item.effectValue!)
                    break
            }
            }

            this.playerStore.removeItemFromInventory(itemID)
            let invItem = this.playerStore.player?.inventory?.items[itemID]
            let userID = this.playerStore.player?.id
            let filters = {
                user_id: {op: "==", value: userID!}, 
                item_id: {op: "==", value: itemID}
            }

            if(invItem){
                let dbItem = toDbInventoryItem(invItem)
                    
                updateCollection(CollectionNames.InventoryItems, dbItem, filters)
            } else {
                deleteDocument(CollectionNames.InventoryItems, filters)
            }

            updateDocument(CollectionNames.Inventories, userID!, toDbInventory(this.playerStore.player?.inventory!))
            updateDocument(CollectionNames.Pets, userID!, toDbPet(this.petStore.pet!))
        },

        async initialize(userID: string, username: string) {

            var rawCollection = await getCollection(CollectionNames.PetTypes)
            console.log(rawCollection)

            if(rawCollection) {
                for(const doc of rawCollection.docs){
                    console.log(doc)
                    let pType = snapshotConverter<dbPetType>(doc)
                    console.log(pType)
                    this.petStore.petTypes[pType.id] = toPetType(pType)
                }
            }

            console.log("Pet Types: ", this.petStore.petTypes)

            rawCollection = await getCollection(CollectionNames.Items)

            if(rawCollection) {
                for(const doc of rawCollection.docs){
                    console.log(doc)
                    let item = snapshotConverter<dbItem>(doc)
                    this.items[item.id] = toItem(item)
                }
            }

            console.log("Items: ", this.items)

            rawCollection = await getCollection(CollectionNames.Shops)
            
            if(rawCollection) {
                let shop = snapshotConverter<dbShop>(rawCollection.docs[0])
                this.shopStore.shop = toShop(shop)

                console.log("Shop: ", this.shopStore.shop)
                console.log(shop.shopID)

                rawCollection = await getCollection(CollectionNames.ShopItems, {shop_id: {op: "==", value: this.shopStore.shop.id}})
                
                if(rawCollection) {
                    for(const doc of rawCollection.docs){
                        console.log(doc)
                        let shopItem = snapshotConverter<dbShopItem>(doc)
                        this.shopStore.shop?.items.push(toShopItem(shopItem))
                    }
                }
                
            }

            console.log("Completed Shop: ", this.shopStore.shop)
            this.shopStore.startShopListener(this.shopStore.shop!.id)

            var rawDocument = await getDocument(CollectionNames.Users, userID)

            if(!rawDocument){
                let dbPlayer = createDbPlayer({user_id: userID, username: username})
                await addNamedDocument(CollectionNames.Users, userID, dbPlayer)
                rawDocument = await getDocument(CollectionNames.Users, userID)
            }

            if(rawDocument) {
                let playerData = snapshotConverter<dbPlayer>(rawDocument)
                let player = toPlayer(playerData)
                var prevTime = new Date(player.lastUpdate as any)
                console.log(player)
                console.log("lastUpdate type", typeof player.lastUpdate)
                console.log("lastUpdate constructor type", player.lastUpdate?.constructor?.name)
                this.playerStore.player = player
                var numIntervals = Math.floor((Date.now() - prevTime.getTime()) / tickInterval)
                console.log(numIntervals)
                this.playerStore.income(numIntervals)

                console.log("Player: ", this.playerStore.player)
                

                if(this.playerStore.player) {
                    let userID = this.playerStore.player.id
                    console.log("player id: ", userID)
                    rawDocument = await getDocument(CollectionNames.Pets, userID)
                    console.log("got pet document: ", rawDocument)

                    if(rawDocument?.exists()) {
                        let petData = snapshotConverter<dbPet>(rawDocument)
                        console.log("converted pet data: ", petData)
                        let pet = toPet(petData)
                        prevTime = new Date(pet.lastUpdate as any)
                        console.log(typeof prevTime)
                        numIntervals = Math.floor((Date.now() - prevTime.getTime()) / tickInterval)
                        console.log(numIntervals)
                        this.playerStore.player.pet = pet ? pet : null
                        this.petStore.pet = this.playerStore.player!.pet!

                        this.petStore.decayPetStats(numIntervals)

                        if (this.playerStore.hasPet) {
                            this.petStore.pet = this.playerStore.player.pet!
                        }

                        console.log("Player Pet: ", this.playerStore.player.pet)
                        console.log(this.playerStore.player?.pet?.typeID)
                        this.playerStore.startPetListener(userID)
                    }
                    rawDocument = await getDocument(CollectionNames.Inventories, userID)

                    if(rawDocument?.exists()){
                        let inventoryData = snapshotConverter<dbInventory>(rawDocument)

                        this.playerStore.player.inventory = toInventory(inventoryData)

                        rawCollection = await getCollection(CollectionNames.InventoryItems, {user_id: {op: "==", value: userID}})

                        if(rawCollection) {
                            for(const doc of rawCollection.docs){
                                console.log(doc)
                                let inventoryItem = snapshotConverter<dbInventoryItem>(doc)
                                this.playerStore.player!.inventory!.items[inventoryItem.item_id] = toInventoryItem(inventoryItem)
                            }
                        }

                        console.log("Player Inventory: ", this.playerStore.player.inventory)
                        this.playerStore.startInventoryListener(userID)
                        
                    } else {
                        this.playerStore.player.inventory = createInventory({id: userID})
                        addNamedDocument(CollectionNames.Inventories, userID, toDbInventory(this.playerStore.player.inventory))
                        this.playerStore.startInventoryListener(userID)
                    }
                }

                console.log("Complete Player: ", this.playerStore.player)
                this.playerStore.startPlayerListener(userID)
                console.log(this.playerStore.player.inventory)
            }
        }, 

        logout(){
            this.playerStore.player!.pet = null
            this.petStore.pet = null
            this.playerStore.player!.inventory = null
            this.playerStore.player = null

            if(this.playerStore.petListener){
                this.playerStore.petListener()
                this.playerStore.petListener = null
            }

            if(this.playerStore.invItemListener){
                this.playerStore.invItemListener()
                this.playerStore.invItemListener = null
            }

            if(this.playerStore.inventoryListener){
                this.playerStore.inventoryListener()
                this.playerStore.inventoryListener = null
            }

            if(this.playerStore.playerListener){
                this.playerStore.playerListener()
                this.playerStore.playerListener = null
            }


        }



            
    }
})
