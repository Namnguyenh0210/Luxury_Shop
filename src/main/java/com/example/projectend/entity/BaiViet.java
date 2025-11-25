package com.example.projectend.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

/**
 * ENTITY BÀI VIẾT - ASM Web Bán Hàng Tết
 * Quản lý bài viết kiến thức cho website
 * <p>
 * PHÂN CÔNG:
 * - THÀNH VIÊN 1: Mapping gốc (ĐÃ HOÀN THÀNH)
 * - THÀNH VIÊN 3: Hiển thị bài viết phía khách (list, detail, search, featured)
 * - THÀNH VIÊN 4: CRUD quản trị (toggleStatus, thêm/sửa/xóa)
 * <p>
 * TODO THÀNH VIÊN 3 (Optional): Viết DTO rút gọn (id, tieuDe, ngayDang) cho quick list
 * TODO THÀNH VIÊN 4 (Optional): Thêm field SEO (MetaTitle) nếu mở rộng (KHÔNG sửa schema hiện tại theo yêu cầu đề bài)
 */
@Entity
@Table(name = "BaiViet")
public class BaiViet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaBV")
    private Long maBV; // đổi Integer -> Long

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaTK", nullable = false)
    private TaiKhoan taiKhoan; // Người đăng (Admin/Nhân viên)

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaLoaiBV")
    private LoaiBaiViet loaiBaiViet; // mới theo db.sql

    @Column(name = "TieuDe", length = 255)
    private String tieuDe;

    @Column(name = "NoiDung", columnDefinition = "NVARCHAR(MAX)")
    private String noiDung;

    @Column(name = "HinhAnh", length = 255)
    private String hinhAnh;

    @Column(name = "LuotXem")
    private Integer luotXem = 0; // thêm theo db.sql

    @Column(name = "TrangThai")
    private Boolean trangThai = true; // BIT: true=Hiển thị, false=Ẩn

    @Column(name = "Slug", length = 255, unique = true)
    private String slug; // SEO đường dẫn

    @Column(name = "NgayDang")
    private LocalDateTime ngayDang = LocalDateTime.now();

    // Constructors
    public BaiViet() {
    }

    public BaiViet(TaiKhoan taiKhoan, String tieuDe, String noiDung, String hinhAnh) {
        this.taiKhoan = taiKhoan;
        this.tieuDe = tieuDe;
        this.noiDung = noiDung;
        this.hinhAnh = hinhAnh;
    }

    // Getters & Setters
    public Long getMaBV() { return maBV; }
    public void setMaBV(Long maBV) { this.maBV = maBV; }

    public TaiKhoan getTaiKhoan() { return taiKhoan; }
    public void setTaiKhoan(TaiKhoan taiKhoan) { this.taiKhoan = taiKhoan; }

    public LoaiBaiViet getLoaiBaiViet() { return loaiBaiViet; }
    public void setLoaiBaiViet(LoaiBaiViet loaiBaiViet) { this.loaiBaiViet = loaiBaiViet; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public Integer getLuotXem() { return luotXem; }
    public void setLuotXem(Integer luotXem) { this.luotXem = luotXem; }

    public Boolean getTrangThai() { return trangThai; }
    public void setTrangThai(Boolean trangThai) { this.trangThai = trangThai; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public LocalDateTime getNgayDang() { return ngayDang; }
    public void setNgayDang(LocalDateTime ngayDang) { this.ngayDang = ngayDang; }

    // Convenience / backward compatibility
    public Long getId() { return maBV; }
    public LocalDateTime getNgayTao() { return ngayDang; }

    public String getTrangThaiText() { return Boolean.TRUE.equals(trangThai) ? "Hiển thị" : "Ẩn"; }

    /**
     * Lấy tóm tắt bài viết (200 ký tự đầu tiên từ nội dung)
     */
    public String getTomTat() {
        if (noiDung == null || noiDung.isEmpty()) {
            return "";
        }
        // Remove HTML tags for summary
        String cleanText = noiDung.replaceAll("<[^>]*>", "");
        if (cleanText.length() <= 200) {
            return cleanText;
        }
        return cleanText.substring(0, 200) + "...";
    }

    @Override
    public String toString() {
        return "BaiViet{" +
                "maBV=" + maBV +
                ", tieuDe='" + tieuDe + '\'' +
                ", trangThai=" + trangThai +
                '}';
    }
}
