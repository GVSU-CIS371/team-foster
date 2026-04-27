type ItemType = "Food" | "Toy" | "Hygiene" | "Wearable";

interface Item {
    id: string;
    name: string;
    description: string | null;
    effectValue: number | null;
    image: string;
    type: ItemType;
};

function toDbItem(it: Item): dbItem {
    return {
        id: it.id,
        name: it.name,
        description: it.description,
        image: it.image,
        effect_value: it.effectValue,
        type: it.type
    }
}

interface dbItem{
    id: string;
    effect_value: number | null;
    image: string;
    name: string;
    type: string;
    description: string | null;
};

function toItem(it: dbItem): Item {
    return {
        id: it.id,
        effectValue: it.effect_value,
        description: it.description,
        name: it.name,
        image: it.image,
        type: it.type as ItemType
    }
}

function createItem(overrides: Partial<Item> = {}): Item {
    return {
        id: "",
        name: "Test Item",
        description: null,
        effectValue: null,
        image: "testItem",
        type: "Food",
        ...overrides
    };
}

interface InventoryItem {
    itemID: string;
    quantity: number;
    userID: string
};

function toDbInventoryItem(ii: InventoryItem): dbInventoryItem {
    return {
        item_id: ii.itemID,
        quantity: ii.quantity,
        user_id: ii.userID
    }
}

interface dbInventoryItem {
    item_id: string;
    quantity: number;
    user_id: string
}

function toInventoryItem(ii: dbInventoryItem): InventoryItem {
    return {
        itemID: ii.item_id,
        quantity: ii.quantity,
        userID: ii.user_id
    }
}

interface Inventory {
    id: string;
    lastUpdate: Date;
    items: Record<string, InventoryItem>;
};

function toDbInventory(inv: Inventory): dbInventory {
    return {
        user_id: inv.id,
        last_update: new Date()
    }
}

interface dbInventory {
    user_id: string,
    last_update: Date
};

function toInventory (inv: dbInventory): Inventory {
    return {
        id: inv.user_id,
        items: {},
        lastUpdate: inv.last_update
    }
}

function createInventory(overrides: Partial<Inventory> = {}): Inventory {
    return {
        id: "",
        lastUpdate: new Date(),
        items: {} as Record<string,InventoryItem>,
        ...overrides
    };
}

function findItemByType(inventory: Inventory, items: Record<string, Item>, type: string){
    return Object.values(inventory.items).find(
        invItem => items[invItem.itemID]?.type === type
    ) ?? null
}


export type { Item, InventoryItem, Inventory, ItemType, dbInventory, dbItem, dbInventoryItem };
export { createItem, createInventory, toInventory, toItem, toDbInventory, toDbItem, toDbInventoryItem, toInventoryItem, findItemByType};