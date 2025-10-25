package com.boatsafari.pattern;

import com.boatsafari.model.Trip;

public class CombinedDiscountStrategy implements DiscountStrategy {
    @Override
    public double calculateDiscount(double baseAmount, int passengers, int hours, Trip trip, double marketingDiscount) {
        DiscountStrategy marketing = new MarketingCoordinatorDiscount();
        DiscountStrategy morning = new MorningDiscount();
        DiscountStrategy evening = new EveningDiscount();
        DiscountStrategy privateDiscount = new PrivateDiscount();
        double marketingDiscountAmount = marketing.calculateDiscount(baseAmount, passengers, hours, trip, marketingDiscount);
        double morningDiscountAmount = morning.calculateDiscount(baseAmount, passengers, hours, trip, marketingDiscount);
        double eveningDiscountAmount = evening.calculateDiscount(baseAmount, passengers, hours, trip, marketingDiscount);
        double privateDiscountAmount = privateDiscount.calculateDiscount(baseAmount, passengers, hours, trip, marketingDiscount);
        return marketingDiscountAmount + morningDiscountAmount + eveningDiscountAmount + privateDiscountAmount;
    }
}