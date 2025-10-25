package com.boatsafari.pattern;

import org.springframework.web.multipart.MultipartFile;
import java.util.List;

public class FileSizeValidationStrategy implements PaymentSlipValidationStrategy {
    private static final long MAX_SIZE_BYTES = 5 * 1024 * 1024; // 5MB

    @Override
    public boolean validate(MultipartFile file, List<String> errors) {
        if (file == null || file.isEmpty()) {
            errors.add("Payment slip file is required.");
            return false;
        }
        if (file.getSize() > MAX_SIZE_BYTES) {
            errors.add("File size exceeds 5MB limit.");
            return false;
        }
        return true;
    }
}