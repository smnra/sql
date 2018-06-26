select 
    lncel.lncel_eutra_cel_id as ECI,
    lncel.ci - 0 as ci,
    lncel.lncel_id,
    lncel.city,
    lncel.netmodel,
    lncel.lncel_enb_id - 0 as lncel_enb_id_lncel,
    lncel.lncel_lcr_id as lncel_lcr_id_lncel,
    lncel.LNCELID - 0 as LNCELID,
    lncel.eci,
    
    (CASE 
        WHEN instr(Upper(lncel.cell_name),'BBU')>0 THEN 'SHIFEN'
        WHEN instr(Upper(lncel.cell_name),'SF') >0 THEN 'SHIFEN'
        WHEN instr(Upper(lncel.cell_name),'ML') >0 THEN 'SHIFEN'
        WHEN lncel.cell_name is null THEN '��ȷ��'

    else null end) AS վ��,
      
    btsversion.BTS_Version,
    lncel.cell_name,
    lncel.cell_dn,
    lncel.trace_dn,

    mr.MR_Servr as MR_Servr_mr,
    mr.server_ip_address as server_ip_address_mr,
    
    
    
    
      '<managedObject class="MTRACE" version="'||btsversion.BTS_Version||'" distName="'||lncel.trace_dn||'" operation="delete"/>' AS trace_delete,  
    
    (case when (btsversion.BTS_Version = 'FL16A' or btsversion.BTS_Version = 'FLF16A') then 
    '<managedObject class="NOKLTE:CTRLTS" operation="create" version="'||btsversion.BTS_Version||'" distName="'||substr(lncel.trace_dn,1,instr(lncel.trace_dn,'/MTRACE-') - 1)||'"><p name="cellTraceRepMode">0</p><p name="extCellTraceRep">1</p><p name="extUeTraceRep">1</p><p name="maxUeTraceSessions">60</p><p name="subscriberMDTObtainLocation">1</p><p name="netActIpAddr">10.100.162.15</p><p name="omsTracePortNum">49392</p><p name="taTracing">1</p><p name="tceTracePortNum">49151</p><p name="ueTraceRepMode">0</p></managedObject>'
    else 
    '<managedObject class="NOKLTE:CTRLTS" operation="create" version="'||btsversion.BTS_Version||'" distName="'||substr(lncel.trace_dn,1,instr(lncel.trace_dn,'/MTRACE-') - 1)||'"><p name="cellTraceRepMode">0</p><p name="extCellTraceRep">1</p><p name="extUeTraceRep">1</p><p name="maxUeTraceSessions">60</p><p name="netActIpAddr">10.100.162.15</p><p name="omsTracePortNum">49392</p><p name="taTracing">1</p><p name="tceTracePortNum">49151</p><p name="ueTraceRepMode">0</p></managedObject>' 
    end ) AS CTRLTS,

    
    '<managedObject class="NOKLTE:LNBTS" operation="update" version="'||btsversion.BTS_Version||'" distName="'||substr(lncel.trace_dn,1,instr(lncel.trace_dn,'/CTRLTS-') - 1)||'"><p name="actCellTrace">1</p><p name="actMDTCellTrace">1</p><p name="actVendSpecCellTraceEnh">1</p></managedObject>' AS LNBTS,
    
    mr.Trace_State as Trace_State_mr,   
    
    mr.fqdn as fqdn_mr,
    mr.cm_trace_fqdn as cm_trace_fqdn_mr,
    state.С������״̬,
    state.С��������״̬,
    state.��վ״̬,
    alarm.�澯��,
    alarm.�澯����,
    lcelav.lncel_id as lncel_id_lcelav,
    lcelav.LTEС�������ʷ�ĸ as LTEС�������ʷ�ĸ
    
from 
    (SELECT 
            lncel.obj_gid as lncel_id,
            lncel.lncel_enb_id,
            lncel.lncel_lcr_id,
            lncel.lncel_eutra_cel_id,
            (CASE  
                WHEN LNCEL.LNCEL_TAC >=37119 and LNCEL.LNCEL_TAC <=37231 Then 'Xian'  
                WHEN LNCEL.LNCEL_TAC >=37232 and LNCEL.LNCEL_TAC <=37247 Then 'Xianyang'  
                WHEN LNCEL.LNCEL_TAC >=37248 and LNCEL.LNCEL_TAC <=37263 Then 'Baoji'  
                WHEN LNCEL.LNCEL_TAC >=37312 and LNCEL.LNCEL_TAC <=37327 Then 'Tongchuan'  
                WHEN LNCEL.LNCEL_TAC >=37296 and LNCEL.LNCEL_TAC <=37311 Then 'Yanan'  
                WHEN LNCEL.LNCEL_TAC >=37280 and LNCEL.LNCEL_TAC <=37295 Then 'Yulin'  
                WHEN LNCEL.LNCEL_TAC >=37328 and LNCEL.LNCEL_TAC <=37343 Then 'Hanzhong'  
                WHEN LNCEL.LNCEL_TAC >=37344 and LNCEL.LNCEL_TAC <=37359 Then 'Shangluo'  
            END) AS City, 
            (CASE 
                WHEN LNCEL.lncel_earfcn IS NOT NULL THEN 'TDD' 
                WHEN LNCEL.lncel_earfcn_dl IS NOT NULL THEN 'FDD'
            END) AS NetModel,
            
            CONCAT(lncel.lncel_enb_id,lncel.lncel_lcr_id) AS CI,
            ctp.CO_OBJECT_INSTANCE AS LNCELID,
            lncel.lncel_enb_id * 256 + lncel.lncel_lcr_id as ECI,
            ctp.co_name AS cell_name,
            substr( replace(ctp.co_dn,'/LNCEL-' , '/CTRLTS-1/MTRACE-'), 1,instr(replace(ctp.co_dn,'/LNCEL-' , '/CTRLTS-1/MTRACE-'),'MTRACE-') + 6 )|| (ctp.CO_OBJECT_INSTANCE - 1) as trace_dn,
            ctp.co_dn as cell_dn
            
    FROM
            c_lte_lncel lncel
            LEFT JOIN ctp_common_objects ctp ON ctp.co_gid = lncel.obj_gid
    WHERE 
            lncel.conf_id = 1
    ) lncel







left join 
    (SELECT
            lcelav.lncel_id,
            SUM(lcelav.DENOM_CELL_AVAIL) AS  LTEС�������ʷ�ĸ

    FROM 
            Noklte_Ps_Lcelav_Mnc_Raw  lcelav

    WHERE
            lcelav.period_start_time = to_date(&start_datetime, 'yyyymmdd')
             
    GROUP BY
            lcelav.lncel_id
            
    ) lcelav on lcelav.lncel_id = lncel.lncel_id









left join 
    (SELECT
        (CASE    WHEN  trace_header.server_ip_address = '10.100.162.112' THEN 'MR1'
                    WHEN  trace_header.server_ip_address = '10.100.162.111' THEN 'MR2'
                    WHEN  trace_header.server_ip_address = '10.100.162.110' THEN 'MR3'
                    WHEN  trace_header.server_ip_address = '10.100.162.109' THEN 'MR4'
                    WHEN  trace_header.server_ip_address = '10.100.162.108' THEN 'MR5'
                    WHEN  trace_header.server_ip_address = '10.100.162.115' THEN 'MR6'
                    WHEN  trace_header.server_ip_address = '10.100.162.117' THEN 'MR7'
                    WHEN  trace_header.server_ip_address = '10.100.162.119' THEN 'MR8'
                    WHEN  trace_header.server_ip_address = '10.100.162.120' THEN 'MR9'
        ELSE NULL
        END  ) AS MR_Servr,
        
        trace_header.server_ip_address,
        ne.name,
        ne.state AS Trace_State,
        ne.fqdn,
        ne.cm_trace_fqdn



        
        
        
    from 
        trc.cor_trace_ne_status ne 
        left join trc.cor_lte_trace_header  trace_header  on trace_header.trace_header_id = ne.trace_header_id

 
    where
        ne.state = 'ACTIVE' 
        --AND c.state = 'DELETED'
    ) mr on mr.fqdn = lncel.cell_dn


left join 
(
SELECT substr(BTS.CO_DN,16,6) ENB,
       TO_NUMBER(DECODE(BTS.CO_OC_ID, 1537, bts.CO_OBJECT_INSTANCE, NULL)) AS "С����",
       BTS.CO_NAME,

       decode(BTS.CO_OC_ID,
              '2429',
              'MRBTS',
              '1529',
              'LNBTS',
              '1537',
              'LNCEL',
              '') "����",
       SEVERITY AS "�澯����",
       ALARM_STATUS "״̬",
       ALARM_NUMBER "�澯��",
       SUPPLEMENTARY_INFO AS "�澯����",
       TEXT AS "��ҵ��Ӱ��",
       DIAGNOSTIC_INFO AS "�澯ID",
       ALARM_TIME AS "�澯ʱ��",
       CANCEL_TIME AS "���ʱ��",
       DURATION_HOUR AS "�澯����ʱ��(Сʱ��",
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
         ALARM_STATUS = 1  --"1"����ǰ�澯��"0"������ʷ�澯
         ORDER BY ALARM_TIME) A,
         
       --cTP_COMMON_OBJECTS OBJ,
       cTP_COMMON_OBJECTS BTS

 WHERE --A.OC_ID = OBJ.CO_GID(+)
   --AND 
   
   A.NE_GID = BTS.CO_GID(+)
   
   AND BTS.CO_OC_ID IN (2429,1529, 1537)
 
   AND BTS.CO_STATE <> 3
   
 --and TO_NUMBER(BTS.CO_OBJECT_INSTANCE)>=&Start_ENBID
  --AND TO_NUMBER(BTS.CO_OBJECT_INSTANCE)<=&END_ENBID  --����Χ��ѯ
  --and ALARM_TIME>=to_date(&start_date,'yyyymmdd')
  --and ALARM_TIME<=to_date(&end_date,'yyyymmdd')    --��ʱ��β�ѯ
     --and BTS.CO_NAME like '&ENB_Name%'                      --����վ���Ʋ�ѯ
 --and TO_NUMBER(BTS.CO_OBJECT_INSTANCE) in (&ENBID)          --��ѯĳ��վ
 --and alarm_number=9047
 ORDER BY ALARM_TIME
) alarm on  alarm.ENB = lncel.lncel_enb_id and  alarm.С����  = lncel.lncelid



LEFT JOIN     
        (select
              bts.co_object_instance btsid, --վ��
              bts.co_name Site_name, --վ��
              lncel.lncel_cell_name Cell_name, --С����
              lncel.LNCEL_LCR_ID LCRID, --С����
              bts.co_object_instance*256 + lncel.LNCEL_LCR_ID  AS ECI,
              decode(lncel.lncel_os_132,1,'enable',0,'disable') "С������״̬", --С������״̬
              decode(lncel.lncel_as_26,1,'unlock',2,'shutting down',3,'lock') "С��������״̬",--С��������״̬
              Decode(lnbts.lnbts_os_46,0,'initializing',1,'commissioned',2,'notCommisioned',3,'configured',4,'integrated to RAN',5,'onAir',6,'test',lnbts.lnbts_os_46) "��վ״̬"--��վ״̬
        from
              c_lte_lncel lncel, --С�����ñ�
              c_lte_lnbts lnbts, --��վ���ñ�
              ctp_common_objects cel, --�����
              ctp_common_objects bts --�����
              
        where
                lncel.obj_gid=cel.co_gid ---�����ӹ�ϵ
            and cel.co_parent_gid=bts.co_gid ---�����ӹ�ϵ
            and lnbts.obj_gid=bts.co_gid ---�����ӹ�ϵ
            
            and lncel.conf_id=1 ---��������
            and lnbts.conf_id=1 ---��������
           
            --and lncel.LNCEL_LCR_ID is not null ---��������
            --and ((lncel.lncel_os_132<>1) or (lnbts.lnbts_os_46<>5)) ---��������
        order by
               btsid,
               lcrid
        )    state ON lncel.lncel_eutra_cel_id=state.eci and  state.eci is not null





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
         ctp.co_oc_id  in ('1547', '2429','7181','7008')
        )  btsversion  ON lncel.lncel_enb_id = btsversion.co_object_instance and  btsversion.co_object_instance is not null
