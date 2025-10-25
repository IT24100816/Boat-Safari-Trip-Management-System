package com.boatsafari.pattern;

import org.springframework.web.multipart.MultipartFile;
import java.util.Arrays;
import java.util.List;

public class FileTypeValidationStrategy implements PaymentSlipValidationStrategy {
    private static final List<String> ALLOWED_TYPES = Arrays.asList("image/jpeg", "image/png", "image/jpg");

    @Override
    public boolean validate(MultipartFile file, List<String> errors) {
        if (file == null || file.isEmpty()) {
            errors.add("Payment slip file is required.");
            return false;
        }
        String contentType = file.getContentType();
        if (!ALLOWED_TYPES.contains(contentType)) {
            errors.add("Invalid file type. Only JPEG, PNG, and JPG files are allowed.");
            return false;
        }
        return true;
    }
}