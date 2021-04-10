create table if not exists u_0972430.alert_list
as 

with pos as (
select extract(hour from presence_date) as hour, p."user" as positive_user, positive_date,report_date,location as positive_location,DATE_TRUNC('minute',presence_date)::timestamp as positive_presence
from attendance as a 
inner join positives as p
on a.user = p.user 
where date(presence_date) >= positive_date - 7 and date(presence_date) <= positive_date
)
,
att as (
select location as attendance_location,"user" as attn_user, extract(hour from presence_date) as attend_hour,DATE_TRUNC('minute',presence_date)::timestamp as presence_date
from attendance 
)

select 
positive_user as positive_user_id,
report_date,
attendance_location as location,
positive_date,
attn_user as alert_user_id,
presence_date as user_presence_date,
hour_diff,
alert
from(
select  *, ABS(extract(EPOCH from (positive_presence - presence_date))/3600) as hour_diff,
case when ABS(extract(EPOCH from (positive_presence - presence_date))/3600) <= 0.5 then 'Yes' else 'No' end as Alert
from pos inner join att
on att.attendance_location = pos.positive_location
and date(pos.positive_presence) = date(att.presence_date)
where attn_user not in (select distinct "user" from positives)
) f

where Alert = 'Yes'




