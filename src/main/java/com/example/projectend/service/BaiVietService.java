package com.example.projectend.service;

import com.example.projectend.entity.BaiViet;
import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.repository.BaiVietRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Service xử lý logic nghiệp vụ cho bài viết tin tức
 */
@Service
public class BaiVietService {

    @Autowired
    private BaiVietRepository baiVietRepository;

    private final String UPLOAD_DIR = "src/main/resources/static/images/";

    /**
     * Lấy tất cả bài viết đang hiển thị với phân trang
     */
    public Page<BaiViet> getAllBaiViet(Pageable pageable) {
        return baiVietRepository.findByTrangThaiOrderByNgayDangDesc(true, pageable);
    }

    /**
     * Tìm bài viết theo ID
     */
    public Optional<BaiViet> findById(Long id) {
        return baiVietRepository.findById(id);
    }

    /**
     * Tìm kiếm bài viết theo tiêu đề
     */
    public Page<BaiViet> searchBaiViet(String keyword, Pageable pageable) {
        return baiVietRepository.findByTieuDeContainingIgnoreCaseAndTrangThaiOrderByNgayDangDesc(keyword, true, pageable);
    }

    /**
     * Tìm kiếm bài viết theo tiêu đề (cho admin)
     */
    public Page<BaiViet> searchByTitle(String keyword, Pageable pageable) {
        return baiVietRepository.findByTieuDeContainingIgnoreCaseOrderByNgayDangDesc(keyword, pageable);
    }

    /**
     * Lấy bài viết nổi bật cho trang chủ
     */
    public List<BaiViet> getFeaturedPosts(int limit) {
        List<BaiViet> list = baiVietRepository.findTop3ByTrangThaiTrueOrderByNgayDangDesc();
        return list.size() <= limit ? list : list.subList(0, limit);
    }

    /**
     * Lấy bài viết theo người đăng
     */
    public Page<BaiViet> getBaiVietByAuthor(TaiKhoan taiKhoan, Pageable pageable) {
        return baiVietRepository.findByTaiKhoanAndTrangThaiOrderByNgayDangDesc(taiKhoan, true, pageable);
    }

    /**
     * Lấy bài viết theo người đăng (staff)
     */
    public Page<BaiViet> findByTacGia(TaiKhoan taiKhoan, Pageable pageable) {
        return baiVietRepository.findByTaiKhoanOrderByNgayDangDesc(taiKhoan, pageable);
    }

    /**
     * Tìm kiếm bài viết theo người đăng và từ khóa
     */
    public Page<BaiViet> searchByTacGiaAndKeyword(TaiKhoan taiKhoan, String keyword, Pageable pageable) {
        return baiVietRepository.findByTaiKhoanAndTieuDeContainingIgnoreCaseOrderByNgayDangDesc(taiKhoan, keyword, pageable);
    }

    /**
     * Đếm số bài viết đang hiển thị
     */
    public long countActivePosts() { return baiVietRepository.countByTrangThai(true); }

    /**
     * Đếm tất cả bài viết
     */
    public long countAll() { return baiVietRepository.count(); }

    /**
     * Lấy tất cả bài viết cho admin (bao gồm cả bài ẩn)
     */
    public Page<BaiViet> getAllBaiVietAdmin(Pageable pageable) { return baiVietRepository.findAll(pageable); }

    /**
     * Lưu hoặc cập nhật bài viết
     */
    public BaiViet save(BaiViet baiViet) { return baiVietRepository.save(baiViet); }

    /**
     * Tạo bài viết mới với upload ảnh
     */
    public BaiViet createBaiViet(BaiViet baiViet, MultipartFile hinhAnh) throws IOException {
        // Xử lý upload ảnh nếu có
        if (hinhAnh != null && !hinhAnh.isEmpty()) {
            baiViet.setHinhAnh(saveImage(hinhAnh));
        }

        // Set thông tin mặc định
        if (baiViet.getNgayDang() == null) {
            baiViet.setNgayDang(LocalDateTime.now());
        }
        if (baiViet.getTrangThai() == null) {
            baiViet.setTrangThai(true);
        }
        if (baiViet.getSlug() == null || baiViet.getSlug().isBlank()) {
            baiViet.setSlug(generateSlug(baiViet.getTieuDe()));
        }

        return baiVietRepository.save(baiViet);
    }

    /**
     * Cập nhật bài viết với upload ảnh
     */
    public BaiViet updateBaiViet(BaiViet baiViet, MultipartFile hinhAnh) throws IOException {
        // Xử lý upload ảnh mới nếu có
        if (hinhAnh != null && !hinhAnh.isEmpty()) {
            baiViet.setHinhAnh(saveImage(hinhAnh));
        }
        if (baiViet.getSlug() == null || baiViet.getSlug().isBlank()) {
            baiViet.setSlug(generateSlug(baiViet.getTieuDe()));
        }
        return baiVietRepository.save(baiViet);
    }

    /**
     * Bật/tắt trạng thái hiển thị bài viết
     */
    public void toggleStatus(Long id) {
        baiVietRepository.findById(id).ifPresent(bv -> {
            bv.setTrangThai(!Boolean.TRUE.equals(bv.getTrangThai()));
            baiVietRepository.save(bv);
        });
    }

    /**
     * Xóa bài viết theo ID
     */
    public void deleteById(Long id) { baiVietRepository.deleteById(id); }

    /**
     * Xóa bài viết (alias)
     */
    public void deleteBaiViet(Long id) {
        baiVietRepository.deleteById(id);
    }

    /**
     * Lưu file ảnh và trả về tên file
     */
    private String saveImage(MultipartFile file) throws IOException {
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
        Path uploadPath = Paths.get(UPLOAD_DIR);

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Files.copy(file.getInputStream(), uploadPath.resolve(fileName));

        return fileName;
    }

    private String generateSlug(String title) {
        if (title == null) return UUID.randomUUID().toString();
        String base = title.toLowerCase().replaceAll("[^a-z0-9\s]", "").replaceAll("\s+", "-");
        return base + "-" + UUID.randomUUID().toString().substring(0,8);
    }
}
