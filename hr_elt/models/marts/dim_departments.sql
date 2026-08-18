with departments as (
    select * from {{ ref('departments') }}
),

locations as (
    select * from {{ ref('locations') }}
),

countries as (
    select * from {{ ref('countries') }}
),

regions as (
    select * from {{ ref('regions') }}
)

select
    d.department_id,
    d.department_name,
    l.street_address,
    l.postal_code,
    l.city,
    l.state_province,
    c.country_name,
    r.region_name

from departments d
left join locations l on d.location_id = l.location_id
left join countries c on l.country_id = c.country_id
left join regions r on c.region_id = r.region_id