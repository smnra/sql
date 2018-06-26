SELECT
    c.city,
    c.wcel_rnc_id,
    c.wcel_wbts_id,
    c.wbts_name,
    c.ci,
    c.lcrid,
    To_Date(To_Char(servlev.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') As day,
    --Cast(To_Char(servlev.PERIOD_START_TIME, 'hh24') As Number) As hour,
    Round(Decode(Sum(servlev.RAB_ACT_COMP_CS_VOICE +
    servlev.RAB_ACT_REL_CS_VOICE_SRNC + servlev.RAB_ACT_REL_CS_VOICE_P_EMP +
    servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
    servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
    servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE),
    0, Null, Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU +
    servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
    servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
    servlev.RAB_ACT_FAIL_CS_VOICE_UE) / Sum(servlev.RAB_ACT_COMP_CS_VOICE +
    servlev.RAB_ACT_REL_CS_VOICE_SRNC + servlev.RAB_ACT_REL_CS_VOICE_P_EMP +
    servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
    servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
    servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE)),
    8) As 语音业务掉话率,
    Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
    servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
    servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE) As
    X_语音业务掉话率,
    Sum(servlev.RAB_ACT_COMP_CS_VOICE + servlev.RAB_ACT_REL_CS_VOICE_SRNC +
    servlev.RAB_ACT_REL_CS_VOICE_P_EMP + servlev.RAB_ACT_FAIL_CS_VOICE_IU +
    servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
    servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
    servlev.RAB_ACT_FAIL_CS_VOICE_UE) As Y_语音业务掉话率,
    
    
    Sum(servlev.RAB_ACT_COMP_CS_VOICE) AS RAB_ACT_COMP_CS_VOICE, 
    sum(servlev.RAB_ACT_REL_CS_VOICE_SRNC) AS RAB_ACT_REL_CS_VOICE_SRNC, 
    sum(servlev.RAB_ACT_REL_CS_VOICE_P_EMP) AS RAB_ACT_REL_CS_VOICE_P_EMP, 
    sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU ) AS RAB_ACT_FAIL_CS_VOICE_IU, 
    sum(servlev.RAB_ACT_FAIL_CS_VOICE_RADIO ) AS RAB_ACT_FAIL_CS_VOICE_RADIO, 
    sum(servlev.RAB_ACT_FAIL_CS_VOICE_BTS ) AS RAB_ACT_FAIL_CS_VOICE_BTS, 
    sum(servlev.RAB_ACT_FAIL_CS_VOICE_IUR ) AS RAB_ACT_FAIL_CS_VOICE_IUR, 
    sum(servlev.RAB_ACT_FAIL_CS_VOICE_RNC) AS RAB_ACT_FAIL_CS_VOICE_RNC, 
    sum(servlev.RAB_ACT_FAIL_CS_VOICE_UE) AS  RAB_ACT_FAIL_CS_VOICE_UE
 
From
    NOKRWW_PS_SERVLEV_WCEL_DAY   servlev
    INNER JOIN c_w_custom  c ON servlev.WCEL_ID = c.wcel_objid 
            AND c.city = '&CITY' 
            --AND c.wcel_rnc_id = '&RNC_ID'
            AND c.wcel_wbts_id = '&BTS_ID'
Where
    servlev.PERIOD_START_TIME >= To_Date(&start_date, 'yyyy-mm-dd') And
    servlev.PERIOD_START_TIME < To_Date(&end_date, 'yyyy-mm-dd')
    --AND  c.wcel_rnc_id = '&RNC_ID'
    AND c.wcel_wbts_id = '&BTS_ID'
Group By
    servlev.PERIOD_START_TIME,
    c.city,
    c.wcel_rnc_id,
    c.wcel_wbts_id,
    c.wbts_name,
    c.ci,
    c.lcrid
    
order BY
    c.wcel_wbts_id,
    servlev.PERIOD_START_TIME