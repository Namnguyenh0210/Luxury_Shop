<template>
<div class="relative flex min-h-screen w-full flex-col bg-background-light dark:bg-background-dark">
    <AppHeader />
    <main class="flex-grow">
        <div class="container mx-auto px-4 py-16">
            <div class="max-w-2xl mx-auto text-center">
                <h1 class="text-4xl font-bold text-gray-900 dark:text-white mb-4">{{ title }}</h1>
                <p class="text-lg text-gray-600 dark:text-gray-400 mb-8">This page is being converted to Vue.js. Please check back soon!</p>
                <div class="flex gap-4 justify-center">
                    <a href="/" class="px-6 py-3 bg-accent text-white rounded-lg font-semibold hover:bg-accent/90 transition-colors">
                        Go Home
                    </a>
                    <a href="http://localhost:8080" target="_blank" class="px-6 py-3 bg-gray-200 dark:bg-gray-700 text-gray-900 dark:text-white rounded-lg font-semibold hover:bg-gray-300 dark:hover:bg-gray-600 transition-colors">
                        View on Backend
                    </a>
                </div>
            </div>
        </div>
    </main>
    <AppFooter />
</div>
</template>

<script>
import AppHeader from '../fragments/AppHeader.vue'
import AppFooter from '../fragments/AppFooter.vue'

export default {
  name: 'ComingSoon',
  components: {
    AppHeader,
    AppFooter
  },
  props: {
    title: {
      type: String,
      default: 'Coming Soon'
    }
  }
}
</script>
