SELECT
    celltp.rpdate,
    celltp.wcel_rnc_id,
    celltp.wcel_c_id,
    celltp.PSR99DL数据吞吐量 AS "PSR99DL数据吞吐量(MB)",
    celltp.PSR99UL数据吞吐量 AS "PSR99UL数据吞吐量(MB)",
    celltp.HSDPA数据吞吐量 AS "HSDPA数据吞吐量(MB)",
    celltp.HSUPA数据吞吐量 AS "HSUPA数据吞吐量(MB)",
    servlev.话音业务话务量 AS "话音业务话务量(Erl)",
    servlev.可视电话务量 AS "可视电话务量(Erl)",    
    traffic.语音含切话务量 AS "语音含切话务量"
FROM    
    (SELECT 
        to_char(a.PERIOD_START_TIME,'yyyymmddhh24') rpdate,
        i.wcel_rnc_id,
        i.wcel_c_id,       
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum(a.NRT_DCH_DL_DATA_VOL/1000/1000)),4) "PSR99DL数据吞吐量",
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum((a.NRT_DCH_UL_DATA_VOL+a.NRT_DCH_HSDPA_UL_DATA_VOL )/1000/1000)),4) "PSR99UL数据吞吐量",
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum(a.HS_DSCH_DATA_VOL/1000/1000)),4) "HSDPA数据吞吐量",
        round(decode(sum(a.PERIOD_DURATION*1000*60),0,0,sum(a.NRT_EDCH_UL_DATA_VOL/1000/1000)),4) "HSUPA数据吞吐量"
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
        round(SUM((b.avg_rab_hld_tm_cs_voice) / (b.PERIOD_DURATION * 100 * 60)),6) "话音业务话务量",
        round(SUM((b.RAB_HOLD_TIME_CS_CONV_64) / (b.PERIOD_DURATION * 100 * 60)),6) "可视电话务量"
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
            As 语音含切话务量
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
