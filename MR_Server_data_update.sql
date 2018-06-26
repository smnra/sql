SELECT


    lncel.lncel_phy_cell_id,
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

    lncel.lncel_enb_id,
    lncel.lncel_eutra_cel_id,
    Decode(lncel.lncel_earfcn_dl,NULL,lncel.lncel_earfcn,lncel.lncel_earfcn_dl) AS lncel_earfcn,

    
    (CASE    WHEN  trace_header.server_ip_address = '10.100.162.112' THEN 'MR1'
                WHEN  trace_header.server_ip_address = '10.100.162.111' THEN 'MR2'
                WHEN  trace_header.server_ip_address = '10.100.162.110' THEN 'MR3'
                WHEN  trace_header.server_ip_address = '10.100.162.109' THEN 'MR4'
                WHEN  trace_header.server_ip_address = '10.100.162.108' THEN 'MR5'
                WHEN  trace_header.server_ip_address = '10.100.162.115' THEN 'MR6'
                WHEN  trace_header.server_ip_address = '10.100.162.117' THEN 'MR7'
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
    LEFT JOIN ctp_common_objects ctp ON ctp.co_dn = ne.fqdn
    LEFT JOIN c_lte_lncel lncel ON lncel.obj_gid = ctp.co_gid AND lncel.conf_id = 1

    
where
    ne.state = 'ACTIVE'

    --AND c.state = 'DELETED'
    
    
    
   