package com.example.projectend.controller.admin;

import com.example.projectend.entity.BaiViet;
import com.example.projectend.repository.BaiVietRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/admin/blogs")
@PreAuthorize("hasRole('ADMIN')")
public class AdminBaiVietController {

    @Autowired
    private BaiVietRepository baiVietRepository;

    @GetMapping
    public List<BaiViet> getAll() {
        return baiVietRepository.findAll();
    }

    @GetMapping("/{id}")
    public BaiViet getOne(@PathVariable Long id) {
        return baiVietRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bài viết"));
    }

    @PostMapping
    public BaiViet create(@RequestBody BaiViet baiViet) {
        return baiVietRepository.save(baiViet);
    }

    @PutMapping("/{id}")
    public BaiViet update(@PathVariable Long id,
                          @RequestBody BaiViet baiViet) {

        BaiViet existing = baiVietRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy"));

        existing.setTieuDe(baiViet.getTieuDe());
        existing.setNoiDung(baiViet.getNoiDung());

        return baiVietRepository.save(existing);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        baiVietRepository.deleteById(id);
    }
}