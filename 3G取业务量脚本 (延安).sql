SELECT
    celltp.rpdate,
    celltp.wcel_rnc_id,
    celltp.wcel_c_id,
    celltp.PSR99DL���������� AS "PSR99DL����������(MB)",
    celltp.PSR99UL���������� AS "PSR99UL����������(MB)",
    celltp.HSDPA���������� AS "HSDPA����������(MB)",
    celltp.HSUPA���������� AS "HSUPA����������(MB)",
    servlev.����ҵ������ AS "����ҵ������(Erl)",
    servlev.���ӵ绰���� AS "���ӵ绰����(Erl)",    
    traffic.�������л����� AS "�������л�����"
FROM    
    (SELECT 
        to_char(a.PERIOD_START_TIME,'yyyymmddhh24') rpdate,
        i.wcel_rnc_id,
        i.wcel_c_id,       
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum(a.NRT_DCH_DL_DATA_VOL/1000/1000)),4) "PSR99DL����������",
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum((a.NRT_DCH_UL_DATA_VOL+a.NRT_DCH_HSDPA_UL_DATA_VOL )/1000/1000)),4) "PSR99UL����������",
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum(a.HS_DSCH_DATA_VOL/1000/1000)),4) "HSDPA����������",
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum(a.NRT_EDCH_UL_DATA_VOL/1000/1000)),4) "HSUPA����������"
    from 
        NOKRWW_PS_CELLTP_MNC1_RAW a,
        c_rnc_wcel i
    where
         a.period_start_time >= to_date('&start_datetime', 'yyyymmddhh24')   
         and a.period_start_time < to_date('&end_datetime', 'yyyymmddhh24')
         and a.wcel_id = i.obj_gid
         and i.conf_id =1
         and i.wcel_rnc_id    in (3128,3129,3131,3132)
         --and i.wcel_c_id LIKE('4785%')
     group by 
       to_char(a.PERIOD_START_TIME,'yyyymmddhh24'),
        i.wcel_rnc_id,
        i.wcel_c_id
    ) celltp,
       
        
    (SELECT 
        to_char(b.PERIOD_START_TIME,'yyyymmddhh24') rpdate,
        i.wcel_rnc_id,
        i.wcel_c_id,       
        round(SUM((b.avg_rab_hld_tm_cs_voice) / (b.PERIOD_DURATION * 100 * 60)),6) "����ҵ������",
        round(SUM((b.RAB_HOLD_TIME_CS_CONV_64) / (b.PERIOD_DURATION * 100 * 60)),6) "���ӵ绰����"
    from 
        NOKRWW_PS_SERVLEV_MNC1_RAW b,
        c_rnc_wcel i
    where
         b.period_start_time >= to_date('&start_datetime', 'yyyymmddhh24')   
         and b.period_start_time <= to_date('&end_datetime', 'yyyymmddhh24')
         and b.wcel_id = i.obj_gid
         and i.conf_id =1
         and i.wcel_rnc_id    in (3128,3129,3131,3132)
         --and i.wcel_c_id LIKE('4785%')
     group by 
       to_char(b.PERIOD_START_TIME,'yyyymmddhh24'),
        i.wcel_rnc_id,
        i.wcel_c_id
    ) servlev,
        
       
    (SELECT 
        to_char(traffic.PERIOD_START_TIME,'yyyymmddhh24') rpdate,
        i.wcel_rnc_id,
        i.wcel_c_id,       
        Round(SUM((traffic.DUR_FOR_AMR_4_75_UL_IN_SRNC+ traffic.DUR_FOR_AMR_5_15_UL_IN_SRNC +
            traffic.DUR_FOR_AMR_5_9_UL_IN_SRNC+ traffic.DUR_FOR_AMR_6_7_UL_IN_SRNC+
            traffic.DUR_FOR_AMR_7_4_UL_IN_SRNC+ traffic.DUR_FOR_AMR_7_95_UL_IN_SRNC+
            traffic.DUR_FOR_AMR_10_2_UL_IN_SRNC+ traffic.DUR_FOR_AMR_12_2_UL_IN_SRNC)/(traffic.PERIOD_DURATION*100*60)),6)
            As �������л�����
    from 
        NOKRWW_PS_TRAFFIC_MNC1_RAW traffic,
        c_rnc_wcel i
    where
         traffic.period_start_time >= to_date('&start_datetime', 'yyyymmddhh24')   
         and traffic.period_start_time < to_date('&end_datetime', 'yyyymmddhh24')
         and traffic.wcel_id = i.obj_gid
         and i.conf_id =1
         and i.wcel_rnc_id    in (3128,3129,3131,3132)
         --and i.wcel_c_id LIKE('4785%')
    group by 
       to_char(traffic.PERIOD_START_TIME,'yyyymmddhh24'),
        i.wcel_rnc_id,
        i.wcel_c_id
    ) traffic 

WHERE
        celltp.rpdate = servlev.rpdate and celltp.rpdate = traffic.rpdate 
    and celltp.wcel_rnc_id = servlev.wcel_rnc_id and celltp.wcel_rnc_id = traffic.wcel_rnc_id
    and celltp.wcel_c_id = servlev.wcel_c_id and celltp.wcel_c_id = traffic.wcel_c_id
