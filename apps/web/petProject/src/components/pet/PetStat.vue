<template>
    <div class="pet-stat">
        <slot name="stat-name"></slot>
        <slot name="stat-value"></slot>
    </div>
</template>

<style scoped>
.pet-stat{
    font-size: 150%;
}
</style>