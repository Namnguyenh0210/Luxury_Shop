package com.example.projectend.controller.admin;

import com.example.projectend.entity.BinhLuan;
import com.example.projectend.repository.BinhLuanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("/api/admin/binh-luan")
public class AdminBinhLuanController {

    @Autowired
    private BinhLuanRepository binhLuanRepository;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @GetMapping
    public ResponseEntity<Map<String, Object>> getTatCaBinhLuan(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Boolean trangThai,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Map<String, Object> response = new HashMap<>();
        try {
            Page<BinhLuan> binhLuanPage = binhLuanRepository.searchBinhLuanAdmin(
                    (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null,
                    trangThai,
                    PageRequest.of(page, size)
            );

            List<Map<String, Object>> danhSach = new ArrayList<>();
            for(BinhLuan bl : binhLuanPage.getContent()) {
                Map<String, Object> dto = new HashMap<>();
                dto.put("maBL", bl.getMaBL());
                dto.put("noiDung", bl.getNoiDung());
                dto.put("ngayBinhLuan", bl.getNgayBinhLuan() != null ? bl.getNgayBinhLuan().format(FMT) : "");
                dto.put("trangThai", bl.getTrangThai());
                dto.put("phanHoiAdmin", bl.getPhanHoiAdmin());
                dto.put("ngayPhanHoiAdmin", bl.getNgayPhanHoiAdmin() != null ? bl.getNgayPhanHoiAdmin().format(FMT) : null);
                dto.put("reportCount", bl.getReportCount());

                if(bl.getTaiKhoan() != null) {
                    dto.put("tenNguoiDung", bl.getTaiKhoan().getHoTen());
                    dto.put("email", bl.getTaiKhoan().getEmail());
                } else {
                    dto.put("tenNguoiDung", "Khách");
                }

                if(bl.getBaiViet() != null) {
                    dto.put("tieuDe", bl.getBaiViet().getTieuDe());
                } else {
                    dto.put("tieuDe", "Bài viết không xác định");
                }
                
                danhSach.add(dto);
            }

            response.put("thanhCong", true);
            response.put("danhSach", danhSach);
            response.put("tongSo", binhLuanPage.getTotalElements());
            response.put("tongTrang", binhLuanPage.getTotalPages());
            
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Map<String, Object>> updateTrangThai(@PathVariable Long id, @RequestBody Map<String, Boolean> body) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<BinhLuan> opt = binhLuanRepository.findById(id);
            if(opt.isPresent()) {
                BinhLuan bl = opt.get();
                bl.setTrangThai(body.get("trangThai"));
                binhLuanRepository.save(bl);
                response.put("thanhCong", true);
                response.put("thongBao", "Cập nhật trạng thái thành công");
            } else {
                response.put("thanhCong", false);
                response.put("thongBao", "Không tìm thấy bình luận");
            }
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{id}/reply")
    public ResponseEntity<Map<String, Object>> replyBinhLuan(@PathVariable Long id, @RequestBody Map<String, String> body) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<BinhLuan> opt = binhLuanRepository.findById(id);
            if(opt.isPresent()) {
                BinhLuan bl = opt.get();
                bl.setPhanHoiAdmin(body.get("phanHoiAdmin"));
                bl.setNgayPhanHoiAdmin(LocalDateTime.now());
                binhLuanRepository.save(bl);
                response.put("thanhCong", true);
                response.put("thongBao", "Đã phản hồi bình luận");
            } else {
                response.put("thanhCong", false);
                response.put("thongBao", "Không tìm thấy bình luận");
            }
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> xoaBinhLuan(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            binhLuanRepository.deleteById(id);
            response.put("thanhCong", true);
            response.put("thongBao", "Xóa bình luận thành công");
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi xóa bình luận: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Object[]> queryResult = binhLuanRepository.getTopBlogsByComments();
            List<Map<String, Object>> topBlogs = new ArrayList<>();
            
            for(int i = 0; i < Math.min(queryResult.size(), 10); i++) {
                Map<String, Object> m = new HashMap<>();
                m.put("tieuDe", queryResult.get(i)[0]);
                m.put("tongBL", queryResult.get(i)[1]);
                topBlogs.add(m);
            }

            response.put("thanhCong", true);
            response.put("topBlogs", topBlogs);
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }
}
