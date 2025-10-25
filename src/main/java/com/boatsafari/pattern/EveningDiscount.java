package com.boatsafari.pattern;

import com.boatsafari.model.Trip;

public class EveningDiscount implements DiscountStrategy {
    @Override
    public double calculateDiscount(double baseAmount, int passengers, int hours, Trip trip, double marketingDiscount) {
        if ("evening".equalsIgnoreCase(trip.getType())) {
            return baseAmount * (7.5 / 100); // 7.5% for evening trips
        }
        return 0.0;
    }
}