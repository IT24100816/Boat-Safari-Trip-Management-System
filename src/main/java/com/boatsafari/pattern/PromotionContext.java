package com.boatsafari.pattern;

import com.boatsafari.model.Trip;

public class PromotionContext {
    private DiscountStrategy discountStrategy;

    public void setDiscountStrategy(DiscountStrategy discountStrategy) {
        this.discountStrategy = discountStrategy;
    }

    public double applyDiscount(double baseAmount, int passengers, int hours, Trip trip, double marketingDiscount) {
        if (discountStrategy == null) {
            throw new IllegalStateException("No discount strategy set!");
        }
        double discount = discountStrategy.calculateDiscount(baseAmount, passengers, hours, trip, marketingDiscount);
        return baseAmount - discount;
    }

    public double getTotalDiscountPercentage(double marketingDiscount, Trip trip, int passengers, int hours) {
        if (discountStrategy == null) {
            throw new IllegalStateException("No discount strategy set!");
        }
        if (discountStrategy instanceof CombinedDiscountStrategy) {
            double baseAmount = 100.0; // Use a standard base for percentage calculation
            double totalDiscount = discountStrategy.calculateDiscount(baseAmount, passengers, hours, trip, marketingDiscount);
            return (totalDiscount / baseAmount) * 100;
        }
        return marketingDiscount; // Default to marketing discount if not combined
    }
}