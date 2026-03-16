package com.example.projectend.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.time.LocalDateTime;

/**
 * ENTITY MESSAGE - LƯU TRỮ TIN NHẮN TRONG CUỘC HỘI THOẠI
 * Bảng: Messages
 */
@Entity
@Table(name = "Messages")
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaTinNhan")
    private Long maTinNhan;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MaCuocTroChuyen", nullable = false)
    @JsonIgnoreProperties("messages")
    private Conversation conversation;

    @Column(name = "LoaiNguoiGui", nullable = false, length = 10)
    private String loaiNguoiGui; // 'USER', 'AI', 'STAFF'

    @Column(name = "NoiDung", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String noiDung;

    @Column(name = "NgayGui")
    private LocalDateTime ngayGui = LocalDateTime.now();

    // Constructors
    public Message() {
    }

    public Message(Conversation conversation, String loaiNguoiGui, String noiDung) {
        this.conversation = conversation;
        this.loaiNguoiGui = loaiNguoiGui;
        this.noiDung = noiDung;
    }

    // Getters and Setters
    public Long getMaTinNhan() {
        return maTinNhan;
    }

    public void setMaTinNhan(Long maTinNhan) {
        this.maTinNhan = maTinNhan;
    }

    public Conversation getConversation() {
        return conversation;
    }

    public void setConversation(Conversation conversation) {
        this.conversation = conversation;
    }

    public String getLoaiNguoiGui() {
        return loaiNguoiGui;
    }

    public void setLoaiNguoiGui(String loaiNguoiGui) {
        this.loaiNguoiGui = loaiNguoiGui;
    }

    public String getNoiDung() {
        return noiDung;
    }

    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public LocalDateTime getNgayGui() {
        return ngayGui;
    }

    public void setNgayGui(LocalDateTime ngayGui) {
        this.ngayGui = ngayGui;
    }
}
