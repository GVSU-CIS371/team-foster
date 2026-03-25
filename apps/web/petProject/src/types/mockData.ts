import { createPetType, createPetStats } from './pet.ts'
import { createPlayer } from './player.ts'
import { createItem } from './inventory.ts'
import { createShop, createShopItem } from './shop.ts'


const crowImg = '../assets/pets/crow.svg'
const pandaImg = '../assets/pets/panda.svg'

const testPetTypes = {
    crow: createPetType({
        name: 'Crow',
        image: crowImg,
        decayRates: createPetStats({hunger: 1, happiness: 2, hygiene: 3})
    }),

    panda: createPetType({
        name: 'Panda',
        image: pandaImg,
        decayRates: createPetStats({hunger: 3, happiness: 1, hygiene: 2})
    })
} as const

const testPlayer = createPlayer()

const testShop = createShop()

const testItems = {
    testFood: createItem({type: 'Food'}),
    testToy: createItem({type: 'Toy'}),
    testHygiene: createItem({type: 'Hygiene'}   )
} as const

const testShopItems = {
    testSFood: createShopItem({item: testItems.testFood}),
    testSToy: createShopItem({item: testItems.testToy}),
    testSHygiene: createShopItem({item: testItems.testHygiene})
} as const

testShop.items.push(testShopItems.testSFood, testShopItems.testSToy, testShopItems.testSHygiene)
testPlayer.inventory.items.push({item: testItems.testFood, quantity: 2}, {item: testItems.testToy, quantity: 1})

export { testPetTypes, testShopItems, testItems, testPlayer, testShop };