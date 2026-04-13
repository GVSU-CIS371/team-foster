import type {Pet} from "./pet";
import type {Inventory} from "./inventory";

interface dbPlayer {
    user_id: string;
    username: string;
    last_update: Date
    currency: number
}

function createDbPlayer(overrides: Partial<dbPlayer> = {}): dbPlayer {
    return {
        user_id: "test",
        username: "Test Player",
        currency: 1000,
        last_update: new Date(),
        ...overrides
    };
}

function toPlayer(player: dbPlayer): Player {
    return {
        id: player.user_id,
        username: player.username,
        lastUpdate: player.last_update,
        currency: player.currency,
        pet: null,
        inventory: null
    };
}

interface Player {
    id: string;
    username: string;
    pet: Pet | null;
    inventory: Inventory | null;
    currency: number;
    lastUpdate: Date;
}

function toDbPlayer(player: Player){
    return {
        user_id: player.id,
        username: player.username,
        last_update: new Date(),
        currency: player.currency
    }
}

function createPlayer(overrides: Partial<Player> = {}): Player {
    return {
        id: "",
        username: "Test Player",
        pet: null,
        inventory: null,
        currency: 1000,
        lastUpdate: new Date(),
        ...overrides
    };
}

export type { Player, dbPlayer};
export { createPlayer, toPlayer, toDbPlayer, createDbPlayer};