package com.example.projectend.repository;

import com.example.projectend.entity.Conversation;
import com.example.projectend.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {

    // Lấy tất cả tin nhắn của một cuộc hội thoại, sắp xếp theo thời gian tăng dần
    List<Message> findByConversationOrderByNgayGuiAsc(Conversation conversation);
}
