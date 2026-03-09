<template>
  <div class="dashboard">
    <div class="header">
    <h2>Staff Dashboard</h2>

      <button
          class="text-4xl font-serif text-text-primary-light hover:text-black transition-colors cursor-pointer"
          @click="goHome"
      >
        Luxury
      </button>
    </div>
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
        <th>Hành động</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="order in data.recentOrders" :key="order.maDH">

        <td>{{ order.maDH }}</td>

        <td>{{ order.tenKhach }}</td>

        <td>{{ formatMoney(order.tongTien) }}</td>

        <td>

          <span v-if="order.trangThai==0">🟡 Chờ xác nhận</span>
          <span v-if="order.trangThai==1">📦 Đã xác nhận</span>
          <span v-if="order.trangThai==2">🚚 Đang giao</span>
          <span v-if="order.trangThai==3">✅ Hoàn thành</span>
          <span v-if="order.trangThai==4">❌ Đã huỷ</span>

        </td>

        <td>

          <button
              v-if="order.trangThai==0"
              @click="updateStatus(order,1)"
          >
            Xác nhận
          </button>

          <button
              v-if="order.trangThai==1"
              @click="updateStatus(order,2)"
          >
            Bắt đầu giao
          </button>

          <button
              v-if="order.trangThai==2"
              @click="updateStatus(order,3)"
          >
            Hoàn thành
          </button>

        </td>

      </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { onMounted, reactive } from "vue"
import axios from "axios"

import { useRouter } from "vue-router"

const router = useRouter()

const goHome = () => {
  router.push("/")
}

const updateStatus = async (order,status)=>{

  try{

    await axios.put(
        `/staff/orders/${order.maDH}/status`,
        null,
        {
          params:{
            trangThaiMoi: status
          }
        }
    )

    // reload dashboard
    const res = await axios.get("/staff/dashboard")
    Object.assign(data,res.data)

  }catch(err){

    console.error("Update status error",err)

  }

}

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