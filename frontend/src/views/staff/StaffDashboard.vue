<template>
  <div class="dashboard">
    <h2>Staff Dashboard</h2>

    <div class="cards">
      <div class="card">
        <h3>Tổng đơn hàng</h3>
        <p>{{ data.orderCount }}</p>
      </div>

      <div class="card">
        <h3>Đơn chờ xử lý</h3>
        <p>{{ data.pendingCount }}</p>
      </div>

      <div class="card">
        <h3>Bài viết của tôi</h3>
        <p>{{ data.myPostCount }}</p>
      </div>
    </div>

    <h3>Đơn hàng gần đây</h3>

    <table>
      <thead>
      <tr>
        <th>Mã ĐH</th>
        <th>Khách</th>
        <th>Tổng tiền</th>
        <th>Trạng thái</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="order in data.recentOrders" :key="order.maDH">
        <td>{{ order.maDH }}</td>
        <td>{{ order.tenKhach }}</td>
        <td>{{ formatMoney(order.tongTien) }}</td>
        <td>{{ order.trangThai }}</td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { onMounted, reactive } from "vue"
import axios from "axios"

const data = reactive({
  orderCount: 0,
  pendingCount: 0,
  myPostCount: 0,
  recentOrders: []
})

onMounted(async () => {
  try {
    const res = await axios.get("/staff/dashboard")
    Object.assign(data, res.data)
  } catch (err) {
    console.error(err)
  }
})

const formatMoney = (money) => {
  if (!money) return "0 đ"
  return new Intl.NumberFormat("vi-VN").format(money) + " đ"
}
</script>

<style scoped>
.dashboard {
  padding: 20px;
}

.cards {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
}

.card {
  flex: 1;
  padding: 20px;
  background: #f4f4f4;
  border-radius: 8px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 10px;
  border: 1px solid #ddd;
}
</style>