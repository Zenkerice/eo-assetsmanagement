-- Run once in phpMyAdmin to add brand_model column
ALTER TABLE products
  ADD COLUMN brand_model VARCHAR(150) DEFAULT NULL AFTER sku;
