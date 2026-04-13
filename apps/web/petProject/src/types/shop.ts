
interface ShopItem {
    shopID: string;
    itemID: string;
    price: number;
    quantity: number | null;
};

function toDbShopItem(si: ShopItem): dbShopItem{
    return {
        item_id: si.itemID,
        price: si.price,
        shop_id: si.shopID,
        quantity: si.quantity
    };
}

interface dbShopItem {
    item_id: string;
    price: number;
    quantity: number | null;
    shop_id: string;
};

function toShopItem (si: dbShopItem): ShopItem{
    return {
        itemID: si.item_id,
        shopID: si.shop_id,
        quantity: si.quantity,
        price: si.price
    };
}

function createShopItem(overrides: Partial<ShopItem> = {}): ShopItem {
    return {
        shopID: "",
        itemID: "",
        price: -1,
        quantity: null,
        ...overrides
    };
}


interface Shop {
    id: string;
    name: string;
    items: ShopItem[];
    lastUpdate: Date
};


function toDbShop(shop: Shop): dbShop {
    return {
        shop_id: shop.id,
        name: shop.name,
        last_update: new Date()
    }
}


interface dbShop {
    last_update: Date;
    name: string;
    shop_id: string;
};


function toShop(shop: dbShop): Shop {
    return {
        id: shop.shop_id,
        name: shop.name,
        items: [],
        lastUpdate: shop.last_update
    }
}


function createShop(overrides: Partial<Shop> = {}): Shop {
    return {
        id: "",
        name: "Test Shop",
        items: [],
        lastUpdate: new Date(),
        ...overrides   
    };
}


export type { Shop, ShopItem, dbShop, dbShopItem };
export { createShop, createShopItem, toDbShop, toShop, toDbShopItem, toShopItem };