import { reactive } from 'vue'
import axios from 'axios'

export const authState = reactive({
  user: null,
  loading: false,
  fetched: false
})

export async function fetchCurrentUser() {
  if (authState.fetched) return authState.user
  
  authState.loading = true
  try {
    const res = await axios.get('/auth/current-user', { withCredentials: true })
    if (res.data.authenticated) {
      authState.user = {
        name: res.data.hoTen || res.data.email,
        role: res.data.vaiTros?.join(', ') || '',
        roles: res.data.vaiTros || []
      }
    } else {
      authState.user = null
    }
    authState.fetched = true
    return authState.user
  } catch (err) {
    console.error('Error fetching current user:', err)
    return null
  } finally {
    authState.loading = false
  }
}
