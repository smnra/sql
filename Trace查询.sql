select
    c.id,
    c.trace_reference,
    c.trace_target,
    ne.name,
    ne.version,
    ne.fqdn,
    ne.cm_trace_fqdn,
    to_char(c.start_time,'YYYYMMDD HH24') AS start_time,
    to_char(c.stop_time,'YYYYMMDD HH24') AS stop_time,
    trace_header.server_ip_address,
    trace_header.server_port,
    c.state,
    ne.error_text,
    c.description,
    c.has_warning
    
    
    
from 
    trc.cor_trace_ne_status ne 
    left join trc.cor_lte_trace_header  trace_header  on trace_header.trace_header_id = ne.trace_header_id
    left join trc.cor_trace_header c on  ne.trace_header_id = c.id
    
where
    1= 1
    --AND c.trace_target = 779604

    --AND c.state = 'DELETED'
    
    
    
   