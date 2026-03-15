package com.example.projectend.service;

import com.example.projectend.entity.ThuongHieu;
import com.example.projectend.repository.ThuongHieuRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Service xử lý logic nghiệp vụ cho thương hiệu (Brand)
 */
@Service
public class ThuongHieuService {

    @Autowired
    private ThuongHieuRepository thuongHieuRepository;

    /**
     * Lấy tất cả thương hiệu
     */
    public List<ThuongHieu> findAll() {
        return thuongHieuRepository.findAll();
    }

    public java.util.Optional<ThuongHieu> findById(Long id) {
        return thuongHieuRepository.findById(id);
    }

    public ThuongHieu save(ThuongHieu brand) {
        return thuongHieuRepository.save(brand);
    }

    public void deleteById(Long id) {
        thuongHieuRepository.deleteById(id);
    }
}

