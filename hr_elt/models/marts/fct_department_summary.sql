with employees as (
    select * from {{ ref('employees') }}
),

departments as (
    select * from {{ ref('departments') }}
)

select
    d.department_id,
    d.department_name,
    count(e.employee_id) as total_headcount,
    coalesce(sum(e.salary), 0) as total_monthly_payroll,
    coalesce(round(avg(e.salary), 2), 0) as avg_department_salary,
    coalesce(min(e.salary), 0) as lowest_salary,
    coalesce(max(e.salary), 0) as highest_salary

from departments d
left join employees e on d.department_id = e.department_id
group by 1, 2