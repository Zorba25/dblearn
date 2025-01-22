{% macro log_results(results) %}
 
  {% if execute %}
  {{ log("========== Begin Summary ==========", info=True) }}
  {% for res in results -%}
   
   
    {% set line -%}
      {% set sql %}      
     
    INSERT INTO test.dbtlogs (TargetSchema, ModelName, Materialization,JobStartDate,
    ModelCreateStartDate,ModelCreateEndDate,Status, Executiontime,InvocationId,DbtVersion,
    RecordInsertedDate,Rowcount)
VALUES ('{{ res.node.schema }}', '{{ res.node.unique_id }}', '{{ res.node.config.materialized }}',
'{{ run_started_at }}',
'{{ res.timing | selectattr("name", "equalto", "compile") | map(attribute="started_at") | first ~ "" }}',
'{{ res.timing | selectattr("name", "equalto", "execute") | map(attribute="completed_at") | first ~ "" }}'
,'{{res.status}}','{{ res.execution_time }}',
'{{ invocation_id }}','{{ dbt_version }}',CURRENT_TIMESTAMP(0),'{{ res.adapter_response.rows_affected }}');
           
      {% endset %}
     {% do run_query(sql) %}  
 {%- endset %}
    {{ log(line, info=True) }}
  {% endfor %}
  {{ log("========== End Summary ==========", info=True) }}
  {% endif %}
{% endmacro %}