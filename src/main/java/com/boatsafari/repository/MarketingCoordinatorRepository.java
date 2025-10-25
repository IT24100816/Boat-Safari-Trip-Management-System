package com.boatsafari.repository;

import com.boatsafari.model.MarketingCoordinator;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MarketingCoordinatorRepository extends JpaRepository<MarketingCoordinator, Long> {
    MarketingCoordinator findByEmail(String email);
}