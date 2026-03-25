type ItemType = "Food" | "Toy" | "Hygiene" | "Wearable";

interface Item {
    id: string;
    name: string;
    description: string;
    effectValue: number;
    image: string;
    type: ItemType;
}

function createItem(overrides: Partial<Item> = {}): Item {
    return {
        id: crypto.randomUUID(),
        name: "Test Item",
        description: "Test Item Description",
        effectValue: 5,
        image: "testItem",
        type: "Food",
        ...overrides
    };
}

interface InventoryItem {
    item: Item;
    quantity: number;
}

interface Inventory {
    items: InventoryItem[];
}

function createInventory(overrides: Partial<Inventory> = {}): Inventory {
    return {
        items: [] as InventoryItem[],
        ...overrides
    };
}


export type { Item, InventoryItem, Inventory, ItemType };
export { createItem, createInventory };