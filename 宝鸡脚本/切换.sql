Select
a.HOS_ID
,
a.SCID_ID
,
a.HOT_ID
,
a.TCID_ID,
COUNT(a.TCID_ID)
From
NOKRWW_PS_AUTSH2_DMNC3_RAW a
INNER JOIN c_w_custom c ON a.SCID_ID = c.ci 
                AND a.HOS_ID = c.wcel_rnc_id 
                AND  c.wcel_rnc_id  = '3124'
Where
a.PERIOD_START_TIME >= To_Date(&start_date, 'yyyy-mm-dd') And
a.PERIOD_START_TIME < To_Date(&end_date, 'yyyy-mm-dd')
AND c.wcel_wbts_id = '714'



Group By
a.HOS_ID
,
a.SCID_ID
,
a.HOT_ID
,
a.TCID_ID