SELECT 
    u.unit_status,
    COUNT(DISTINCT u.unit_id) AS total_units_affected,
    COUNT(m.record_id) AS total_maintenance_records,
    SUM(m.maintenance_spend) AS total_spend,
    ROUND(AVG(m.maintenance_spend), 2) AS avg_cost_per_record,
    ROUND(SUM(m.maintenance_spend) * 100.0 / SUM(SUM(m.maintenance_spend)) OVER(), 2) AS pct_spend_share
FROM dim_unit u
JOIN fact_maintenance_records m ON u.unit_id = m.unit_id
GROUP BY u.unit_status
ORDER BY total_spend DESC;