package com.example.projectend.service;

import com.example.projectend.entity.DonHang;
import com.example.projectend.entity.SanPham;
import com.example.projectend.entity.SanPhamChiTiet;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import okhttp3.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

@Service
public class GroqService {

    private static final Logger logger = LoggerFactory.getLogger(GroqService.class);

    @Value("${groq.api-key}")
    private String groqApiKey;

    @Value("${groq.api-url}")
    private String groqApiUrl;

    @Value("${groq.model}")
    private String groqModel;

    private final OkHttpClient httpClient = new OkHttpClient();

    private static final String SYSTEM_PROMPT = """
            Bạn là trợ lý ảo bán hàng của Luxury Fashion Shop (Cửa hàng thời trang cao cấp chuyên bán Gucci, Chanel, MLB...).
            
            QUY TẮC PHỤC VỤ & TRÌNH BÀY (TỐI ƯU):
            1. TÔNG GIỌNG: Lịch sự, chuyên nghiệp, tinh tế. Trình bày THOÁNG ĐẠT, dễ nhìn.
            2. FORMATTING: 
               - Sử dụng Markdown cơ bản (### cho tên sản phẩm, **In đậm** cho giá tiền).
               - HẠN CHẾ Icon (chỉ dùng tối đa 1-2 icon/tin nhắn để không bị rối).
               - Mỗi sản phẩm phải được cách nhau bằng một dòng trắng.
            3. HÌNH ẢNH: 
               - TUYỆT ĐỐI KHÔNG hiển thị hình ảnh hoặc đường dẫn ảnh trong câu trả lời. 
               - Hãy tập trung mô tả vẻ đẹp và phong cách của sản phẩm bằng lời văn tinh tế.
            4. THÔNG TIN CHÍNH XÁC: Chỉ trả lời dựa trên context được cung cấp.
            5. Nếu không có sản phẩm phù hợp trong danh sách, hãy nói "Hiện tại shop không tìm thấy sản phẩm này" và gợi ý sang sản phẩm khác tương tự.
            6. Nếu khách hỏi khiếu nại hoặc vấn đề phức tạp, hãy khuyên họ sử dụng nút "Chat với nhân viên" để được hỗ trợ tốt nhất.
            """;

    /**
     * Gọi API Groq để sinh câu trả lời
     */
    public String generateResponse(String userMessage, String context) {
        String systemMessage = buildSystemMessage(context);

        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model", groqModel);

        JsonArray messages = new JsonArray();

        JsonObject sysMsg = new JsonObject();
        sysMsg.addProperty("role", "system");
        sysMsg.addProperty("content", systemMessage);
        messages.add(sysMsg);

        JsonObject usrMsg = new JsonObject();
        usrMsg.addProperty("role", "user");
        usrMsg.addProperty("content", userMessage);
        messages.add(usrMsg);

        requestBody.add("messages", messages);

        RequestBody body = RequestBody.create(
                requestBody.toString(),
                MediaType.parse("application/json; charset=utf-8"));

        Request request = new Request.Builder()
                .url(groqApiUrl)
                .post(body)
                .addHeader("Content-Type", "application/json")
                .addHeader("Authorization", "Bearer " + groqApiKey)
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            String responseBody = response.body().string();
            if (response.isSuccessful()) {
                return parseGroqResponse(responseBody);
            } else {
                logger.error("Lỗi từ Groq API: " + response.code() + " - " + responseBody);
                return "Xin lỗi, hiện tại tôi đang gặp sự cố kết nối. Vui lòng thử lại sau hoặc chat với nhân viên.";
            }
        } catch (IOException e) {
            logger.error("Lỗi khi kết nối Groq API: ", e);
            return "Xin lỗi, hệ thống đang gặp lỗi. Vui lòng liên hệ nhân viên.";
        }
    }

    private String buildSystemMessage(String context) {
        StringBuilder promptArgs = new StringBuilder();
        promptArgs.append(SYSTEM_PROMPT).append("\n\n");
        if (context != null && !context.isBlank()) {
            promptArgs.append(context).append("\n\n");
        }
        return promptArgs.toString();
    }

    private String parseGroqResponse(String responseBody) {
        try {
            JsonObject jsonObject = JsonParser.parseString(responseBody).getAsJsonObject();
            JsonArray choices = jsonObject.getAsJsonArray("choices");
            if (choices != null && choices.size() > 0) {
                JsonObject message = choices.get(0).getAsJsonObject().getAsJsonObject("message");
                if (message != null) {
                    return message.get("content").getAsString();
                }
            }
            return "Lỗi phân tích phản hồi từ AI.";
        } catch (Exception e) {
            logger.error("Lỗi parse Json: ", e);
            return "Không thể đọc phản hồi từ hệ thống.";
        }
    }

    /**
     * Tạo context chứa thông tin sản phẩm (Kèm ảnh)
     */
    public String buildProductContext(List<SanPham> products) {
        if (products == null || products.isEmpty())
            return "";

        StringBuilder context = new StringBuilder("DANH MỤC SẢN PHẨM KHẢ DỤNG (Yêu cầu AI chèn ảnh nếu có):\n");
        for (SanPham sp : products) {
            context.append("### ").append(sp.getTenSP()).append("\n");
            
            if (sp.getThuongHieu() != null) {
                context.append("- Thương hiệu: ").append(sp.getThuongHieu().getTenTH()).append("\n");
            }
            
            if (sp.getVariants() != null && !sp.getVariants().isEmpty()) {
                context.append("- Phân loại: ");
                for (SanPhamChiTiet variant : sp.getVariants()) {
                    context.append("[Size: ").append(variant.getSizeSP() != null ? variant.getSizeSP().getTenSize() : "N/A")
                           .append(", Giá: ").append(String.format("%,.0f VNĐ", variant.getGiaBan().doubleValue()))
                           .append("] ");
                }
                context.append("\n");
            } else {
                context.append("- (Chưa có thông tin phân loại)\n");
            }
            context.append("\n");
        }
        return context.toString();
    }

    /**
     * Tạo context chứa thông tin đơn hàng của khách
     */
    public String buildOrderContext(List<DonHang> orders) {
        if (orders == null || orders.isEmpty())
            return "THÔNG BÁO: KHÁCH HÀNG HIỆN CHƯA CÓ LỊCH SỬ GIAO DỊCH TRONG HỆ THỐNG.";

        StringBuilder context = new StringBuilder("DANH SÁCH CÁC KIỆT TÁC KHÁCH HÀNG ĐÃ SỞ HỮU (Dữ liệu hệ thống):\n");
        for (DonHang dh : orders) {
            context.append("-----------------------------\n")
                    .append("• Mã định danh: #").append(dh.getMaDH()).append("\n")
                    .append("• Khởi tạo ngày: ").append(dh.getNgayDat()).append("\n")
                    .append("• Trạng thái vận hành: ").append(dh.getTrangThaiDHText()).append("\n")
                    .append("• Tình trạng thanh toán: ").append(dh.getTrangThaiThanhToanText()).append("\n")
                    .append("• Giá trị vật phẩm: ").append(String.format("%,.0f VNĐ", dh.getTongTien().doubleValue()))
                    .append("\n");
        }
        return context.toString();
    }
}
