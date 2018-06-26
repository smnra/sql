SELECT 
    GE_80.s_cell_id,
    GE_80.GE_80,
    H_80_85.H_80_85,
    H_85_90.H_85_90,
    H_90_95.H_90_95,
    H_95_100.H_95_100,
    H_100_105.H_100_105,
    LE_105.LE_105,
    (GE_80.GE_80 + H_80_85.H_80_85 + H_85_90.H_85_90 +  
     H_90_95.H_90_95 +H_95_100.H_95_100 +  H_100_105.H_100_105 
     + LE_105.LE_105) AS  totalPoint
     
    
    
FROM
(SELECT 
    mro.s_cell_id,
    count(mro.s_rsrp) AS GE_80
FROM  TDLTE_MRO_LOCATE_HOUR mro
WHERE
    mro.s_rsrp>=-80
GROUP BY 
    mro.s_cell_id
) GE_80,

(SELECT 
    mro.s_cell_id,
    count(mro.s_rsrp) AS H_80_85
FROM  TDLTE_MRO_LOCATE_HOUR mro
WHERE
    mro.s_rsrp<-80 AND mro.s_rsrp>=-85
GROUP BY 
    mro.s_cell_id
) H_80_85,

(SELECT 
    mro.s_cell_id,
    count(mro.s_rsrp) AS H_85_90
FROM  TDLTE_MRO_LOCATE_HOUR mro
WHERE
    mro.s_rsrp<-85 AND mro.s_rsrp>=-90
GROUP BY 
    mro.s_cell_id
) H_85_90,


(SELECT 
    mro.s_cell_id,
    count(mro.s_rsrp) AS H_90_95
FROM  TDLTE_MRO_LOCATE_HOUR mro
WHERE
    mro.s_rsrp<-90 AND mro.s_rsrp>=-95
GROUP BY 
    mro.s_cell_id
) H_90_95,


(SELECT 
    mro.s_cell_id,
    count(mro.s_rsrp) AS H_95_100
FROM  TDLTE_MRO_LOCATE_HOUR mro
WHERE
    mro.s_rsrp<-95 AND mro.s_rsrp>=-100
GROUP BY 
    mro.s_cell_id
) H_95_100,

(SELECT 
    mro.s_cell_id,
    count(mro.s_rsrp) AS H_100_105
FROM  TDLTE_MRO_LOCATE_HOUR mro
WHERE
    mro.s_rsrp<-100 AND mro.s_rsrp>=-105
GROUP BY 
    mro.s_cell_id
) H_100_105,

(SELECT 
    mro.s_cell_id,
    count(mro.s_rsrp) AS LE_105
FROM  TDLTE_MRO_LOCATE_HOUR mro
WHERE
    mro.s_rsrp<-105
GROUP BY 
    mro.s_cell_id
)  LE_105

WHERE
              GE_80.s_cell_id =  H_80_85.s_cell_id
        AND GE_80.s_cell_id =  H_85_90.s_cell_id
        AND GE_80.s_cell_id =  H_90_95.s_cell_id        
        AND GE_80.s_cell_id =  H_95_100.s_cell_id
        AND GE_80.s_cell_id =  H_100_105.s_cell_id             
        AND GE_80.s_cell_id =  LE_105.s_cell_id