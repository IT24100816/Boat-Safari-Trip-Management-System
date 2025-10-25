package com.boatsafari.repository;

import com.boatsafari.model.BoatDriver;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BoatDriverRepository extends JpaRepository<BoatDriver, Long> {
    List<BoatDriver> findAll();
    BoatDriver findByEmail(String email);
}