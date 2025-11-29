package com.example.projectend.controller.admin;

import com.example.projectend.entity.NhaCungCap;
import com.example.projectend.entity.NhapKho;
import com.example.projectend.entity.SanPham;
import com.example.projectend.repository.NhaCungCapRepository;
import com.example.projectend.repository.NhapKhoRepository;
import com.example.projectend.service.SanPhamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/inventory")
@PreAuthorize("hasRole('ADMIN') or hasRole('NHANVIEN')")
public class AdminInventoryController {

    @Autowired
    private NhapKhoRepository nhapKhoRepository;

    @Autowired
    private NhaCungCapRepository nhaCungCapRepository;

    @Autowired
    private SanPhamService sanPhamService;

    // ==========================================
    // 1. DASHBOARD KHO & NHÀ CUNG CẤP
    // ==========================================
    @GetMapping
    public String inventoryDashboard(Model model) {
        // 1. Lấy danh sách Lịch sử nhập kho (Mới nhất lên đầu)
        List<NhapKho> nhapKhos = nhapKhoRepository.findAll(Sort.by(Sort.Direction.DESC, "ngayNhap"));
        
        // 2. Lấy danh sách Nhà cung cấp
        List<NhaCungCap> suppliers = nhaCungCapRepository.findAll();

        // 3. Lấy danh sách Sản phẩm (Để hiển thị trong Modal nhập hàng)
        List<SanPham> products = sanPhamService.findAll();

        // 4. Thống kê
        // Tổng số lượng sản phẩm đã nhập
        long totalItems = nhapKhos.stream().mapToLong(NhapKho::getSoLuong).sum();
        
        // Đếm số lượng sản phẩm đang kinh doanh
        long lowStockCount = products.size(); 
        
        long supplierCount = nhaCungCapRepository.count();

        // 5. Đẩy dữ liệu ra View
        model.addAttribute("nhapKhos", nhapKhos);
        model.addAttribute("suppliers", suppliers);
        model.addAttribute("products", products); // Quan trọng cho Modal Import

        model.addAttribute("totalItems", totalItems);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("supplierCount", supplierCount);
        
        model.addAttribute("currentPage", "inventory");

        return "admin/inventory";
    }

    // ==========================================
    // 2. XỬ LÝ NHẬP KHO (MỚI)
    // ==========================================
    @PostMapping("/import/save")
    public String saveImport(@RequestParam Long sanPhamId,
                             @RequestParam Integer soLuong,
                             RedirectAttributes ra) {
        try {
            SanPham sanPham = sanPhamService.findById(sanPhamId).orElse(null);
            if (sanPham != null && soLuong > 0) {
                NhapKho nk = new NhapKho();
                nk.setSanPham(sanPham);
                nk.setSoLuong(soLuong);
                nk.setNgayNhap(LocalDateTime.now());
                
                // Lưu lịch sử nhập kho
                nhapKhoRepository.save(nk);
                
                // TODO: Tại đây bạn nên cộng dồn số lượng tồn kho vào bảng SanPhamChiTiet nếu cần
                // ví dụ: sanPhamChiTietService.addStock(sanPhamId, soLuong);

                ra.addFlashAttribute("success", "Đã nhập kho thành công " + soLuong + " sản phẩm!");
            } else {
                ra.addFlashAttribute("error", "Sản phẩm không tồn tại hoặc số lượng không hợp lệ.");
            }
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi nhập kho: " + e.getMessage());
        }
        return "redirect:/admin/inventory";
    }

    // ==========================================
    // 3. XỬ LÝ NHÀ CUNG CẤP
    // ==========================================
    @PostMapping("/supplier/save")
    public String saveSupplier(@ModelAttribute NhaCungCap ncc, RedirectAttributes ra) {
        try {
            nhaCungCapRepository.save(ncc);
            ra.addFlashAttribute("success", "Lưu nhà cung cấp thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/admin/inventory";
    }

    @GetMapping("/supplier/delete/{id}")
    public String deleteSupplier(@PathVariable Long id, RedirectAttributes ra) {
        try {
            nhaCungCapRepository.deleteById(id);
            ra.addFlashAttribute("success", "Xóa nhà cung cấp thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Không thể xóa (đang có dữ liệu liên kết).");
        }
        return "redirect:/admin/inventory";
    }
}