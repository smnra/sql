select 
        ctp.co_object_instance,
        ctp.co_name,
        ctp.co_sys_version,
        ctp.co_oc_id,
        ctp.co_dn

from
        ctp_common_objects ctp
        
where
 ctp.co_oc_id  in ('1547', '2429')
