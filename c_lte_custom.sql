INSERT INTO 
    c_lte_custom 
SELECT DISTINCT 
    (lncel.obj_gid) AS lncel_objid,
    ctp.co_parent_gid AS lnbts_objid,
    lncel.lncel_enb_id AS LNBTSid,lncel.lncel_lcr_id,
    CONCAT(lncel.lncel_enb_id,lncel.lncel_lcr_id) AS CI,
    ctp.CO_OBJECT_INSTANCE AS LNCELID,
    lncel.lncel_enb_id * 256 + lncel.lncel_lcr_id as ECI,
    ctp.co_name AS bts_name,
    (CASE 
        WHEN LNCEL.lncel_earfcn IS NOT NULL THEN 'TDD' 
        WHEN LNCEL.lncel_earfcn_dl IS NOT NULL THEN 'FDD'
    END) AS NetModel,
    'Shaanxi' AS Province,
    
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
    lncel.lncel_tac as TAC,  
    (select sysdate from dual) as UpdateDate,
    ctp.co_sys_version as version

FROM 
    c_lte_lncel lncel, ctp_common_objects ctp  
WHERE 
    lncel.conf_id = 1 AND LNCEL.obj_gid = co_gid  
ORDER BY 
    lncel.lncel_enb_id,
    lncel.lncel_lcr_id;