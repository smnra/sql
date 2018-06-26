-------------------------------------
--此版本修正 netmodel 列为空的问题:
--c_lte_custom 表的 netmodel 字段的来源为 表 c_lte_lncel 的 lncel_earfcn_dl 字段 
--在基站版本升级到 17A后, 表 c_lte_lncel 的 lncel_earfcn_dl 字段已经无效了  
--更改到 c_lte_lncel_fdd 表的 lncel_fdd_earfcn_dl 字段
--更令人费解的是 c_lte_lncel_fdd 表的 obj_gid 竟然不是 lncel网元 的ID ,而是 lncel的子网元 LNCEL_FDD-0 这个网元的 ID
--所以只能用c_lte_lncel_fdd 和 ctp_common_objects 表 关联出 LNCEL_FDD-0 网元的父网元的ID: co_parent_gid
--然后再用 co_parent_gid 关联到 lncel 级的网元 ID,坎坷!!!
-------------------------------------
Truncate TABLE C_LTE_Custom;
COMMIT;
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
        WHEN fl17a.lncel_fdd_earfcn_dl IS NOT NULL THEN 'FDD'          
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
    c_lte_lncel lncel, 
    ctp_common_objects ctp,  
    (select ctp.co_gid,fdd_0.lncel_fdd_earfcn_dl from (select obj_gid,conf_id,LNCEL_FDD_EARFCN_DL,ctp.co_parent_gid from C_LTE_LNCEL_FDD lncel_fdd inner join ctp_common_objects ctp on ctp.co_gid = lncel_fdd.obj_gid where  lncel_fdd.conf_id =1)  fdd_0 left join ctp_common_objects ctp on fdd_0.co_parent_gid = ctp.co_gid) fl17a
WHERE 
    lncel.conf_id = 1 AND LNCEL.obj_gid = ctp.co_gid and fl17a.co_gid(+) = ctp.co_gid
ORDER BY 
    lncel.lncel_enb_id,
    lncel.lncel_lcr_id;
COMMIT;