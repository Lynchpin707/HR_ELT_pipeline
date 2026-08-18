FROM apache/airflow:latest


    
USER airflow

RUN pip install apache-airflow-providers-docker \ 
    && pip install apache-airflow-providers-http \
    && pip install apache-airflow-providers-airbyte            

USER root
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends postgresql-client \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*