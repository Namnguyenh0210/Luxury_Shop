package com.example.projectend.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.example.projectend.entity.Message;

/**
 * ENTITY CONVERSATION - LƯU TRỮ CUỘC HỘI THOẠI CHATBOT
 * Bảng: Conversations
 */
@Entity
@Table(name = "Conversations")
public class Conversation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaCuocTroChuyen")
    private Long maCuocTroChuyen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaTK")
    @JsonIgnoreProperties({ "hibernateLazyInitializer", "handler", "matKhau", "roles" })
    private TaiKhoan taiKhoan;

    @Column(name = "TrangThai", nullable = false, length = 10)
    private String trangThai = "AI"; // 'AI', 'HUMAN', 'CLOSED'

    @Column(name = "NgayTao")
    private LocalDateTime ngayTao = LocalDateTime.now();

    @Column(name = "NgayCapNhat")
    private LocalDateTime ngayCapNhat = LocalDateTime.now();

    @OneToMany(mappedBy = "conversation", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnoreProperties("conversation")
    private List<Message> messages = new ArrayList<>();

    // Constructors
    public Conversation() {
    }

    public Conversation(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    // Getters and Setters
    public Long getMaCuocTroChuyen() {
        return maCuocTroChuyen;
    }

    public void setMaCuocTroChuyen(Long maCuocTroChuyen) {
        this.maCuocTroChuyen = maCuocTroChuyen;
    }

    public TaiKhoan getTaiKhoan() {
        return taiKhoan;
    }

    public void setTaiKhoan(TaiKhoan taiKhoan) {
        this.taiKhoan = taiKhoan;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public LocalDateTime getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDateTime ngayTao) {
        this.ngayTao = ngayTao;
    }

    public LocalDateTime getNgayCapNhat() {
        return ngayCapNhat;
    }

    public void setNgayCapNhat(LocalDateTime ngayCapNhat) {
        this.ngayCapNhat = ngayCapNhat;
    }

    public List<Message> getMessages() {
        return messages;
    }

    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }
}
