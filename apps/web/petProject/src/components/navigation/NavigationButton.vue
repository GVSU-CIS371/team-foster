<template>
    <BaseButton :text="text" @click="handleClick"/>
</template>

<script setup lang="ts">
import BaseButton from '../shared/BaseButton.vue';
import { useNavigation } from '../../utilities/navigation';

const props = defineProps<{
    text: string;
    to: string;
}>()

const nav = useNavigation()

function handleClick() {
    switch (props.to.toLowerCase()) {
        case 'pet':
            nav.goToPet()
            break;
        case 'inventory':
            nav.goToInventory()
            break;
        case 'shop':
            nav.goToShop()
            break;
        case 'create':
            nav.goToCreate()
            break;
        case 'login':
            nav.login()
            break;
        case 'logout':
            nav.logout()
            break;
        default:
            console.warn(`Unknown navigation target: ${props.to}`)
    }
}
</script>