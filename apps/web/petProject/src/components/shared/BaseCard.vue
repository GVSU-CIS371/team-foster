<template>
    <div class="card">
        <h2 class="card-title">{{ name ?? 'Card' }}</h2>
        <div v-for="(value, key) in data" :key="key" class="card-data" id="`${data.TypeName ?? 'unknown'}-${data.name ?? key}`">
              <strong>{{ key }}:</strong> {{ value }}
        

        </div>
        <slot></slot>
    </div>
</template>

<script setup lang="ts">
interface DataObject {
    [key: string]: any;
}

const {name, data} = defineProps({
    name: {type: String, required: false},
    data: {type: Object as () => DataObject, required: true}
});
</script>