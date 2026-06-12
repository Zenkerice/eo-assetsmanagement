-- Run this once to add image support to existing databases
ALTER TABLE products
  ADD COLUMN IF NOT EXISTS image_path VARCHAR(255) DEFAULT NULL;
