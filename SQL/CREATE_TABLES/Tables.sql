-- 1. Dim Property
CREATE TABLE dim_property (
    property_id VARCHAR(20) PRIMARY KEY,
    property_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    province VARCHAR(50),
    property_type VARCHAR(30),
    property_manager VARCHAR(50),
    total_units INT
);

-- 2. Dim Unit
CREATE TABLE dim_unit (
    unit_id VARCHAR(20) PRIMARY KEY,
    property_id VARCHAR(20) REFERENCES dim_property(property_id),
    unit_number VARCHAR(10),
    unit_type VARCHAR(30),
    bedrooms INT,
    area_m2 NUMERIC(10,2),
    market_rent NUMERIC(12,2),
    annual_market_rent NUMERIC(12,2),
    unit_status VARCHAR(20) CHECK (unit_status IN ('Occupied', 'Vacant', 'Maintenance'))
);

-- 3. Dim Maintenance Category
CREATE TABLE dim_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE
);

-- 4. Fact Maintenance Records
CREATE TABLE fact_maintenance_records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    unit_id VARCHAR(20) REFERENCES dim_unit(unit_id),
    property_id VARCHAR(20) REFERENCES dim_property(property_id),
    category_name VARCHAR(50),
    maintenance_spend NUMERIC(10,2),
    request_date DATE,
    unit_status_at_request VARCHAR(20)
);