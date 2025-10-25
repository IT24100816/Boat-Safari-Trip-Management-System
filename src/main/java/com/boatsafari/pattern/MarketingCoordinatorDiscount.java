package com.boatsafari.pattern;

import com.boatsafari.model.Trip;

public class MarketingCoordinatorDiscount implements DiscountStrategy {
    @Override
    public double calculateDiscount(double baseAmount, int passengers, int hours, Trip trip, double marketingDiscount) {
        return baseAmount * (marketingDiscount / 100);
    }
}