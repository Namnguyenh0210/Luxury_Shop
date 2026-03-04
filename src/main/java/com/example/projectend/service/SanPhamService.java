package com.example.projectend.service;

import com.example.projectend.entity.LoaiSanPham;
import com.example.projectend.entity.SanPham;
//import com.example.projectend.entity.KhuyenMai;
import com.example.projectend.repository.LoaiSanPhamRepository;
import com.example.projectend.repository.SanPhamRepository;
import com.example.projectend.repository.SanPhamChiTietRepository;
//import com.example.projectend.repository.KhuyenMaiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service xử lý logic nghiệp vụ cho sản phẩm - LUXURY FASHION
 */
@Service
public class SanPhamService {

    @Autowired
    private SanPhamRepository sanPhamRepository;

    @Autowired
    private LoaiSanPhamRepository loaiSanPhamRepository;

    @Autowired
    private SanPhamChiTietRepository sanPhamChiTietRepository;

//    @Autowired
//    private KhuyenMaiRepository khuyenMaiRepository;

    /**
     * Lấy danh sách sản phẩm nổi bật cho trang chủ
     */
    public List<SanPham> getFeaturedProducts(int limit) {
        return sanPhamRepository.findTop8ByOrderByNgayTaoDesc();
    }

    /**
     * Lấy tất cả sản phẩm đang bán
     */
    public List<SanPham> getAllActiveSanPham() {
        return sanPhamRepository.findByTrangThaiSP(1);
    }

    /**
     * Lấy giá thấp nhất của sản phẩm từ các biến thể
     */
    public BigDecimal getMinPrice(Long maSP) {
        BigDecimal price = sanPhamChiTietRepository.findMinPriceBySanPham(maSP);
        return price != null ? price : BigDecimal.ZERO;
    }

    /**
     * Lấy giá cao nhất của sản phẩm từ các biến thể
     */
    public BigDecimal getMaxPrice(Long maSP) {
        BigDecimal price = sanPhamChiTietRepository.findMaxPriceBySanPham(maSP);
        return price != null ? price : BigDecimal.ZERO;
    }

    /**
     * Lấy tổng tồn kho của sản phẩm
     */
    public Integer getTotalStock(Long maSP) {
        Integer stock = sanPhamChiTietRepository.findTotalStockBySanPham(maSP);
        return stock != null ? stock : 0;
    }

    /**
     * Lấy sản phẩm theo ID
     */
    public Optional<SanPham> findById(Long id) {
        return sanPhamRepository.findById(id);
    }

    /**
     * Lấy tất cả danh mục
     */
    public List<LoaiSanPham> getAllCategories() {
        return loaiSanPhamRepository.findAll();
    }

    /**
     * Lấy sản phẩm theo loại
     */
    public List<SanPham> findByLoai(Long maLoai) {
        return sanPhamRepository.findByLoaiSanPham_MaLoaiAndTrangThaiSP(maLoai, 1);
    }

    /**
     * Tìm kiếm sản phẩm với phân trang và bộ lọc đầy đủ - CẢI THIỆN SORT THEO MINPRICE
     */
    public Page<SanPham> findWithFilters(String search, Integer loaiId, Integer gioiTinh, Long thuongHieuId,
                                         BigDecimal minPrice, BigDecimal maxPrice,
                                         String sort, Pageable pageable) {
        Specification<SanPham> spec = Specification.where(null);

        spec = spec.and((root, query, cb) -> cb.equal(root.get("trangThaiSP"), 1));

        if (search != null && !search.isEmpty()) {
            spec = spec.and((root, query, cb) -> cb.like(cb.lower(root.get("tenSP")), "%" + search.toLowerCase() + "%"));
        }
        if (loaiId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("loaiSanPham").get("maLoai"), loaiId));
        }
        if (gioiTinh != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("gioiTinh"), gioiTinh));
        }
        if (thuongHieuId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("thuongHieu").get("maTH"), thuongHieuId));
        }
        // Price filtering: product passes if EXISTS a variant with price within range
        if (minPrice != null || maxPrice != null) {
            BigDecimal finalMin = minPrice;
            BigDecimal finalMax = maxPrice;
            spec = spec.and((root, query, cb) -> {
                var sub = query.subquery(Long.class);
                var vRoot = sub.from(com.example.projectend.entity.SanPhamChiTiet.class);
                sub.select(cb.literal(1L));
                var predicate = cb.equal(vRoot.get("sanPham"), root);
                if (finalMin != null) {
                    predicate = cb.and(predicate, cb.greaterThanOrEqualTo(vRoot.get("giaBan"), finalMin));
                }
                if (finalMax != null) {
                    predicate = cb.and(predicate, cb.lessThanOrEqualTo(vRoot.get("giaBan"), finalMax));
                }
                sub.where(predicate);
                return cb.exists(sub);
            });
        }

        // IMPROVED SORTING: Sort by actual minPrice instead of date
        Sort sortObj;
        if ("gia-tang".equals(sort)) {
            // Sort by minimum price ascending - use native query approach
            Pageable sortedPageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
            Page<SanPham> result = sanPhamRepository.findAll(spec, sortedPageable);
            // Post-process to sort by minPrice
            List<SanPham> content = result.getContent();
            content.sort((a, b) -> {
                BigDecimal priceA = getMinPrice(a.getMaSP());
                BigDecimal priceB = getMinPrice(b.getMaSP());
                return priceA.compareTo(priceB);
            });
            return result;
        } else if ("gia-giam".equals(sort)) {
            // Sort by minimum price descending
            Pageable sortedPageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize());
            Page<SanPham> result = sanPhamRepository.findAll(spec, sortedPageable);
            // Post-process to sort by minPrice
            List<SanPham> content = result.getContent();
            content.sort((a, b) -> {
                BigDecimal priceA = getMinPrice(a.getMaSP());
                BigDecimal priceB = getMinPrice(b.getMaSP());
                return priceB.compareTo(priceA);
            });
            return result;
        } else {
            sortObj = Sort.by(Sort.Direction.DESC, "ngayTao");
            Pageable sortedPageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sortObj);
            return sanPhamRepository.findAll(spec, sortedPageable);
        }
    }

    /**
     * Lấy sản phẩm liên quan cùng danh mục
     */
    public List<SanPham> findRelatedProducts(Long loaiId, Long excludeId, int limit) {
        return sanPhamRepository.findByLoaiSanPham_MaLoaiAndMaSPNotOrderByNgayTaoDesc(loaiId, excludeId)
                .stream()
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * Tìm kiếm nhanh theo từ khóa (AJAX autocomplete)
     */
    public List<SanPham> searchByKeyword(String keyword, int limit) {
        return sanPhamRepository.findTop10ByTenSPContainingIgnoreCaseOrderByNgayTaoDesc(keyword);
    }

    /**
     * Tăng lượt xem sản phẩm
     */
    public void incrementLuotXem(Long id) {
        Optional<SanPham> sp = sanPhamRepository.findById(id);
        if (sp.isPresent()) {
            sanPhamRepository.save(sp.get());
        }
    }

    /**
     * Lấy tất cả sản phẩm với phân trang
     */
    public Page<SanPham> getAllSanPham(Pageable pageable) {
        return sanPhamRepository.findAll(pageable);
    }


    /**
     * Lưu hoặc cập nhật sản phẩm
     */
    public SanPham save(SanPham sanPham) {
        return sanPhamRepository.save(sanPham);
    }

    /**
     * Xóa sản phẩm theo ID
     */
    public void deleteById(Long id) {
        sanPhamRepository.deleteById(id);
    }

    /**
     * Đếm tổng số sản phẩm
     */
    public long countAll() {
        return sanPhamRepository.count();
    }

    /**
     * Lấy tất cả sản phẩm (sắp xếp theo ngày tạo mới nhất)
     */
    public List<SanPham> findAll() {
        return sanPhamRepository.findAll(Sort.by(Sort.Direction.DESC, "ngayTao"));
    }

//    public Map<Long, PriceStockInfo> buildPriceStockMap(List<SanPham> products) {
//        Map<Long, PriceStockInfo> map = new java.util.HashMap<>();
//        if (products == null || products.isEmpty()) return map;
//        List<Long> ids = products.stream().map(SanPham::getMaSP).toList();
//        List<com.example.projectend.repository.SanPhamChiTietRepository.PriceStockProjection> rows = sanPhamChiTietRepository.aggregateForProducts(ids);
//
//        // Lấy thông tin khuyến mãi cho tất cả sản phẩm
//        LocalDateTime now = LocalDateTime.now();
//        Map<Long, KhuyenMai> promotionMap = new java.util.HashMap<>();
//        for (Long id : ids) {
//            List<KhuyenMai> promotions = khuyenMaiRepository.findActivePromotionsByProduct(id, now);
//            if (!promotions.isEmpty()) {
//                // Lấy khuyến mãi có % giảm cao nhất
//                promotionMap.put(id, promotions.stream()
//                    .filter(km -> km.getLoaiGiaTri() == 0) // Chỉ lấy loại giảm %
//                    .max((a, b) -> a.getGiaTri().compareTo(b.getGiaTri()))
//                    .orElse(null));
//            }
//        }
//
//        for (var r : rows) {
//            KhuyenMai promo = promotionMap.get(r.getMaSP());
//            map.put(r.getMaSP(), new PriceStockInfo(r.getMinPrice(), r.getMaxPrice(), r.getTotalStock(), promo));
//        }
//        // Fill missing products (no variant yet)
//        for (Long id : ids) {
//            map.putIfAbsent(id, new PriceStockInfo(BigDecimal.ZERO, BigDecimal.ZERO, 0, null));
//        }
//        return map;

    public Map<Long, PriceStockInfo> buildPriceStockMap(List<SanPham> products) {
        Map<Long, PriceStockInfo> map = new java.util.HashMap<>();

        if (products == null || products.isEmpty()) {
            return map;
        }

        List<Long> ids = products.stream()
                .map(SanPham::getMaSP)
                .toList();

        List<com.example.projectend.repository.SanPhamChiTietRepository.PriceStockProjection> rows =
                sanPhamChiTietRepository.aggregateForProducts(ids);

        for (var r : rows) {
            map.put(
                    r.getMaSP(),
                    new PriceStockInfo(
                            r.getMinPrice(),
                            r.getMaxPrice(),
                            r.getTotalStock()
                    )
            );
        }

        for (Long id : ids) {
            map.putIfAbsent(
                    id,
                    new PriceStockInfo(
                            BigDecimal.ZERO,
                            BigDecimal.ZERO,
                            0
                    )
            );
        }
        return map;
    }

    public static class PriceStockInfo {
        private BigDecimal minPrice;
        private BigDecimal maxPrice;
        private Integer totalStock;

        public PriceStockInfo(BigDecimal minPrice, BigDecimal maxPrice, Integer totalStock) {
            this.minPrice = minPrice != null ? minPrice : BigDecimal.ZERO;
            this.maxPrice = maxPrice != null ? maxPrice : this.minPrice;
            this.totalStock = totalStock != null ? totalStock : 0;
        }

        public BigDecimal getMinPrice() { return minPrice; }
        public BigDecimal getMaxPrice() { return maxPrice; }
        public Integer getTotalStock() { return totalStock; }
        public boolean isOutOfStock() { return totalStock <= 0; }
    }

}
