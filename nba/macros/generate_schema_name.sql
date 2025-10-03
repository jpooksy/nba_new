{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if target.name == 'prod' -%}

        {{ custom_schema_name | trim }}

    {%- elif target.name == 'ci' -%}

        {{ default_schema }}

    {%- else -%}

        {%- if custom_schema_name is none -%}

            {{ default_schema }}

        {%- else -%}

            {{ default_schema }}_{{ custom_schema_name | trim }}

        {%- endif -%}

    {%- endif -%}

{%- endmacro %}