package com.boatsafari.pattern;

import com.boatsafari.model.Trip;

public interface DiscountStrategy {
    double calculateDiscount(double baseAmount, int passengers, int hours, Trip trip, double marketingDiscount);
}