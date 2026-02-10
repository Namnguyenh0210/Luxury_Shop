<template>

<div layout:fragment="content">
    <main class="payment-container">
        <!-- Header -->
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold mb-4">💳 Thanh toán qua PayOS</h1>
            <p class="text-gray-600">Quét mã QR bên dưới để thanh toán đơn hàng</p>
        </div>

        <!-- Thông tin đơn hàng -->
        <div class="payment-info">
            <h3 class="text-xl font-bold mb-4">📋 Thông tin đơn hàng</h3>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <p class="text-sm text-gray-600">Mã đơn hàng:</p>
                    <p class="font-bold text-lg">'#' + {{ orderCode }}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Số tiền thanh toán:</p>
                    <p class="font-bold text-lg text-red-600">{{ #numbers.formatDecimal(amount, 0, 'COMMA', 0, 'POINT') }} + ' VNĐ'</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Trạng thái:</p>
                    <span class="status-badge status-pending" id="paymentStatus">⏳ Chờ thanh toán</span>
                </div>
                <div v-if="donHang">
                    <p class="text-sm text-gray-600">Khách hàng:</p>
                    <p class="font-medium">{{ donHang.taiKhoan?.hoTen }}</p>
                </div>
            </div>
        </div>

        <!-- QR Code -->
        <div class="qr-container">
            <h3 class="text-xl font-bold mb-4">📱 Quét mã QR để thanh toán</h3>

            <!-- Hiển thị QR Code nếu có -->
            <div class="qr-code" v-if="qrCode">
                <img alt="QR Code PayOS" style="width: 100%; max-width: 300px;" src="${qrCode}">
            </div>

            <!-- Hoặc hiển thị nút chuyển đến trang thanh toán -->
            <div v-if="!(qrCode)">
                <p class="mb-4">Nhấn nút bên dưới để mở trang thanh toán PayOS</p>
                <a target="_blank" class="inline-block bg-blue-600 text-white px-8 py-3 rounded-lg font-bold hover:bg-blue-700 transition" href="${checkoutUrl}">
                    🔗 Mở trang thanh toán
                </a>
            </div>

            <div class="mt-6">
                <p class="text-sm text-gray-600 mb-2">
                    ✅ Mở ứng dụng ngân hàng trên điện thoại<br>
                    ✅ Quét mã QR hoặc nhấn vào link<br>
                    ✅ Xác nhận thanh toán
                </p>
                <div class="countdown" id="countdown">
                    ⏱️ Thời gian còn lại: <span id="timeLeft">14:52</span>
                </div>
            </div>
        </div>

        <!-- Hướng dẫn -->
        <div class="bg-blue-50 p-4 rounded-lg mb-6">
            <h4 class="font-bold mb-2">💡 Hướng dẫn thanh toán:</h4>
            <ol class="list-decimal list-inside space-y-2 text-sm">
                <li>Mở ứng dụng ngân hàng trên điện thoại (Momo, ZaloPay, Banking app...)</li>
                <li>Chọn chức năng "Quét mã QR" hoặc "Chuyển khoản"</li>
                <li>Quét mã QR code hiển thị bên trên</li>
                <li>Kiểm tra thông tin và xác nhận thanh toán</li>
                <li>Hệ thống sẽ tự động cập nhật khi thanh toán thành công</li>
            </ol>
        </div>

        <!-- ✅ CẢI THIỆN: Nút hành động đa dạng -->
        <div class="action-buttons">
            <button onclick="checkPaymentStatus()" class="bg-green-600 text-white px-6 py-3 rounded-lg font-bold hover:bg-green-700 transition">
                🔄 Kiểm tra thanh toán
            </button>
            <a class="bg-gray-600 text-white px-6 py-3 rounded-lg font-bold hover:bg-gray-700 transition inline-block" href="/profile#orders">
                📋 Xem đơn hàng
            </a>
        </div>

        <!-- ✅ THÊM: Thông báo khi hết hạn hoặc bị hủy -->
        <div id="expiredMessage" class="mt-6 p-4 bg-red-50 border border-red-300 rounded-lg hidden">
            <h4 class="font-bold text-red-700 mb-2">⚠️ Hết thời gian thanh toán</h4>
            <p class="text-sm text-red-600 mb-4">Link thanh toán đã hết hạn. Vui lòng tạo lại đơn hàng hoặc quay lại trang đơn hàng để tiếp tục.</p>
            <div class="flex gap-3">
                <a class="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-bold hover:bg-blue-700" href="/profile#orders">
                    📋 Xem đơn hàng của tôi
                </a>
            </div>
        </div>
    </main>

    <!-- JavaScript để tự động kiểm tra trạng thái -->
    <script>
        /*<![CDATA[*/
        const orderCode = /*[[${orderCode}]]*/ null;
        const checkInterval = 5000; // Kiểm tra mỗi 5 giây
        let checkTimer;
        let countdownTimer;
        let timeLeft = 15 * 60; // 15 phút

        // Hàm kiểm tra trạng thái thanh toán
        function checkPaymentStatus() {
            fetch(`/payment/payos/check/${orderCode}`)
                .then(response => response.json())
                .then(data => {
                    console.log('✅ Payment status:', data);

                    if (data.success) {
                        const status = data.status;
                        const statusElement = document.getElementById('paymentStatus');

                        if (status === 'PAID') {
                            // Thanh toán thành công
                            statusElement.className = 'status-badge status-paid';
                            statusElement.textContent = '✅ Đã thanh toán';

                            // Dừng timer
                            clearInterval(checkTimer);
                            clearInterval(countdownTimer);

                            // Thông báo và chuyển trang
                            if (typeof showToast === 'function') {
                                showToast('success', 'Thanh toán thành công!', 'Cảm ơn bạn đã mua hàng. Đang chuyển trang...');
                            } else {
                                alert('✅ Thanh toán thành công! Cảm ơn bạn đã mua hàng.');
                            }

                            setTimeout(() => {
                                window.location.href = `/checkout/success?orderId=${orderCode}`;
                            }, 2000);

                        } else if (status === 'CANCELLED') {
                            // Thanh toán bị hủy
                            statusElement.className = 'status-badge status-cancelled';
                            statusElement.textContent = '❌ Đã hủy';
                            clearInterval(checkTimer);
                            clearInterval(countdownTimer);

                            if (typeof showToast === 'function') {
                                showToast('error', 'Thanh toán bị hủy', 'Bạn có thể quay lại trang đơn hàng để tiếp tục thanh toán.');
                            } else {
                                alert('❌ Thanh toán đã bị hủy. Vui lòng thử lại từ trang đơn hàng.');
                            }

                        } else if (status === 'PENDING') {
                            // Vẫn đang chờ
                            statusElement.className = 'status-badge status-pending';
                            statusElement.textContent = '⏳ Chờ thanh toán';
                        }
                    }
                })
                .catch(error => {
                    console.error('❌ Error checking payment status:', error);
                });
        }

        // Hàm đếm ngược thời gian
        function updateCountdown() {
            if (timeLeft <= 0) {
                clearInterval(countdownTimer);
                clearInterval(checkTimer);
                document.getElementById('timeLeft').textContent = 'Hết hạn';
                document.getElementById('expiredMessage').classList.remove('hidden');

                const statusElement = document.getElementById('paymentStatus');
                statusElement.className = 'status-badge status-cancelled';
                statusElement.textContent = '⏱️ Hết hạn';

                if (typeof showToast === 'function') {
                    showToast('error', 'Hết thời gian', 'Link thanh toán đã hết hạn. Vui lòng vào trang đơn hàng để tiếp tục.');
                }
                return;
            }

            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            document.getElementById('timeLeft').textContent =
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

            timeLeft--;
        }

        // Tự động kiểm tra trạng thái mỗi 5 giây
        if (orderCode) {
            checkTimer = setInterval(checkPaymentStatus, checkInterval);
            countdownTimer = setInterval(updateCountdown, 1000);

            // Kiểm tra ngay lập tức khi load trang
            checkPaymentStatus();
        }

        // Dừng timer khi rời khỏi trang
        window.addEventListener('beforeunload', function() {
            clearInterval(checkTimer);
            clearInterval(countdownTimer);
        });
        /*]]>*/
    </script>
</div>



</template>

<script>
export default {
  name: 'Pay',
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
