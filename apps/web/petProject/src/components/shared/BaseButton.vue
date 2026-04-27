<template>
    <button class="base-button" @click="handleClick" >
        {{ text }}
    </button>
</template>

<script setup lang="ts">
const props = defineProps({
    text: { type: String, required: true }
});

const emit = defineEmits<{
    (e:'click'): void
}>();

function handleClick() {
    emit('click');
}
</script>

<style scoped>
.base-button{
    border: none;
    padding: 10px 20px;
    font-size: 16px;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}
</style>