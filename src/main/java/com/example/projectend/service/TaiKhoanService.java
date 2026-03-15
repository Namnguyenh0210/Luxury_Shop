package com.example.projectend.service;

import com.example.projectend.entity.TaiKhoan;
import com.example.projectend.entity.VaiTro;
import com.example.projectend.repository.TaiKhoanRepository;
import com.example.projectend.repository.VaiTroRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service xử lý logic nghiệp vụ cho tài khoản
 */
@Service
public class TaiKhoanService {

    @Autowired
    private TaiKhoanRepository taiKhoanRepository;

    @Autowired
    private VaiTroRepository vaiTroRepository;

    /**
     * Tìm tài khoản theo email
     */
    public TaiKhoan findByEmail(String email) {
        return taiKhoanRepository.findByEmail(email).orElse(null);
    }

    /**
     * Lưu hoặc cập nhật tài khoản
     */
    public TaiKhoan save(TaiKhoan taiKhoan) {
        return taiKhoanRepository.save(taiKhoan);
    }

    /**
     * Tìm tài khoản theo ID
     */
    public Optional<TaiKhoan> findById(Long id) {
        return taiKhoanRepository.findById(id);
    }

    /**
     * Xóa tài khoản theo ID
     */
    public void deleteById(Long id) {
        taiKhoanRepository.deleteById(id);
    }

    /**
     * Lấy tất cả tài khoản
     */
    public List<TaiKhoan> findAll() {
        return taiKhoanRepository.findAll();
    }

    /**
     * Lấy tất cả tài khoản với phân trang
     */
    public Page<TaiKhoan> getAllTaiKhoan(Pageable pageable) {
        return taiKhoanRepository.findAll(pageable);
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     */
    public boolean existsByEmail(String email) {
        return taiKhoanRepository.findByEmail(email).isPresent();
    }

    /**
     * Cập nhật thông tin cá nhân
     */
    public TaiKhoan updateProfile(TaiKhoan tk, String hoTen, String soDienThoai) {
        tk.setHoTen(hoTen);
        tk.setSoDienThoai(soDienThoai);
        return save(tk);
    }

    /**
     * Đổi mật khẩu
     */
    public TaiKhoan changePassword(TaiKhoan tk, String newPassword) {
        tk.setMatKhau(newPassword);
        return save(tk);
    }

    /**
     * Khóa tài khoản (admin)
     */
    public boolean lockAccount(Long id) {
        Optional<TaiKhoan> tkOpt = findById(id);
        if (tkOpt.isPresent()) {
            TaiKhoan tk = tkOpt.get();
            tk.setTrangThai(false);
            save(tk);
            return true;
        }
        return false;
    }

    /**
     * Mở khóa tài khoản (admin)
     */
    public boolean unlockAccount(Long id) {
        Optional<TaiKhoan> tkOpt = findById(id);
        if (tkOpt.isPresent()) {
            TaiKhoan tk = tkOpt.get();
            tk.setTrangThai(true);
            save(tk);
            return true;
        }
        return false;
    }

    /**
     * Thêm vai trò cho tài khoản (admin)
     */
    public boolean addRoleToAccount(Long accountId, Long roleId) {
        Optional<TaiKhoan> tkOpt = findById(accountId);
        Optional<VaiTro> roleOpt = vaiTroRepository.findById(roleId);

        if (tkOpt.isPresent() && roleOpt.isPresent()) {
            TaiKhoan tk = tkOpt.get();
            tk.addVaiTro(roleOpt.get());
            save(tk);
            return true;
        }
        return false;
    }

    /**
     * Tìm kiếm tài khoản theo từ khóa
     */
    public List<TaiKhoan> searchByKeyword(String keyword) {
        return taiKhoanRepository.searchByKeyword(keyword);
    }
}
