select     
    replace(S_OBJECT_ID,' ','') as S_OBJECT_ID,
    replace(N_OBJECT_ID,' ','') as N_OBJECT_ID,
    N_EARFCN

from    
    (select 
        substr(adjs.rnc_id,-3)||to_char(adjs.wcell_id,'00000')||'_'||adjs.adjs_psc as S_OBJECT_ID,
        substr(adjs.adjs_rnc_id,-3)||to_char(adjs.adjs_ci,'00000') as N_OBJECT_ID,
        c.uarfcn as N_EARFCN
    from
        (select 
            substr(ctp.co_dn,instr(ctp.co_dn,'/RNC-')+5,4) as rnc_id,
            substr(ctp.co_dn,instr(ctp.co_dn,'/WBTS-')+6,instr(ctp.co_dn,'/WCEL-') - instr(ctp.co_dn,'/WBTS-')-6) as wbts_id,
            substr(ctp.co_dn,instr(ctp.co_dn,'/WCEL-')+6,instr(ctp.co_dn,'/ADJS-') - instr(ctp.co_dn,'/WCEL-')-6) as wcell_id,
            adjs.adjs_adjs_scr_code as adjs_psc,
            adjs.adjs_adjs_rn_cid as adjs_rnc_id,
            adjs.adjs_adjs_ci as adjs_ci
            --,ctp.co_dn,

        from 
            c_rnc_adjs adjs
            left join ctp_common_objects ctp on  ctp.co_gid = adjs.obj_gid

        ) adjs 
        
        left join c_w_custom c on c.wcel_rnc_id = adjs.rnc_id
                              and c.wcel_wbts_id = adjs.wbts_id
                              and c.ci = adjs.wcell_id
       where  c.city = 'Baoji'   
                              
       )
       
where replace(N_OBJECT_ID,' ','') is not null