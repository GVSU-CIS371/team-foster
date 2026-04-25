import {defineStore} from 'pinia'
import type { Shop } from '../types/shop.ts'
import {toShop, toShopItem} from '../types/shop.ts'
import { startDocListener, startCollectionListener, CollectionNames } from '../utilities/dbService.ts'

//import { testShopItems } from '../types/mockData.ts'

export const useShopStore = defineStore('shop', {
    state: () => ({
        shop: null as Shop | null,
        shopListener: null as null | (() => void),
        shopItemListener: null as null | (() => void)
    }),
    getters: {
        shopItems: (state) => {
            return state.shop?.items || []
        },
    },

    actions: {
        startShopListener(shopID: string | null){
            if (shopID) {
                let filters = {shopID: {op: "==", value: shopID}}
                this.shopListener = startCollectionListener(CollectionNames.Shops, filters, (data) => {
                    if(!data || data.length === 0) return
                    let shop = toShop(data[0])

                    if(Object.keys(shop.items).length === 0 && Object.keys(this.shop?.items ?? {}).length > 0) {
                        shop.items = this.shop?.items ?? []
                    }
                })
                this.shopItemListener = startCollectionListener(CollectionNames.ShopItems, filters, (items) => {
                    if(this.shop) {
                        items.forEach(item => {
                            this.shop!.items[item.id] = toShopItem(item)
                        })
                    }
                })
            }
        }
    },
})