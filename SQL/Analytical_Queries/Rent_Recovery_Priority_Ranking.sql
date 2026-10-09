WITH PropertyRentSummary AS (
    SELECT 
        p.property_id,
        p.property_name,
        p.city,
        p.property_manager,
        COUNT(CASE WHEN u.unit_status = 'Maintenance' THEN 1 END) AS maintenance_held_units,
        SUM(CASE WHEN u.unit_status = 'Maintenance' THEN u.annual_market_rent ELSE 0 END) AS locked_annual_rent,
        SUM(m.maintenance_spend) AS total_maintenance_spend
    FROM dim_property p
    LEFT JOIN dim_unit u ON p.property_id = u.property_id
    LEFT JOIN fact_maintenance_records m ON u.unit_id = m.unit_id
    GROUP BY p.property_id, p.property_name, p.city, p.property_manager)
    
    SELECT 
    property_name,
    city,
    property_manager,
    maintenance_held_units,
    locked_annual_rent,
    total_maintenance_spend,
    ROUND(locked_annual_rent / NULLIF(total_maintenance_spend, 0), 2) AS rent_recovery_roi_ratio,
    DENSE_RANK() OVER (ORDER BY locked_annual_rent DESC) AS recovery_priority_rank
FROM PropertyRentSummary
WHERE maintenance_held_units > 0
ORDER BY recovery_priority_rank ASC;