package com.boatsafari.pattern;

import com.boatsafari.model.Trip;

public class PrivateDiscount implements DiscountStrategy {
    @Override
    public double calculateDiscount(double baseAmount, int passengers, int hours, Trip trip, double marketingDiscount) {
        if ("private".equalsIgnoreCase(trip.getType())) {
            return baseAmount * (10.0 / 100); // 10% for private trips
        }
        return 0.0;
    }
}