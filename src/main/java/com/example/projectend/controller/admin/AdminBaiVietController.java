package com.example.projectend.controller.admin;

import com.example.projectend.entity.BaiViet;
import com.example.projectend.repository.BaiVietRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin/blogs")
@PreAuthorize("hasRole('ADMIN')")
public class AdminBaiVietController {

    @Autowired
    private BaiVietRepository baiVietRepository;

    @GetMapping
    public String listBlogs(Model model) {
        // Lấy tất cả bài viết, sắp xếp mới nhất lên đầu
        // (Cần tạo hàm findAllByOrderByNgayDangDesc() trong Repository hoặc dùng Sort)
        List<BaiViet> posts = baiVietRepository.findAll(); 
        
        model.addAttribute("posts", posts);
        model.addAttribute("currentPage", "blogs"); // Để active menu

        return "admin/blog-list"; // Trả về file blog-list.html
    }
    
    // TODO: Bạn có thể thêm các hàm @PostMapping để Thêm/Sửa/Xóa bài viết tại đây
}