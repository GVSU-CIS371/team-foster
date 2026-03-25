import type {Pet} from "./pet";
import type {Inventory} from "./inventory";
import {createInventory} from "./inventory";

interface Player {
    id: string;
    username: string;
    pet: Pet | null;
    inventory: Inventory;
    currency: number;
}

function createPlayer(overrides: Partial<Player> = {}): Player {
    return {
        id: crypto.randomUUID(),
        username: "Test Player",
        pet: null,
        inventory: createInventory(),
        currency: 1000,
        ...overrides
    };
}

export type { Player };
export { createPlayer };