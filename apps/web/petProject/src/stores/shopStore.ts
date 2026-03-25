import {defineStore} from 'pinia'
import type { ShopItem } from '../types/shop.ts'
import { testShopItems } from '../types/mockData.ts'

export const useShopStore = defineStore('shop', {
    state: () => ({
        items: testShopItems as Record<string, ShopItem>
    }),
    getters: {
        shopItems: (state) => {
            return state.items
        }
    },
})