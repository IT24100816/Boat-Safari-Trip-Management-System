package com.boatsafari.repository;

import com.boatsafari.model.BookingManager;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingManagerRepository extends JpaRepository<BookingManager, Long> {
    BookingManager findByEmail(String email);
}