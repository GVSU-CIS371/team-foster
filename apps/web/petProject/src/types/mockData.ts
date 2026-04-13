/*import { createPetType, createPetStats } from './pet.ts'
import { createPlayer } from './player.ts'
import { createItem } from './inventory.ts'
import { createShop, createShopItem } from './shop.ts'


const crowImg = '../assets/pets/crow.svg'
const pandaImg = '../assets/pets/panda.svg'


const testPlayer = createPlayer()

const testShop = createShop()

const testItems = {
    testFood: createItem({type: 'Food'}),
    testToy: createItem({type: 'Toy'}),
    testHygiene: createItem({type: 'Hygiene'}   )
} as const

const testShopItems = {
    testSFood: createShopItem({item: testItems.testFood.id}),
    testSToy: createShopItem({item: testItems.testToy.id}),
    testSHygiene: createShopItem({item: testItems.testHygiene.id})
} as const

testShop.items.push(testShopItems.testSFood, testShopItems.testSToy, testShopItems.testSHygiene)
testPlayer.inventory?.items.push({itemID: testItems.testFood.id, quantity: 2, userID: "test"}, {itemID: testItems.testToy.id, quantity: 1, userID: "test"})

export {  testShopItems, testItems, testPlayer, testShop };*/