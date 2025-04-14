select * into temp_smsc_20250201_new  from  temp_smsc_20250201 with(nolock)

  where smpp_address not like '%flytx%'

  and originator not like '%MTN%'

  AND originator NOT LIKE '%MONEY%'-- (3269552 rows affected)

 

  --select * from temp_smsc_20250201_new

 

  alter table temp_smsc_20250201_new

  add  Long_number nvarchar(20)

 

  update temp_smsc_20250201_new

  set Long_number='250'+mobile_number_v

  from smpp_mapping v

  join temp_smsc_20250201_new t

  on v.smpp_address=t.smpp_address

  --5006_MINECOFIN

 

   select * from temp_smsc_20250201_new

   --where smpp_address like '%MINECOFIN%'

   where long_number is not null

 

   SELECT * , ISNULL(COUNT_SMSC,0)-ISNULL(COUNT_,0) AS VARIANCE  INTO smsc_billing_recon

   FROM(SELECT  LONG_NUMBER,SUBSTRING(DESTINATION,3,12)DESTINATION,SMPP_ADDRESS,COUNT(*)COUNT_SMSC

   FROM temp_smsc_20250201_new WITH(NOLOCK)

   WHERE LONG_NUMBER IS NOT NULL

   GROUP BY LONG_NUMBER,SUBSTRING(DESTINATION,3,12),SMPP_ADDRESS)T

   full JOIN

     (

select event_name,mobile_number_v,CALLED_CALLING_NUMBER_V, count(*)count_ from temp_postpaid_usage_202502

group by event_name,mobile_number_v,CALLED_CALLING_NUMBER_V )V

ON SUBSTRING(LONG_NUMBER,4,10)=MOBILE_NUMBER_V

AND DESTINATION=CALLED_CALLING_NUMBER_V

 

 

select * from smsc_billing_recon

 

alter table smsc_billing_recon

add remark nvarchar(100)

 

update smsc_billing_recon

set remark='OK: MATCHING'

WHERE VARIANCE=0

 

 

update smsc_billing_recon

set remark='Missing in SMSC'

WHERE  COUNT_SMSC IS NULL

 

 

update smsc_billing_recon

set remark='Missing in Billing'

WHERE  COUNT_ IS NULL

 

 

update smsc_billing_recon

set remark='In both systems but SMSC>BILLING:'

WHERE  VARIANCE>0

AND REMARK IS NULL

 

update smsc_billing_recon

set remark='In both systems but SMSC <BILLING:'

WHERE  VARIANCE<0

AND REMARK IS NULL

 

 

select remark,count(*)count_ from smsc_billing_recon

group by  remark

ORDER BY  COUNT(*) DESC

 

select * from smsc_billing_recon

where remark='Missing in SMSC'

AND MOBILE_NUMBER_V NOT IN (SELECT MOBILE_NUMBER_V FROM smpp_mapping)

 

update smsc_billing_recon

set remark='Missing in SMSC:Not among SMPP long number'

WHERE  remark='Missing in SMSC'

AND MOBILE_NUMBER_V NOT IN (SELECT MOBILE_NUMBER_V FROM smpp_mapping)

 