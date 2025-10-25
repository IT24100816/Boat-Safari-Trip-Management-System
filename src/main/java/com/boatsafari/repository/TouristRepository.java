package com.boatsafari.repository;

import com.boatsafari.model.Tourist;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TouristRepository extends JpaRepository<Tourist, Long> {
    Tourist findByEmail(String email);
    List<Tourist> findAll();
}