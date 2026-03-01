<script setup>
import { ref, onMounted } from "vue";
import axios from "@/axios";
import { useRouter } from "vue-router";

const router = useRouter();
const orders = ref([]);
const page = ref(0);

const loadOrders = async () => {
  const res = await axios.get("/staff/orders", {
    params: { page: page.value }
  });

  orders.value = res.data.content;
};

const goDetail = (id) => {
  router.push(`/staff/orders/${id}`);
};

onMounted(loadOrders);
</script>

<template>
  <div>
    <h2>Quản lý đơn hàng</h2>

    <table border="1">
      <tr>
        <th>ID</th>
        <th>Khách hàng</th>
        <th>Ngày đặt</th>
        <th>Trạng thái</th>
        <th></th>
      </tr>

      <tr v-for="o in orders" :key="o.maDH">
        <td>{{ o.maDH }}</td>
        <td>{{ o.khachHang?.hoTen }}</td>
        <td>{{ o.ngayDat }}</td>
        <td>{{ o.trangThaiDHText }}</td>
        <td>
          <button @click="goDetail(o.maDH)">Chi tiết</button>
        </td>
      </tr>
    </table>
  </div>
</template>