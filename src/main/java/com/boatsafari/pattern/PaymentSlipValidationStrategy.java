package com.boatsafari.pattern;

import org.springframework.web.multipart.MultipartFile;
import java.util.List;

public interface PaymentSlipValidationStrategy {
    boolean validate(MultipartFile file, List<String> errors);
}