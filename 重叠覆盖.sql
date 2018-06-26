select
    ratio.sc_eci as sc_eciAll,
    ratio.totalNumber as totalNumberAll,
    ratio.overlapNumber as overlapNumberAll,
    ratio.ratio as ratioAll,
    mro.sc_eci as sc_eciNC,
    mro.nc_eci as nc_eciNC,
    mro.overlapNumber as overlapNumberNC
from    
    (select
        mro.sc_eci,
        mro.nc_eci,
        count(*) as overlapNumber
    from
        tdlte_mro_huawei mro
    where
        mro.ltescrsrp - mro.ltencrsrp <6 
        and mro.ltescrsrp-140 <-110
        and mro.sdate = to_date(&date,'yyyymmdd')
        
        and mro.sc_enbid >= '780173'
        and mro.sc_enbid <  '780349'
    group by 
        mro.sc_eci,
        mro.nc_eci
    )  mro    
        
left join
    (select 
        total.sc_eci,
        total.totalNumber,
        overlap.overlapNumber,
        round(overlap.overlapNumber/total.totalNumber*100,4) as ratio
    from
        (select 
            mro.sc_eci,
            count(1) as totalNumber

        from 
            tdlte_mro_huawei mro
        where 
            --mro.ltescrsrp - mro.ltencrsrp <6 
            --and mro.ltescrsrp-140 <-110
            mro.sdate = to_date(&date,'yyyymmdd')
            
            and mro.sc_enbid >= '780173'
            and mro.sc_enbid <  '780349'
            
        group by
            mro.sc_eci
            
        ) total 
        
    inner join 
        (select 
            mro.sc_eci,
            count(1) as overlapNumber

        from 
            tdlte_mro_huawei mro
        where 
            mro.ltescrsrp - mro.ltencrsrp <6 
            and mro.ltescrsrp-140 <-110
            and mro.sdate = to_date(&date,'yyyymmdd')
            
            and mro.sc_enbid >= '780173'
            and mro.sc_enbid <  '780349'
            
        group by
            mro.sc_eci
        ) overlap on total.sc_eci = overlap.sc_eci
        
    ) ratio on mro.sc_eci = ratio.sc_eci  

order by
    mro.sc_eci,
    mro.nc_eci
    