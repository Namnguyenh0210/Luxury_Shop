<template>
<div class="flex min-h-screen w-full flex-col items-center justify-center bg-background-light dark:bg-background-dark">
    <AppHeader />
    <main class="flex-grow flex items-center justify-center">
        <div class="text-center px-4">
            <h1 class="text-9xl font-bold text-primary">404</h1>
            <p class="text-2xl font-medium text-gray-600 dark:text-gray-400 mt-4">Page Not Found</p>
            <p class="text-gray-500 dark:text-gray-500 mt-2 mb-8">The page you're looking for doesn't exist.</p>
            <a href="/" class="inline-block px-6 py-3 bg-accent text-white rounded-lg font-semibold hover:bg-accent/90 transition-colors">
                Go Home
            </a>
        </div>
    </main>
    <AppFooter />
</div>
</template>

<script>
import AppHeader from '../fragments/AppHeader.vue'
import AppFooter from '../fragments/AppFooter.vue'

export default {
  name: 'PageNotFound',
  components: {
    AppHeader,
    AppFooter
  }
}
</script>
