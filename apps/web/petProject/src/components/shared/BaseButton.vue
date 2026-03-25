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