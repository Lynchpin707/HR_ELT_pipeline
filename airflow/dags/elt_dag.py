import os
from datetime import datetime, timezone
from airflow import DAG
from docker.types import Mount
from airflow.providers.docker.operators.docker import DockerOperator

HOST_PROJECT_DIR = os.environ.get("HOST_PROJECT_DIR", "/opt/airflow")
HOST_DBT_PROFILES_DIR = os.environ.get(
    "HOST_DBT_PROFILES_DIR", os.path.expanduser("~/.dbt")
)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False 
}

dag = DAG(
    'elt_and_dbt',
    default_args=default_args, 
    description='An ELT workflow with dbt',
    start_date=datetime(2023, 10, 28, tzinfo=timezone.utc),
    catchup=False,
)

# Airbyte task temporarily removed to meet deadline

t2 = DockerOperator(
    task_id="dbt_run",
    image='ghcr.io/dbt-labs/dbt-postgres:1.4.7',
    command=[
        "run",
        "--profiles-dir",
        "/root",
        "--project-dir",
        "/opt/dbt"  
    ],
    auto_remove='success',
    docker_url="unix:///var/run/docker.sock", 
    network_mode="elt_network",               
    mounts=[
        Mount(source=f'{HOST_PROJECT_DIR}/hr_elt', target='/opt/dbt', type='bind'),
        Mount(source=HOST_DBT_PROFILES_DIR, target='/root', type='bind')
    ],
    mount_tmp_dir=False,
    dag=dag
)