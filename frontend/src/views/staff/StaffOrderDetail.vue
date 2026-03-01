<script setup>
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import axios from "@/axios";

const route = useRoute();
const id = route.params.id;

const donHang = ref({});
const chiTiet = ref([]);

const loadDetail = async () => {
  const res = await axios.get(`/staff/orders/${id}`);
  donHang.value = res.data.donHang;
  chiTiet.value = res.data.chiTiet;
};

const updateStatus = async (status) => {
  await axios.put(`/staff/orders/${id}/status`, null, {
    params: { trangThaiMoi: status }
  });
  loadDetail();
};

onMounted(loadDetail);
</script>

<template>
  <div>
    <h2>Chi tiết đơn hàng #{{ donHang.maDH }}</h2>

    <p>Khách hàng: {{ donHang.khachHang?.hoTen }}</p>
    <p>Trạng thái: {{ donHang.trangThaiDHText }}</p>

    <button @click="updateStatus(1)">Xác nhận</button>
    <button @click="updateStatus(2)">Đang giao</button>
    <button @click="updateStatus(3)">Hoàn tất</button>

    <h3>Sản phẩm</h3>
    <table border="1">
      <tr>
        <th>Tên SP</th>
        <th>Số lượng</th>
        <th>Giá</th>
      </tr>
      <tr v-for="c in chiTiet" :key="c.id">
        <td>{{ c.sanPham?.tenSP }}</td>
        <td>{{ c.soLuong }}</td>
        <td>{{ c.gia }}</td>
      </tr>
    </table>
  </div>
</template>