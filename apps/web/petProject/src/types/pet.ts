
interface PetType {
    id: string;
    name: string;
    image: string;
    decayRates: PetStats
};

function toDbPetType (petType: PetType): dbPetType{
    return {
        decay_rates: petType.decayRates,
        name: petType.name,
        image: petType.image,
        id: petType.id
    }
}

interface dbPetType {
    decay_rates: PetStats,
    id: string,
    image: string,
    name: string
};

function toPetType (petType: dbPetType): PetType {
    return {
        decayRates: petType.decay_rates,
        name: petType.name,
        image: petType.image,
        id: petType.id
    }
}

function createPetType(overrides: Partial<PetType> = {}): PetType {
    return {
        id: "test id",
        name: "Test Type",
        image: "testImage",
        decayRates: createPetStats({hunger: 1, happiness: 2, hygiene: 3}),
        ...overrides
    };
}

interface PetStats {
    hunger: number;
    happiness: number;
    hygiene: number;
};

function createPetStats(overrides: Partial<PetStats> = {}): PetStats {
    return {
        hunger: 50,
        happiness: 50,
        hygiene: 50,
        ...overrides
    };
}

interface dbPet {
    user_id: string,
    name: string,
    type_id: string,
    stats: PetStats,
    last_update: Date
};

function toPet(pet: dbPet): Pet {
    return {
        id: pet.user_id,
        name: pet.name,
        typeID: pet.type_id,
        stats: pet.stats,
        lastUpdate: pet.last_update,
        equipped: null
    };
}

interface Pet {
    id: string;
    name: string;
    typeID: string;
    stats: PetStats;
    equipped: string | null;
    lastUpdate: Date;
};

function toDbPet(pet: Pet): dbPet {
    return {
        user_id: pet.id,
        type_id: pet.typeID,
        stats: pet.stats,
        name: pet.name,
        last_update: new Date()
    };
}

function createPet(overrides: Partial<Pet> = {}): Pet {
    return {
        id: "",
        name: "Test Pet",
        typeID: "test type",
        stats: createPetStats(),
        equipped: null,
        lastUpdate: new Date(),
        ...overrides
    };
}

export type { PetType, PetStats, Pet };
export type { dbPetType, dbPet };
export { createPetType, createPetStats, createPet };
export { toDbPetType, toPetType, toDbPet, toPet };