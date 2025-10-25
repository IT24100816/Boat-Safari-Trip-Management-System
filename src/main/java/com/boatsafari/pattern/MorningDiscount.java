package com.boatsafari.pattern;

import com.boatsafari.model.Trip;

public class MorningDiscount implements DiscountStrategy {
    @Override
    public double calculateDiscount(double baseAmount, int passengers, int hours, Trip trip, double marketingDiscount) {
        if ("morning".equalsIgnoreCase(trip.getType())) {
            return baseAmount * (5.0 / 100); // 5% for morning trips
        }
        return 0.0;
    }
}