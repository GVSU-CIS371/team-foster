interface PetType {
    id: string;
    name: string;
    image: string;
    decayRates: PetStats
}

function createPetType(overrides: Partial<PetType> = {}): PetType {
    return {
        id: crypto.randomUUID(),
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
}

function createPetStats(overrides: Partial<PetStats> = {}): PetStats {
    return {
        hunger: 50,
        happiness: 50,
        hygiene: 50,
        ...overrides
    };
}

interface Pet {
    id: string;
    name: string;
    type: PetType;
    stats: PetStats;
}

function createPet(overrides: Partial<Pet> = {}): Pet {
    return {
        id: crypto.randomUUID(),
        name: "Test Pet",
        type: createPetType(),
        stats: createPetStats(),
        ...overrides
    };
}

export type { PetType, PetStats, Pet };
export { createPetType, createPetStats, createPet };
