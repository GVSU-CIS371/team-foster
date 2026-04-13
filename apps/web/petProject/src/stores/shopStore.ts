import {defineStore} from 'pinia'
import type { Shop } from '../types/shop.ts'
//import { testShopItems } from '../types/mockData.ts'

export const useShopStore = defineStore('shop', {
    state: () => ({
        shop: null as Shop | null,
    }),
    getters: {
        shopItems: (state) => {
            return state.shop?.items || []
        }
    },
})