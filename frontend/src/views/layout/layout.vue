<template>
  <div class="relative flex min-h-screen w-full flex-col bg-gray-50 group/design-root">
    <!-- ===== MAIN CONTENT ===== -->
    <slot />
  </div>
</template>

<script>
export default {
  name: 'AppLayout'
}
</script>
