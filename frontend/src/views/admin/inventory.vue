<template>
  <div v-if="modelValue"
       class="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4">

    <div class="bg-white w-full max-w-6xl rounded-xl shadow-xl max-h-[90vh] overflow-y-auto">

      <!-- HEADER -->
      <div class="px-6 py-4 border-b flex justify-between items-center">
        <h2 class="text-lg font-bold">Tạo Phiếu Nhập Kho</h2>
        <button @click="close">✕</button>
      </div>

      <!-- BODY -->
      <div class="p-6 space-y-6">

        <!-- Thông tin chung -->
        <div class="grid grid-cols-2 gap-4 bg-gray-50 p-4 rounded-lg">

          <div>
            <label class="text-sm font-semibold">Nhà Cung Cấp *</label>
            <select v-model="form.maNCC"
                    class="w-full border rounded p-2">
              <option value="">-- Chọn NCC --</option>
              <option v-for="ncc in suppliers"
                      :key="ncc.maNCC"
                      :value="ncc.maNCC">
                {{ ncc.tenNCC }}
              </option>
            </select>
          </div>

          <div>
            <label class="text-sm font-semibold">Ghi chú</label>
            <input v-model="form.ghiChu"
                   class="w-full border rounded p-2"/>
          </div>

        </div>

        <!-- Thêm sản phẩm -->
        <div class="flex gap-3">

          <select v-model="newItem.productId"
                  class="border rounded p-2 flex-1">
            <option value="">-- Sản phẩm --</option>
            <option v-for="p in products"
                    :key="p.id"
                    :value="p.id">
              {{ p.tenSP }}
            </option>
          </select>

          <input v-model="newItem.size"
                 placeholder="Size"
                 class="border rounded p-2 w-24"/>

          <input v-model="newItem.color"
                 placeholder="Màu"
                 class="border rounded p-2 w-28"/>

          <input type="number"
                 v-model.number="newItem.qty"
                 placeholder="SL"
                 class="border rounded p-2 w-20"/>

          <input type="number"
                 v-model.number="newItem.price"
                 placeholder="Giá"
                 class="border rounded p-2 w-28"/>

          <button @click="addItem"
                  class="bg-blue-600 text-white px-4 rounded">
            Thêm
          </button>

        </div>

        <!-- Bảng sản phẩm -->
        <table class="w-full border text-sm">
          <thead class="bg-gray-100">
          <tr>
            <th>#</th>
            <th>Sản phẩm</th>
            <th>Size</th>
            <th>Màu</th>
            <th>SL</th>
            <th>Giá</th>
            <th>Thành tiền</th>
            <th></th>
          </tr>
          </thead>

          <tbody>
          <tr v-for="(item,index) in form.items"
              :key="index">
            <td>{{ index + 1 }}</td>
            <td>{{ getProductName(item.productId) }}</td>
            <td>{{ item.size }}</td>
            <td>{{ item.color }}</td>
            <td>{{ item.qty }}</td>
            <td>{{ formatCurrency(item.price) }}</td>
            <td>{{ formatCurrency(item.qty * item.price) }}</td>
            <td>
              <button @click="removeItem(index)"
                      class="text-red-600">
                X
              </button>
            </td>
          </tr>

          <tr v-if="form.items.length === 0">
            <td colspan="8" class="text-center py-4 text-gray-400">
              Chưa có sản phẩm
            </td>
          </tr>
          </tbody>
        </table>

        <!-- Footer -->
        <div class="flex justify-between items-center pt-4 border-t">
          <div class="font-bold text-lg">
            Tổng tiền: {{ formatCurrency(totalAmount) }}
          </div>

          <div class="flex gap-3">
            <button @click="close"
                    class="px-4 py-2 border rounded">
              Hủy
            </button>

            <button @click="submit"
                    class="px-4 py-2 bg-green-600 text-white rounded">
              Lưu Phiếu
            </button>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios"

export default {
  name: "ImportModal",

  props: {
    modelValue: Boolean,
    suppliers: Array,
    products: Array
  },

  emits: ["update:modelValue", "success"],

  data() {
    return {
      form: {
        maNCC: "",
        ghiChu: "",
        items: []
      },
      newItem: {
        productId: "",
        size: "",
        color: "",
        qty: 1,
        price: 0
      }
    }
  },

  computed: {
    totalAmount() {
      return this.form.items.reduce(
          (sum, i) => sum + i.qty * i.price,
          0
      )
    }
  },

  methods: {

    close() {
      this.$emit("update:modelValue", false)
      this.resetForm()
    },

    resetForm() {
      this.form = {
        maNCC: "",
        ghiChu: "",
        items: []
      }
    },

    addItem() {
      if (!this.newItem.productId) {
        alert("Chọn sản phẩm")
        return
      }

      this.form.items.push({ ...this.newItem })

      this.newItem = {
        productId: "",
        size: "",
        color: "",
        qty: 1,
        price: 0
      }
    },

    removeItem(index) {
      this.form.items.splice(index, 1)
    },

    getProductName(id) {
      const p = this.products.find(x => x.id === id)
      return p ? p.tenSP : ""
    },

    formatCurrency(value) {
      return new Intl.NumberFormat("vi-VN", {
        style: "currency",
        currency: "VND"
      }).format(value || 0)
    },

    async submit() {

      if (!this.form.maNCC) {
        alert("Chọn nhà cung cấp")
        return
      }

      if (this.form.items.length === 0) {
        alert("Thêm ít nhất 1 sản phẩm")
        return
      }

      try {
        await axios.post(
            "http://localhost:8080/admin/inventory/import",
            this.form,
            { withCredentials: true }
        )

        alert("Tạo phiếu thành công")
        this.$emit("success")
        this.close()

      } catch (err) {
        console.error(err)
        alert("Lỗi khi lưu")
      }
    }
  }
}
</script>