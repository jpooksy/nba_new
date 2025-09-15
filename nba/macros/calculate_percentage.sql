{% macro calculate_percentage(numerator, denominator) %}
    CASE 
        WHEN {{ denominator }} = 0 OR {{ denominator }} IS NULL THEN 0
        ELSE ROUND(CAST({{ numerator }} AS FLOAT) / CAST({{ denominator }} AS FLOAT) * 100, 2)
    END
{% endmacro %}