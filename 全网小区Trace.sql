SELECT
        custom.area,
        custom.tech,
        custom.ECI,
        custom.lncel_enb_id,
        custom.lncel_lcr_id,
        tra.LCR_ID_FROM_0 AS MTRACE_ID,
        tra.Trace_DN,
        ver.BTS_Version,
        --substr(tra.Trace_DN,0,LENGTH(tra.Trace_DN)-18) AS LNBTS_DN,
        --substr(tra.Trace_DN,0,LENGTH(tra.Trace_DN)-9) AS CTLTR_DN,
        state.小区工作状态,
        state.小区管理锁状态,
        state.基站状态,
        alarm.告警号 as 告警号_断站告警,
        rrc.RRC连接建立请求次数,
        rrc.RRC连接成功次数,
        ver.BTS_NAME,
        '<managedObject class="MTRACE" version="'||ver.BTS_Version||'" distName="'||custom.Trace_DN||'" operation="delete"/>'   AS trace_delete,
        
        '<managedObject class="NOKLTE:CTRLTS" operation="create" version="'||ver.BTS_Version||'" distName="'||substr(custom.Trace_DN,0,LENGTH(custom.Trace_DN)-9)||'"><p name="cellTraceRepMode">0</p><p name="extCellTraceRep">1</p><p name="extUeTraceRep">1</p><p name="maxUeTraceSessions">60</p><p name="netActIpAddr">10.100.162.15</p><p name="omsTracePortNum">49392</p><p name="taTracing">1</p><p name="tceTracePortNum">49151</p><p name="ueTraceRepMode">0</p></managedObject>' AS CTRLTS,
        
        '<managedObject class="NOKLTE:LNBTS" operation="update" version="'||ver.BTS_Version||'" distName="'||substr(custom.Trace_DN,0,LENGTH(custom.Trace_DN)-18)||'"><p name="actCellTrace">1</p><p name="actMDTCellTrace">1</p><p name="actVendSpecCellTraceEnh">1</p></managedObject>' AS LNBTS
        
       
FROM
      


   

   
        (Select
            c.lncel_objid as lncel_id,
            (CASE
            WHEN c.city='Xian'  THEN '西安'
            WHEN c.city='Baoji'  THEN '宝鸡'
            WHEN c.city='Xianyang'  THEN '咸阳'
            WHEN c.city='Hanzhong'  THEN '汉中'
            WHEN c.city='Shangluo'  THEN '商洛'
            WHEN c.city='Tongchuan'  THEN '铜川'
            WHEN c.city='Yanan'  THEN '延安'
            WHEN c.city='Yulin'  THEN '榆林'
            ELSE NULL END) as area,
            c.netmodel as tech,
            --To_Date(To_Char(luest.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') As day,
            
            substr(ctp.co_dn,0,LENGTH(ctp.co_dn)-8)||'/CTRLTS-1/MTRACE-'||(SUBSTR(c.lncel_lcr_id,0,1)-1) AS Trace_DN,
            c.lnbtsid+0 as lncel_enb_id,

            (CASE
            WHEN c.lncel_lcr_id>10  THEN c.lncel_lcr_id+0           --兼容lcr为1位数和2位数
            WHEN c.lncel_lcr_id<10  THEN c.lncel_lcr_id*10+1
            ELSE NULL END) as lncel_lcr_id,


            (CASE
            WHEN c.lncel_lcr_id>10  THEN c.lnbtsid*256+c.lncel_lcr_id           --兼容lcr为1位数和2位数
            WHEN c.lncel_lcr_id<10  THEN c.lnbtsid*256+c.lncel_lcr_id*10+1
            ELSE NULL END) as eci



            From
            C_LTE_CUSTOM C 
            left JOIN ctp_common_objects ctp ON ctp.co_gid=c.lncel_objid

        ) custom



    
LEFT JOIN       
(Select
            To_Date(To_Char(luest.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') As day,
            
            c.lnbtsid+0 as lncel_enb_id,

            (CASE
            WHEN c.lncel_lcr_id>10  THEN c.lncel_lcr_id+0           --兼容lcr为1位数和2位数
            WHEN c.lncel_lcr_id<10  THEN c.lncel_lcr_id*10+1
            ELSE NULL END) as lncel_lcr_id,


            (CASE
            WHEN c.lncel_lcr_id>10  THEN c.lnbtsid*256+c.lncel_lcr_id           --兼容lcr为1位数和2位数
            WHEN c.lncel_lcr_id<10  THEN c.lnbtsid*256+c.lncel_lcr_id*10+1
            ELSE NULL END) as eci,



            decode(c.version,'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D +
            luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(
            luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D +
            luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,
            luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))) As RRC连接建立请求次数,

            Sum(luest.SIGN_CONN_ESTAB_COMP) As RRC连接成功次数

            From
            C_LTE_CUSTOM C 
            LEFT join NOKLTE_PS_LUEST_LNCEL_day luest On c.lncel_objid = luest.lncel_id

            Where
            luest.PERIOD_START_TIME = To_Date(&start_date, 'yyyy-mm-dd')

            Group By
            luest.PERIOD_START_TIME,
            c.lnbtsid,
            c.lncel_lcr_id,
            c.version
        ) rrc ON   custom.ECI = rrc.ECI
        


LEFT JOIN 

  (SELECT 
                CO_DN AS Trace_DN,
                SUBSTR(CO_DN,INSTR(CO_DN,'CTRLTS')-7,6) AS BTS_ID,
                CO_OBJECT_INSTANCE+1  AS LCR_ID,
                CO_OBJECT_INSTANCE  AS LCR_ID_FROM_0,
                TO_NUMBER(SUBSTR(CO_DN,INSTR(CO_DN,'CTRLTS')-7,6))*256+(CO_OBJECT_INSTANCE+1)*10+1  AS ECI

        FROM
                ctp_common_objects      
                
        WHERE

                --co_dn = 'PLMN-PLMN/MRBTS-772837/LNBTS-772837/CTRLTS-1/MTRACE-1'
                co_oc_id='1538'
        ) tra ON tra.eci = rrc.eci
        
LEFT JOIN
        (select 
                ctp.co_object_instance,
                ctp.co_name AS BTS_NAME,
                ctp.co_sys_version AS BTS_Version,
                ctp.co_oc_id,
                ctp.co_dn
        from
                ctp_common_objects ctp
                
        where
         ctp.co_oc_id  in ('1547', '2429')
        )  ver     ON     rrc.lncel_enb_id = ver.co_object_instance
        
        
LEFT JOIN     
        (select
              bts.co_object_instance btsid, --站号
              bts.co_name Site_name, --站名
              lncel.lncel_cell_name Cell_name, --小区名
              lncel.LNCEL_LCR_ID LCRID, --小区号
              bts.co_object_instance*256 + lncel.LNCEL_LCR_ID  AS ECI,
              decode(lncel.lncel_os_132,1,'enable',0,'disable') "小区工作状态", --小区工作状态
              decode(lncel.lncel_as_26,1,'unlock',2,'shutting down',3,'lock') "小区管理锁状态",--小区管理锁状态
              Decode(lnbts.lnbts_os_46,0,'initializing',1,'commissioned',2,'notCommisioned',3,'configured',4,'integrated to RAN',5,'onAir',6,'test',lnbts.lnbts_os_46) "基站状态"--基站状态
        from
              c_lte_lncel lncel, --小区配置表
              c_lte_lnbts lnbts, --基站配置表
              ctp_common_objects cel, --对象表
              ctp_common_objects bts --对象表
              
        where
                lncel.obj_gid=cel.co_gid ---表链接关系
            and cel.co_parent_gid=bts.co_gid ---表链接关系
            and lnbts.obj_gid=bts.co_gid ---表链接关系
            
            and lncel.conf_id=1 ---限制条件
            and lnbts.conf_id=1 ---限制条件
           
            --and lncel.LNCEL_LCR_ID is not null ---限制条件
            --and ((lncel.lncel_os_132<>1) or (lnbts.lnbts_os_46<>5)) ---限制条件
        order by
               btsid,
               lcrid
        )    state ON rrc.eci=state.eci
        
        
        
left join 
(select * from 

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

) alarm on alarm.ENB = custom.lncel_enb_id

          

ORDER BY
    tra.ECI
        
