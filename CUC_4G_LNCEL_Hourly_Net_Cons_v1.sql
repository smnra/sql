----------------------------------------------------------------------------------------------------
-- Title: CUC_4G_LNCEL_Hourly_Net_Cons_v1.sql
-- Format: operator_xg_objectlevel_timelevel_purpose_version
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--Ver : xx -Date: yyyy.mm.dd  -Auther: xxxxxxxx - 说明: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
--Ver : v1 -Date: 2017.4.4  -Auther: Kongdejun - 说明: 用于联通网建KPI提取 (LTE/LNCEL/HOURLY)
----------------------------------------------------------------------------------------------------

select   --项目可自定义查询项

    lncel_kpi.period_start_time
    ,conf.PROVINCE
    ,conf.CITY
    ,conf.NETMODE
    ,conf.LNCEL_EARFCN_DL
    ,conf.LNCEL_DL_CH_BW as LNCEL_BW
    --,conf.LNBTS_ID
    --,conf.LNCEL_ID
    ,conf.LNCEL_ENB_ID
    ,conf.LNCEL_LCR_ID
    ,conf.lncel_cell_name
    
    ,lncel_kpi."M8029C1" as TIMING_ADV_BIN_1
    ,lncel_kpi."M8029C2" as TIMING_ADV_BIN_2
    ,lncel_kpi."M8029C3" as TIMING_ADV_BIN_3
    ,lncel_kpi."M8029C4" as TIMING_ADV_BIN_4
    ,lncel_kpi."M8029C5" as TIMING_ADV_BIN_5
    ,lncel_kpi."M8029C6" as TIMING_ADV_BIN_6
    ,lncel_kpi."M8029C7" as TIMING_ADV_BIN_7
    ,lncel_kpi."M8029C8" as TIMING_ADV_BIN_8
    ,lncel_kpi."M8029C9" as TIMING_ADV_BIN_9
    ,lncel_kpi."M8029C10" as TIMING_ADV_BIN_10
    ,lncel_kpi."M8029C11" as TIMING_ADV_BIN_11
    ,lncel_kpi."M8029C12" as TIMING_ADV_BIN_12
    ,lncel_kpi."M8029C13" as TIMING_ADV_BIN_13
    ,lncel_kpi."M8029C14" as TIMING_ADV_BIN_14
    ,lncel_kpi."M8029C15" as TIMING_ADV_BIN_15
    ,lncel_kpi."M8029C16" as TIMING_ADV_BIN_16
    ,lncel_kpi."M8029C17" as TIMING_ADV_BIN_17
    ,lncel_kpi."M8029C18" as TIMING_ADV_BIN_18
    ,lncel_kpi."M8029C19" as TIMING_ADV_BIN_19
    ,lncel_kpi."M8029C20" as TIMING_ADV_BIN_20
    ,lncel_kpi."M8029C21" as TIMING_ADV_BIN_21
    ,lncel_kpi."M8029C22" as TIMING_ADV_BIN_22
    ,lncel_kpi."M8029C23" as TIMING_ADV_BIN_23
    ,lncel_kpi."M8029C24" as TIMING_ADV_BIN_24
    ,lncel_kpi."M8029C25" as TIMING_ADV_BIN_25
    ,lncel_kpi."M8029C26" as TIMING_ADV_BIN_26
    ,lncel_kpi."M8029C27" as TIMING_ADV_BIN_27
    ,lncel_kpi."M8029C28" as TIMING_ADV_BIN_28
    ,lncel_kpi."M8029C29" as TIMING_ADV_BIN_29
    ,lncel_kpi."M8029C30" as TIMING_ADV_BIN_30
    ,lncel_kpi."LTE_411a" as UE_REP_CQI_LEVEL_00
    ,lncel_kpi."LTE_412a" as UE_REP_CQI_LEVEL_01
    ,lncel_kpi."LTE_413a" as UE_REP_CQI_LEVEL_02
    ,lncel_kpi."LTE_414a" as UE_REP_CQI_LEVEL_03
    ,lncel_kpi."LTE_415a" as UE_REP_CQI_LEVEL_04
    ,lncel_kpi."LTE_416a" as UE_REP_CQI_LEVEL_05
    ,lncel_kpi."LTE_417a" as UE_REP_CQI_LEVEL_06
    ,lncel_kpi."LTE_418a" as UE_REP_CQI_LEVEL_07
    ,lncel_kpi."LTE_419a" as UE_REP_CQI_LEVEL_08
    ,lncel_kpi."LTE_420a" as UE_REP_CQI_LEVEL_09
    ,lncel_kpi."LTE_421a" as UE_REP_CQI_LEVEL_10
    ,lncel_kpi."LTE_422a" as UE_REP_CQI_LEVEL_11
    ,lncel_kpi."LTE_423a" as UE_REP_CQI_LEVEL_12
    ,lncel_kpi."LTE_424a" as UE_REP_CQI_LEVEL_13
    ,lncel_kpi."LTE_425a" as UE_REP_CQI_LEVEL_14
    ,lncel_kpi."LTE_426a" as UE_REP_CQI_LEVEL_15
    ,lncel_kpi."CUCL_31a" as ERAB_INIT_QCI4_9
    ,lncel_kpi."CUCL_35b" as REPORTS_RSRP_A2_REDIR
    ,lncel_kpi."CUCL_35a" as REPORTS_RSRP_A2_REDIR1
    ,conf.LNCEL_UL_CH_BW  as LNCEL_UL_CH_BW_D2
    ,lncel_kpi."CUCL_25a" as "上行PRB占用平均数"
    ,conf.LNCEL_DL_CH_BW  as LNCEL_DL_CH_BW_D2
    ,lncel_kpi."CUCL_26a" as "下行PRB占用平均数"
    ,conf.LNCEL_MAX_NUM_RRC as LNCEL_MAX_NUM_RRC
    ,lncel_kpi."CUCL_32a" as "PDCP_SDU_VOL_UL（兆比特）"
    ,lncel_kpi."CUCL_33a" as "PDCP_SDU_VOL_DL（兆比特）"
    ,lncel_kpi."CUCL_34a" as "SAMPLES_CELL_AVAIL*10(秒)"
    ,conf.LNCEL_P_MAX  as "MAX_TRANS_PWR（瓦）"

from
    --------------------------------------------------------------------------------------------
    ----conf: PLMN, no config
    --------------------------------------------------------------------------------------------
    (select
        cel.CO_PARENT_GID         as LNBTS_ID
        ,lncel.obj_gid            as LNCEL_ID
        ,lncel.lncel_enb_id       as LNCEL_ENB_ID
        ,lncel.lncel_lcr_id       as LNCEL_LCR_ID
        ,lncel.lncel_cell_name as lncel_cell_name
        ,(CASE WHEN LNCEL.lncel_earfcn IS NOT NULL THEN 'TDD' 
               WHEN LNCEL.lncel_earfcn_dl IS NOT NULL THEN 'FDD'  
               END)               as NETMODE
        ,'Shaanxi'                as PROVINCE
        
        
        
        ,(CASE 
            WHEN LNCEL.LNCEL_TAC >=37119 and LNCEL.LNCEL_TAC <=37231 Then 'Xian'  
            WHEN LNCEL.LNCEL_TAC >=37232 and LNCEL.LNCEL_TAC <=37247 Then 'Xianyang'  
            WHEN LNCEL.LNCEL_TAC >=37248 and LNCEL.LNCEL_TAC <=37263 Then 'Baoji'  
            WHEN LNCEL.LNCEL_TAC >=37312 and LNCEL.LNCEL_TAC <=37327 Then 'Tongchuan'  
            WHEN LNCEL.LNCEL_TAC >=37296 and LNCEL.LNCEL_TAC <=37311 Then 'Yanan'  
            WHEN LNCEL.LNCEL_TAC >=37280 and LNCEL.LNCEL_TAC <=37295 Then 'Yulin'  
            WHEN LNCEL.LNCEL_TAC >=37328 and LNCEL.LNCEL_TAC <=37343 Then 'Hanzhong'  
            WHEN LNCEL.LNCEL_TAC >=37344 and LNCEL.LNCEL_TAC <=37359 Then 'Shangluo'  
        else 'Other' END)  as CITY 
       
               
        ,lncel.LNCEL_TAC          as LNCEL_TAC
        ,decode(lncel.LNCEL_UL_CH_BW,14,'6',30,'15',50,'25',100,'50',150,'75',200,'100') LNCEL_UL_CH_BW
        ,decode(lncel.LNCEL_DL_CH_BW,14,'6',30,'15',50,'25',100,'50',150,'75',200,'100') LNCEL_DL_CH_BW
        ,lncel.LNCEL_MAX_NUM_RRC  as LNCEL_MAX_NUM_RRC
        ,Round(POWER(10,lncel.LNCEL_P_MAX/100)/1000,0) as LNCEL_P_MAX
        ,(CASE WHEN LNCEL.lncel_earfcn IS NOT NULL THEN LNCEL.lncel_earfcn
               WHEN LNCEL.lncel_earfcn_dl IS NOT NULL THEN LNCEL.lncel_earfcn_dl
               END)               as LNCEL_EARFCN_DL
        
    from
        c_lte_lncel                lncel
        ,ctp_common_objects          cel
        
    where 
        lncel.obj_gid=cel.co_gid
        and lncel.conf_id=1
    )conf,
    
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-----  LNCEL KPI    -------------------------------------------------------------------
    (select
        to_char(LCELAV_kpi.period_start_time, 'hh24.mm.dd.yyyy') as period_start_time
        ,LCELAV_kpi.LNBTS_ID
        ,LCELAV_kpi.LNCEL_ID
        
        ,lmac_kpi."M8029C1"
        ,lmac_kpi."M8029C2"
        ,lmac_kpi."M8029C3"
        ,lmac_kpi."M8029C4"
        ,lmac_kpi."M8029C5"
        ,lmac_kpi."M8029C6"
        ,lmac_kpi."M8029C7"
        ,lmac_kpi."M8029C8"
        ,lmac_kpi."M8029C9"
        ,lmac_kpi."M8029C10"
        ,lmac_kpi."M8029C11"
        ,lmac_kpi."M8029C12"
        ,lmac_kpi."M8029C13"
        ,lmac_kpi."M8029C14"
        ,lmac_kpi."M8029C15"
        ,lmac_kpi."M8029C16"
        ,lmac_kpi."M8029C17"
        ,lmac_kpi."M8029C18"
        ,lmac_kpi."M8029C19"
        ,lmac_kpi."M8029C20"
        ,lmac_kpi."M8029C21"
        ,lmac_kpi."M8029C22"
        ,lmac_kpi."M8029C23"
        ,lmac_kpi."M8029C24"
        ,lmac_kpi."M8029C25"
        ,lmac_kpi."M8029C26"
        ,lmac_kpi."M8029C27"
        ,lmac_kpi."M8029C28"
        ,lmac_kpi."M8029C29"
        ,lmac_kpi."M8029C30"
        ,lpqdl_kpi."LTE_411a"
        ,lpqdl_kpi."LTE_412a"
        ,lpqdl_kpi."LTE_413a"
        ,lpqdl_kpi."LTE_414a"
        ,lpqdl_kpi."LTE_415a"
        ,lpqdl_kpi."LTE_416a"
        ,lpqdl_kpi."LTE_417a"
        ,lpqdl_kpi."LTE_418a"
        ,lpqdl_kpi."LTE_419a"
        ,lpqdl_kpi."LTE_420a"
        ,lpqdl_kpi."LTE_421a"
        ,lpqdl_kpi."LTE_422a"
        ,lpqdl_kpi."LTE_423a"
        ,lpqdl_kpi."LTE_424a"
        ,lpqdl_kpi."LTE_425a"
        ,lpqdl_kpi."LTE_426a"
        ,lepsb_kpi."CUCL_31a"
        ,lisho_kpi."CUCL_35a_x" - lepsb_kpi."CUCL_35a_y" as "CUCL_35a"
        ,lisho_kpi."CUCL_35a_x" - lepsb_kpi."CUCL_35a_y" as "CUCL_35b"
        ,lcellr_kpi."CUCL_25a"
        ,lcellr_kpi."CUCL_26a"
        ,lcellt_kpi."CUCL_32a"
        ,lcellt_kpi."CUCL_33a"
        ,LCELAV_kpi."CUCL_34a"
        
    from
    
    --------------------------------------------------------------------------------------------
    ----Table: : LCELAV (special one as first, other will follow M80xx sequence 
    --------------------------------------------------------------------------------------------\
        (select 
            period_start_time
            ,LNBTS_ID
            ,LNCEL_ID
            
            ,sum(SAMPLES_CELL_AVAIL)*10  as "CUCL_34a"
        
        from 
            NOKLTE_PS_LCELAV_LNCEL_HOUR   --M8020
            
        where
            period_start_time>=to_date(&start_date,'yyyymmddhh24')
            and period_start_time<to_date(&end_date,'yyyymmddhh24')
            --and LNBTS_ID in ('3002464')
        
        group by
            period_start_time
            ,LNBTS_ID
            ,LNCEL_ID
        )LCELAV_kpi,
            
        --------------------------------------------------------------------------------------------
        ----Table: LEPSB
        --------------------------------------------------------------------------------------------
        (select 
            period_start_time
            ,LNCEL_ID
            
            ,sum(ERAB_INI_SETUP_SUCC_QCI4+ERAB_INI_SETUP_SUCC_QCI5+ERAB_INI_SETUP_SUCC_QCI6+
              ERAB_INI_SETUP_SUCC_QCI7+ERAB_INI_SETUP_SUCC_QCI8+ERAB_INI_SETUP_SUCC_QCI9) as "CUCL_31a"
            ,SUM(ERAB_REL_ENB_RNL_RED) as "CUCL_35a_y"
            
        from 
            NOKLTE_PS_LEPSB_LNCEL_HOUR      --M8006
            
        where
            period_start_time>=to_date(&start_date,'yyyymmddhh24')
            and period_start_time<to_date(&end_date,'yyyymmddhh24')
            --and LNBTS_ID in ('3002464')
            
        group by
            period_start_time
            ,LNCEL_ID
        )LEPSB_kpi,
            
        --------------------------------------------------------------------------------------------
        ----Table: LPQDL
        --------------------------------------------------------------------------------------------
        (select 
            period_start_time
            ,LNCEL_ID
            
            ,sum(UE_REP_CQI_LEVEL_00)  as "LTE_411a"
            ,sum(UE_REP_CQI_LEVEL_01)  as "LTE_412a"
            ,sum(UE_REP_CQI_LEVEL_02)  as "LTE_413a"
            ,sum(UE_REP_CQI_LEVEL_03)  as "LTE_414a"
            ,sum(UE_REP_CQI_LEVEL_04)  as "LTE_415a"
            ,sum(UE_REP_CQI_LEVEL_05)  as "LTE_416a"
            ,sum(UE_REP_CQI_LEVEL_06) as "LTE_417a"
            ,sum(UE_REP_CQI_LEVEL_07) as "LTE_418a"
            ,sum(UE_REP_CQI_LEVEL_08)  as "LTE_419a"
            ,sum(UE_REP_CQI_LEVEL_09)  as "LTE_420a"
            ,sum(UE_REP_CQI_LEVEL_10)  as "LTE_421a"
            ,sum(UE_REP_CQI_LEVEL_11)  as "LTE_422a"
            ,sum(UE_REP_CQI_LEVEL_12)  as "LTE_423a"
            ,sum(UE_REP_CQI_LEVEL_13)  as "LTE_424a"
            ,sum(UE_REP_CQI_LEVEL_14)  as "LTE_425a"
            ,sum(UE_REP_CQI_LEVEL_15)  as "LTE_426a"
            
        from 
            NOKLTE_PS_LPQDL_LNCEL_HOUR      --M8010
            
        where
            period_start_time>=to_date(&start_date,'yyyymmddhh24')
            and period_start_time<to_date(&end_date,'yyyymmddhh24')
            --and LNBTS_ID in ('3002464')
            
        group by
            period_start_time
            ,LNCEL_ID
        )LPQDL_kpi,
            
        --------------------------------------------------------------------------------------------
        ----Table: LCELLR
        --------------------------------------------------------------------------------------------
        (select 
            period_start_time
            ,LNCEL_ID
            
            ,Round(sum(Decode(period_duration,0,0,PRB_USED_UL_TOTAL/period_duration/60000)),4) as "CUCL_25a"
            ,Round(sum(Decode(period_duration,0,0,PRB_USED_DL_TOTAL/period_duration/60000)),4) as "CUCL_26a"
            
        from 
            NOKLTE_PS_LCELLR_LNCEL_HOUR      --M8011
            
        where
            period_start_time>=to_date(&start_date,'yyyymmddhh24')
            and period_start_time<to_date(&end_date,'yyyymmddhh24')
            --and LNBTS_ID in ('3002464')
            
        group by
            period_start_time
            ,LNCEL_ID
        )LCELLR_kpi,
            
        --------------------------------------------------------------------------------------------
        ----Table: LCELLT
        --------------------------------------------------------------------------------------------
        (select 
            period_start_time
            ,LNCEL_ID
            
            ,8 * SUM(PDCP_SDU_VOL_UL)  as "CUCL_32a"
            ,8 * SUM(PDCP_SDU_VOL_DL)  as "CUCL_33a"
            
        from 
            NOKLTE_PS_LCELLT_LNCEL_HOUR      --M8012
            
        where
            period_start_time>=to_date(&start_date,'yyyymmddhh24')
            and period_start_time<to_date(&end_date,'yyyymmddhh24')
            --and LNBTS_ID in ('3002464')
            
        group by
            period_start_time
            ,LNCEL_ID
        )LCELLT_kpi,
            
        --------------------------------------------------------------------------------------------
        ----Table: LISHO
        --------------------------------------------------------------------------------------------
        (select 
            period_start_time
            ,LNCEL_ID
            
            ,SUM(CSFB_REDIR_CR_ATT) as "CUCL_35a_x"
            
        from 
            NOKLTE_PS_LISHO_LNCEL_HOUR      --M8016
            
        where
            period_start_time>=to_date(&start_date,'yyyymmddhh24')
            and period_start_time<to_date(&end_date,'yyyymmddhh24')
            --and LNBTS_ID in ('3002464')
            
        group by
            period_start_time
            ,LNCEL_ID
        )LISHO_kpi,
            
        --------------------------------------------------------------------------------------------
        ----Table: LMAC
        --------------------------------------------------------------------------------------------
        (select 
            period_start_time
            ,LNCEL_ID 
            
            ,sum(TIMING_ADV_BIN_1) as "M8029C1"
            ,sum(TIMING_ADV_BIN_2) as "M8029C2"
            ,sum(TIMING_ADV_BIN_3) as "M8029C3"
            ,sum(TIMING_ADV_BIN_4) as "M8029C4"
            ,sum(TIMING_ADV_BIN_5) as "M8029C5"
            ,sum(TIMING_ADV_BIN_6) as "M8029C6"
            ,sum(TIMING_ADV_BIN_7) as "M8029C7"
            ,sum(TIMING_ADV_BIN_8) as "M8029C8"
            ,sum(TIMING_ADV_BIN_9) as "M8029C9"
            ,sum(TIMING_ADV_BIN_10) as "M8029C10"
            ,sum(TIMING_ADV_BIN_11) as "M8029C11"
            ,sum(TIMING_ADV_BIN_12) as "M8029C12"
            ,sum(TIMING_ADV_BIN_13) as "M8029C13"
            ,sum(TIMING_ADV_BIN_14) as "M8029C14"
            ,sum(TIMING_ADV_BIN_15) as "M8029C15"
            ,sum(TIMING_ADV_BIN_16) as "M8029C16"
            ,sum(TIMING_ADV_BIN_17) as "M8029C17"
            ,sum(TIMING_ADV_BIN_18) as "M8029C18"
            ,sum(TIMING_ADV_BIN_19) as "M8029C19"
            ,sum(TIMING_ADV_BIN_20) as "M8029C20"
            ,sum(TIMING_ADV_BIN_21) as "M8029C21"
            ,sum(TIMING_ADV_BIN_22) as "M8029C22"
            ,sum(TIMING_ADV_BIN_23) as "M8029C23"
            ,sum(TIMING_ADV_BIN_24) as "M8029C24"
            ,sum(TIMING_ADV_BIN_25) as "M8029C25"
            ,sum(TIMING_ADV_BIN_26) as "M8029C26"
            ,sum(TIMING_ADV_BIN_27) as "M8029C27"
            ,sum(TIMING_ADV_BIN_28) as "M8029C28"
            ,sum(TIMING_ADV_BIN_29) as "M8029C29"
            ,sum(TIMING_ADV_BIN_30) as "M8029C30"
            
        from 
            NOKLTE_PS_LMAC_LNCEL_HOUR      --M5029
            
        where
            period_start_time>=to_date(&start_date,'yyyymmddhh24')
            and period_start_time<to_date(&end_date,'yyyymmddhh24')
            --and LNBTS_ID in ('3002464')
            
        group by
            period_start_time
            ,LNCEL_ID
        )LMAC_kpi
    
    where
        LCELAV_kpi.LNCEL_ID=LEPSB_kpi.LNCEL_ID(+)
        and LCELAV_kpi.LNCEL_ID=LPQDL_kpi.LNCEL_ID(+)
        and LCELAV_kpi.LNCEL_ID=LCELLR_kpi.LNCEL_ID(+)
        and LCELAV_kpi.LNCEL_ID=LCELLT_kpi.LNCEL_ID(+)
        and LCELAV_kpi.LNCEL_ID=LISHO_kpi.LNCEL_ID(+)
        and LCELAV_kpi.LNCEL_ID=LMAC_kpi.LNCEL_ID(+)
        
        and LCELAV_kpi.period_start_time=LEPSB_kpi.period_start_time(+)
        and LCELAV_kpi.period_start_time=LPQDL_kpi.period_start_time(+)
        and LCELAV_kpi.period_start_time=LCELLR_kpi.period_start_time(+)
        and LCELAV_kpi.period_start_time=LCELLT_kpi.period_start_time(+)
        and LCELAV_kpi.period_start_time=LISHO_kpi.period_start_time(+)
        and LCELAV_kpi.period_start_time=LMAC_kpi.period_start_time(+)
    )LNCEL_KPI
    
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-----  LNBTS KPI    -------------------------------------------------------------------
    --(select
    --    to_char(ls1ap_kpi.period_start_time, 'mm.dd.yyyy') as period_start_time
    --    ,ls1ap_kpi.LNBTS_ID
    --
    --    ,ls1ap_kpi."LTE_5121a"
    --
    --
    --from
    --    --------------------------------------------------------------------------------------------
    --    ----Table: LS1AP
    --    --------------------------------------------------------------------------------------------
    --    (select 
    --        period_start_time
    --        ,LNBTS_ID
    --        
    --        ,sum(S1_SETUP_ATT)  as "LTE_5121a"
    --        
    --    from 
    --        NOKLTE_PS_LS1AP_LNBTS_DAY  -- M8000
    --        
    --    where
    --        period_start_time>=to_date(&start_date,'yyyymmddhh24')
    --        and period_start_time<to_date(&end_date,'yyyymmddhh24')
    --        --and LNBTS_ID in ('3002464')
    --        
    --    group by
    --        period_start_time
    --        ,LNBTS_ID
    --    )LS1AP_kpi
    --    
    --    
    --where
    --    --LS1AP_kpi.period_start_time = LENBLD_kpi.period_start_time(+)
    --   
    --    --and LS1AP_kpi.LNBTS_ID = LENBLD_kpi.LNBTS_ID(+)
    --
    --)LNBTS_kpi
    
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
----  where, group and order
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
where
    LNCEL_kpi.LNCEL_ID=conf.LNCEL_ID(+)
    --
    --and LNCEL_kpi.LNBTS_ID=LNBTS_kpi.LNBTS_ID(+)
    --
    --and LNCEL_kpi.period_start_time=LNBTS_kpi.period_start_time(+)
    
--group by
    --LNCEL_kpi.period_start_time
    --,conf.PROVINCE
    --,conf.CITY
    --,conf.NETMODE
    --,conf.LNBTS_ID
    --,conf.LNCEL_ID
    --,conf.LNCEL_ENB_ID
    --,conf.LNCEL_LCR_ID
    --,conf.lncel_cell_name
        
order by
    LNCEL_kpi.period_start_time
    ,conf.CITY
    ,conf.CITY
    --,conf.NETMODE
    --,conf.LNBTS_ID
    --,conf.LNCEL_ID
    ,conf.LNCEL_ENB_ID
    ,conf.LNCEL_LCR_ID
