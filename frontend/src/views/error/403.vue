<template>

<div layout:fragment="content">
    <div class="login-container">
        <div class="login-form error-403-content">
            <h2 class="error-403-title">⛔ Truy Cập Bị Từ Chối</h2>

            <div class="error-403-message">
                <p>Bạn không có quyền truy cập vào trang này.</p>
                <p>Vui lòng đăng nhập với tài khoản có quyền phù hợp.</p>
            </div>

            <div class="login-links">
                <a class="btn-login error-403-home-btn" href="/">
                    🏠 Về Trang Chủ
                </a>
                <br><br>
                <a href="/login">Đăng nhập với tài khoản khác</a>
            </div>
        </div>
    </div>
</div>



</template>

<script>
export default {
  name: '403',
  data() {
    return {}
  },
  mounted() {
    // TODO: fetch data via axios or hydrate server state
  }
}
</script>

<style scoped>
/* TODO: import or copy CSS from original static/css */
</style>
