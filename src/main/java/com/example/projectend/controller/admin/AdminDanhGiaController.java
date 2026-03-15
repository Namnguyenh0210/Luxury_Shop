package com.example.projectend.controller.admin;

import com.example.projectend.entity.DanhGia;
import com.example.projectend.repository.DanhGiaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("/api/admin/danh-gia")
public class AdminDanhGiaController {

    @Autowired
    private DanhGiaRepository danhGiaRepository;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @GetMapping
    public ResponseEntity<Map<String, Object>> getTatCaDanhGia(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer trangThai,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        Map<String, Object> response = new HashMap<>();
        try {
            Page<DanhGia> danhGiaPage = danhGiaRepository.searchDanhGiaAdmin(
                    (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null,
                    trangThai,
                    PageRequest.of(page, size)
            );

            List<Map<String, Object>> danhSach = new ArrayList<>();
            for(DanhGia dg : danhGiaPage.getContent()) {
                Map<String, Object> dto = new HashMap<>();
                dto.put("maDG", dg.getMaDG());
                dto.put("diem", dg.getDiem());
                dto.put("noiDung", dg.getNoiDung());
                dto.put("ngayDanhGia", dg.getNgayDanhGia() != null ? dg.getNgayDanhGia().format(FMT) : "");
                dto.put("trangThai", dg.getTrangThai());
                dto.put("phanHoi", dg.getPhanHoi());
                dto.put("ngayPhanHoi", dg.getNgayPhanHoi() != null ? dg.getNgayPhanHoi().format(FMT) : null);
                dto.put("reportCount", dg.getSoLuotBaoCao());

                if(dg.getTaiKhoan() != null) {
                    dto.put("tenNguoiDung", dg.getTaiKhoan().getHoTen());
                    dto.put("email", dg.getTaiKhoan().getEmail());
                } else {
                    dto.put("tenNguoiDung", "Khách");
                }

                if(dg.getDonHangChiTiet() != null && dg.getDonHangChiTiet().getSanPhamChiTiet() != null) {
                    dto.put("tenSP", dg.getDonHangChiTiet().getSanPhamChiTiet().getSanPham().getTenSP());
                } else {
                    dto.put("tenSP", "Sản phẩm không xác định");
                }
                
                danhSach.add(dto);
            }

            response.put("thanhCong", true);
            response.put("danhSach", danhSach);
            response.put("tongSo", danhGiaPage.getTotalElements());
            response.put("tongTrang", danhGiaPage.getTotalPages());
            
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Map<String, Object>> updateTrangThai(@PathVariable Long id, @RequestBody Map<String, Integer> body) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<DanhGia> opt = danhGiaRepository.findById(id);
            if(opt.isPresent()) {
                DanhGia dg = opt.get();
                dg.setTrangThai(body.get("trangThai"));
                danhGiaRepository.save(dg);
                response.put("thanhCong", true);
                response.put("thongBao", "Cập nhật trạng thái thành công");
            } else {
                response.put("thanhCong", false);
                response.put("thongBao", "Không tìm thấy đánh giá");
            }
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{id}/reply")
    public ResponseEntity<Map<String, Object>> replyDanhGia(@PathVariable Long id, @RequestBody Map<String, String> body) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<DanhGia> opt = danhGiaRepository.findById(id);
            if(opt.isPresent()) {
                DanhGia dg = opt.get();
                dg.setPhanHoi(body.get("phanHoi"));
                dg.setNgayPhanHoi(LocalDateTime.now());
                danhGiaRepository.save(dg);
                response.put("thanhCong", true);
                response.put("thongBao", "Đã phản hồi đánh giá");
            } else {
                response.put("thanhCong", false);
                response.put("thongBao", "Không tìm thấy đánh giá");
            }
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> xoaDanhGia(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            danhGiaRepository.deleteById(id);
            response.put("thanhCong", true);
            response.put("thongBao", "Xóa đánh giá thành công");
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", "Lỗi xóa đánh giá: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        Map<String, Object> response = new HashMap<>();
        try {
            List<Object[]> queryResult = danhGiaRepository.getTopProductsByRating();
            List<Map<String, Object>> topHigh = new ArrayList<>();
            List<Map<String, Object>> topLow = new ArrayList<>();
            
            for(int i = 0; i < queryResult.size(); i++) {
                if(i < 5) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("tenSP", queryResult.get(i)[0]);
                    m.put("diem", queryResult.get(i)[1]);
                    m.put("tongDG", queryResult.get(i)[2]);
                    topHigh.add(m);
                }
            }

            for(int i = queryResult.size() - 1; i >= Math.max(0, queryResult.size() - 5); i--) {
                Map<String, Object> m = new HashMap<>();
                m.put("tenSP", queryResult.get(i)[0]);
                m.put("diem", queryResult.get(i)[1]);
                m.put("tongDG", queryResult.get(i)[2]);
                topLow.add(m);
            }

            response.put("thanhCong", true);
            response.put("topHigh", topHigh);
            response.put("topLow", topLow);
        } catch (Exception e) {
            response.put("thanhCong", false);
            response.put("thongBao", e.getMessage());
        }
        return ResponseEntity.ok(response);
    }
}
