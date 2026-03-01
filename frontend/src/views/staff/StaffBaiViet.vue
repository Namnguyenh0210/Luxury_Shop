<script setup>
import { ref, onMounted } from "vue";
import axios from "@/axios";

const posts = ref([]);
const page = ref(0);
const totalPages = ref(0);

const loadData = async () => {
  const res = await axios.get("/staff/baiviet", {
    params: { page: page.value }
  });

  posts.value = res.data.content;
  totalPages.value = res.data.totalPages;
};

const deletePost = async (id) => {
  if (!confirm("Xóa bài viết?")) return;
  await axios.delete(`/staff/baiviet/${id}`);
  loadData();
};

onMounted(loadData);
</script>

<template>
  <div>
    <h2>Quản lý bài viết</h2>

    <router-link to="/staff/baiviet/create">
      <button>Tạo bài viết</button>
    </router-link>

    <table border="1">
      <tr>
        <th>ID</th>
        <th>Tiêu đề</th>
        <th>Ngày đăng</th>
        <th>Hành động</th>
      </tr>
      <tr v-for="p in posts" :key="p.maBV">
        <td>{{ p.maBV }}</td>
        <td>{{ p.tieuDe }}</td>
        <td>{{ p.ngayDang }}</td>
        <td>
          <router-link :to="`/staff/baiviet/edit/${p.maBV}`">
            <button>Sửa</button>
          </router-link>
          <button @click="deletePost(p.maBV)">Xóa</button>
        </td>
      </tr>
    </table>
  </div>
</template>