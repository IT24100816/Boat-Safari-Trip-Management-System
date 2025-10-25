package com.boatsafari.pattern;

import org.springframework.web.multipart.MultipartFile;
import java.util.List;

public class PaymentValidationContext {
    private PaymentSlipValidationStrategy strategy;

    public void setStrategy(PaymentSlipValidationStrategy strategy) {
        this.strategy = strategy;
    }

    public boolean validate(MultipartFile file, List<String> errors) {
        if (strategy != null) {
            return strategy.validate(file, errors);
        }
        return true; // Default to true if no strategy is set
    }
}