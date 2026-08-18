with stg_employees as (
    select * from {{ ref('employees') }}
),
stg_departments as (
    select * from {{ ref('departments') }}
),
stg_jobs as (
    select * from {{ ref('jobs') }}
),

enriched as (
    select
        e.employee_id,
        e.first_name || ' ' || e.last_name as full_name,
        j.job_title,
        d.department_name,
        m.first_name || ' ' || m.last_name as manager_name,
        e.hire_date,
        e.salary,
        round(avg(e.salary) over (partition by e.department_id), 2) as dept_avg_salary,
        case 
            when e.salary > j.max_salary then 'Overpaid'
            when e.salary < j.min_salary then 'Underpaid'
            else 'Within Range'
        end as salary_band_status

    from stg_employees e
    left join stg_departments d on e.department_id = d.department_id
    left join stg_jobs j on e.job_id = j.job_id
    left join stg_employees m on e.manager_id = m.employee_id
)

select * from enriched