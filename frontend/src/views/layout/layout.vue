<template>
<th:block v-if="pageTitle == 'Products' or currentPage == 'sanpham'">
        <link rel="stylesheet" href="/css/Product.css">
    </th:block>
    <!-- Cart CSS broadened -->
    <th:block v-if="pageTitle == 'Cart' or currentPage == 'giohang' or (pageTitle != null and #strings.contains(pageTitle, 'Giỏ hàng'))">
        <link rel="stylesheet" href="/css/Giohang.css">
    </th:block>
    <!-- Product detail page CSS: load if legacy pageTitle='ProductDetail' OR controller set currentPage='sanpham-detail' -->
    <th:block v-if="pageTitle == 'ProductDetail' or currentPage == 'sanpham-detail'">
        <link rel="stylesheet" href="/css/ProductDetail.css">
    </th:block>
    <!-- Pay CSS -->
    <th:block v-if="pageTitle == 'Pay'">
        <link rel="stylesheet" href="/css/Pay.css">
    </th:block>
    <!-- Profile CSS -->
    <th:block v-if="pageTitle == 'Profile'">
        <link rel="stylesheet" href="/css/Profile.css">
    </th:block>

    <th:block layout:fragment="head"></th:block>


<div class="relative flex min-h-screen w-full flex-col group/design-root">
    <!-- Header Fragment -->
    <div></div>

    <!-- Main Content Section -->
    <div layout:fragment="content">
        <!-- Default content if no content is provided -->
    </div>

    <!-- Footer Fragment -->
    <div></div>
</div>

<!-- Page-specific scripts -->
<th:block layout:fragment="scripts"></th:block>

<!-- Load scripts at the end of body for better performance -->
<!-- ✅ COMMON.JS - PHẢI LOAD TRƯỚC TẤT CẢ (chứa hàm dùng chung) -->
<script src="/js/common.js"></script>

<script src="/js/Home.js"></script>
<th:block v-if="pageTitle == 'Products' or currentPage == 'sanpham'">
    <script src="/js/Product.js"></script>
</th:block>
<th:block v-if="pageTitle == 'Cart' or currentPage == 'giohang' or (pageTitle != null and #strings.contains(pageTitle, 'Giỏ hàng'))">
    <script src="/js/Giohang.js"></script>
</th:block>
<th:block v-if="pageTitle == 'ProductDetail' or currentPage == 'sanpham-detail'">
    <script src="/js/ProductDetail.js"></script>
</th:block>
<th:block v-if="pageTitle == 'Pay'">
    <script src="/js/Pay.js"></script>
</th:block>
<th:block v-if="pageTitle == 'Profile'">
    <script src="/js/Profile.js"></script>
</th:block>
<th:block v-if="pageTitle == 'Register'">
    <script src="/js/ĐkiTk.js"></script>
</th:block>

<!-- ✅ MAIN.JS - LOAD CUỐI CÙNG (jQuery legacy - optional) -->
<script src="/js/main.js"></script>



</template>

<script>
export default {
  name: 'layout',
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
