select * from 

(SELECT substr(BTS.CO_DN,16,6) ENB,
       BTS.CO_NAME,
       TO_NUMBER(DECODE(BTS.CO_OC_ID, 1537, bts.CO_OBJECT_INSTANCE, NULL)) AS "小区号",
       decode(BTS.CO_OC_ID,
              '2429',
              'MRBTS',
              '1529',
              'LNBTS',
              '1537',
              'LNCEL',
              '') "级别",
       SEVERITY AS "告警级别",
       ALARM_STATUS "状态",
       ALARM_NUMBER "告警号",
       SUPPLEMENTARY_INFO AS "告警描述",
       TEXT AS "对业务影响",
       DIAGNOSTIC_INFO AS "告警ID",
       ALARM_TIME AS "告警时间",
       CANCEL_TIME AS "清除时间",
       DURATION_HOUR AS "告警存在时长(小时）",
       --BTS.CO_MAIN_HOST IP,
       DN
  FROM (SELECT DN,
               OC_ID,

               NE_GID, 
               DECODE(ALARM_TYPE,
                      1,
                      'COMM',
                      2,
                      'ENVIR',
                      3,
                      'EQUIP',
                      4,
                      'PROC',
                      5,
                      'QUAL',
                      ALARM_TYPE) ALARM_TYPE,

               DECODE(SEVERITY,
                      1,
                      'CRITICAL',
                      2,
                      'MAJOR',
                      3,
                      'MINOR',
                      4,
                      'WARNING',
                      SEVERITY) SEVERITY,
               DECODE(ALARM_STATUS, 0, 'CANCELED', 1, 'ACTIVE', ALARM_STATUS) ALARM_STATUS,
               ALARM_TIME AS ALARM_TIME,
              CANCEL_TIME AS CANCEL_TIME,
               ROUND(DECODE(CANCEL_TIME,
                            NULL,
                            DECODE(ALARM_STATUS,
                                   0,
                                   UPDATE_TIMESTAMP + 8 / 24 - ALARM_TIME,
                                   SYSDATE - ALARM_TIME),
                            CANCEL_TIME - ALARM_TIME) * 24,
                     2) AS DURATION_HOUR,
               ALARM_NUMBER,
               TEXT,
               SUPPLEMENTARY_INFO,
               DIAGNOSTIC_INFO
        
          FROM FX_ALARM
         WHERE 
         ALARM_STATUS = 1  --"1"代表当前告警，"0"代表历史告警
         ORDER BY ALARM_TIME) A,
         
       --cTP_COMMON_OBJECTS OBJ,
       cTP_COMMON_OBJECTS BTS

 WHERE --A.OC_ID = OBJ.CO_GID(+)
   --AND 
   
   A.NE_GID = BTS.CO_GID(+)
   
   AND BTS.CO_OC_ID IN (2429,1529, 1537)
 
   AND BTS.CO_STATE <> 3
   
 --and TO_NUMBER(BTS.CO_OBJECT_INSTANCE)>=&Start_ENBID
  --AND TO_NUMBER(BTS.CO_OBJECT_INSTANCE)<=&END_ENBID  --按范围查询
  --and ALARM_TIME>=to_date(&start_date,'yyyymmdd')
  --and ALARM_TIME<=to_date(&end_date,'yyyymmdd')    --按时间段查询
     --and BTS.CO_NAME like '&ENB_Name%'                      --按基站名称查询
 --and TO_NUMBER(BTS.CO_OBJECT_INSTANCE) in (&ENBID)          --查询某个站
 and alarm_number=9047
 ORDER BY ALARM_TIME

) 
 
 
union


select * from 

(SELECT substr(BTS.CO_DN,17,6) ENB,
       BTS.CO_NAME,
       TO_NUMBER(DECODE(BTS.CO_OC_ID, 1537, bts.CO_OBJECT_INSTANCE, NULL)) AS "小区号",
       decode(BTS.CO_OC_ID,
              '1547',
              'MRBTS',
              '1529',
              'LNBTS',
              '1537',
              'LNCEL',
              '') "级别",
       SEVERITY AS "告警级别",
       ALARM_STATUS "状态",
       ALARM_NUMBER "告警号",
       SUPPLEMENTARY_INFO AS "告警描述",
       TEXT AS "对业务影响",
       DIAGNOSTIC_INFO AS "告警ID",
       ALARM_TIME AS "告警时间",
       CANCEL_TIME AS "清除时间",
       DURATION_HOUR AS "告警存在时长(小时）",
       --BTS.CO_MAIN_HOST IP,
       DN
  FROM (SELECT DN,
               OC_ID,

               NE_GID, 
               DECODE(ALARM_TYPE,
                      1,
                      'COMM',
                      2,
                      'ENVIR',
                      3,
                      'EQUIP',
                      4,
                      'PROC',
                      5,
                      'QUAL',
                      ALARM_TYPE) ALARM_TYPE,

               DECODE(SEVERITY,
                      1,
                      'CRITICAL',
                      2,
                      'MAJOR',
                      3,
                      'MINOR',
                      4,
                      'WARNING',
                      SEVERITY) SEVERITY,
               DECODE(ALARM_STATUS, 0, 'CANCELED', 1, 'ACTIVE', ALARM_STATUS) ALARM_STATUS,
               ALARM_TIME AS ALARM_TIME,
              CANCEL_TIME AS CANCEL_TIME,
               ROUND(DECODE(CANCEL_TIME,
                            NULL,
                            DECODE(ALARM_STATUS,
                                   0,
                                   UPDATE_TIMESTAMP + 8 / 24 - ALARM_TIME,
                                   SYSDATE - ALARM_TIME),
                            CANCEL_TIME - ALARM_TIME) * 24,
                     2) AS DURATION_HOUR,
               ALARM_NUMBER,
               TEXT,
               SUPPLEMENTARY_INFO,
               DIAGNOSTIC_INFO
        
          FROM FX_ALARM
         WHERE 
         ALARM_STATUS = 1  --"1"代表当前告警，"0"代表历史告警
         ORDER BY ALARM_TIME) A,
         
       --cTP_COMMON_OBJECTS OBJ,
       cTP_COMMON_OBJECTS BTS

 WHERE --A.OC_ID = OBJ.CO_GID(+)
   --AND 
   
   A.NE_GID = BTS.CO_GID(+)
   
   AND BTS.CO_OC_ID IN (1547,1529, 1537)
 
   AND BTS.CO_STATE <> 3
   
 --and TO_NUMBER(BTS.CO_OBJECT_INSTANCE)>=&Start_ENBID
  --AND TO_NUMBER(BTS.CO_OBJECT_INSTANCE)<=&END_ENBID  --按范围查询
  --and ALARM_TIME>=to_date(&start_date,'yyyymmdd')
  --and ALARM_TIME<=to_date(&end_date,'yyyymmdd')    --按时间段查询
     --and BTS.CO_NAME like '&ENB_Name%'                      --按基站名称查询
 --and TO_NUMBER(BTS.CO_OBJECT_INSTANCE) in (&ENBID)          --查询某个站
 and alarm_number=71058
 ORDER BY ALARM_TIME
 )