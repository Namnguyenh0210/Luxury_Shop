package com.example.projectend.controller.staff;

import com.example.projectend.entity.BaiViet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.service.BaiVietService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/staff/baiviet")
@PreAuthorize("hasRole('Nhân viên')")
@CrossOrigin(origins = "http://localhost:5173")
public class StaffBaiVietController {

    @Autowired
    private BaiVietService baiVietService;

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    // =============================
    // 1. Danh sách bài viết
    // =============================
    @GetMapping
    public Page<BaiViet> danhSach(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            Authentication auth) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("ngayDang").descending());

        String email = auth.getName();
        TaiKhoan currentUser = taiKhoanRepository.findByEmail(email).orElse(null);

        if (keyword != null && !keyword.trim().isEmpty()) {
            return baiVietService.searchByTacGiaAndKeyword(currentUser, keyword, pageable);
        }

        return baiVietService.findByTacGia(currentUser, pageable);
    }

    // =============================
    // 2. Lấy chi tiết bài viết
    // =============================
    @GetMapping("/{id}")
    public BaiViet chiTiet(@PathVariable Long id) {
        return baiVietService.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài viết"));
    }

    // =============================
    // 3. Tạo bài viết
    // =============================
    @PostMapping
    public Map<String, String> tao(
            @RequestPart("baiViet") BaiViet baiViet,
            @RequestPart(value = "imageFile", required = false) MultipartFile imageFile,
            Authentication auth) throws Exception {

        String email = auth.getName();
        TaiKhoan currentUser = taiKhoanRepository.findByEmail(email).orElse(null);

        baiViet.setTaiKhoan(currentUser);
        baiVietService.createBaiViet(baiViet, imageFile);

        Map<String, String> res = new HashMap<>();
        res.put("message", "Tạo bài viết thành công");
        return res;
    }

    // =============================
    // 4. Cập nhật
    // =============================
    @PutMapping("/{id}")
    public Map<String, String> sua(
            @PathVariable Long id,
            @RequestPart("baiViet") BaiViet baiViet,
            @RequestPart(value = "imageFile", required = false) MultipartFile imageFile,
            Authentication auth) throws Exception {

        String email = auth.getName();
        TaiKhoan currentUser = taiKhoanRepository.findByEmail(email).orElse(null);

        baiViet.setMaBV(id);
        baiViet.setTaiKhoan(currentUser);

        baiVietService.updateBaiViet(baiViet, imageFile);

        Map<String, String> res = new HashMap<>();
        res.put("message", "Cập nhật thành công");
        return res;
    }

    // =============================
    // 5. Xóa
    // =============================
    @DeleteMapping("/{id}")
    public Map<String, String> xoa(@PathVariable Long id) {

        baiVietService.deleteBaiViet(id);

        Map<String, String> res = new HashMap<>();
        res.put("message", "Xóa thành công");
        return res;
    }
}