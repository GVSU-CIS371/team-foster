import type{ Item } from "./inventory";
import { createItem } from "./inventory";


interface ShopItem {
    id: string;
    item: Item;
    price: number;
    quantity: number | null;
}

function createShopItem(overrides: Partial<ShopItem> = {}): ShopItem {
    return {
        id: crypto.randomUUID(),
        item: createItem(),
        price: -1,
        quantity: null,
        ...overrides
    };
}


interface Shop {
    id: string;
    name: string;
    items: ShopItem[];
};

function createShop(overrides: Partial<Shop> = {}): Shop {
    return {
        id: crypto.randomUUID(),
        name: "Test Shop",
        items: [],
        ...overrides   
    };
}


export type { Shop, ShopItem };
export { createShop, createShopItem };