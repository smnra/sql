,round(100*avg(lcellr.PRB_USED_PUSCH)*0.8/(24*60*60*1000*100/5),2)  上行PRB平均利用率D 
,round(100*avg(lcellr.PRB_USED_PUSCH)*0.8/(60*60*1000*100/5),2)  上行PRB平均利用率H 

,round(100*avg(lcellr.PRB_USED_PDSCH)/(24*60*60*1000*100*4/5),2) 下行PRB平均利用率D
,round(100*avg(lcellr.PRB_USED_PDSCH)/(60*60*1000*100*4/5),2) 下行PRB平均利用率H




        decode((CASE WHEN c.version='FL16' THEN 'FL16' WHEN c.version='FLF16' THEN 'FL16' WHEN c.version='FL16A' THEN 'FL16' ELSE c.version END), 'TL16',   round(100*avg(lcellr.PRB_USED_PUSCH)*0.8/(24*60*60*1000*100/5),2),     'FL16', decode((decode(sum(lncel.LNCEL_UL_CH_BW),'',0,sum(lncel.LNCEL_UL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60)),0,0, SUM(lcellr.PRB_USED_UL_TOTAL)/ sum(lcellr.PERIOD_DURATION*60*1000)/(decode(sum(lncel.LNCEL_UL_CH_BW),'',0,sum(lncel.LNCEL_UL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60))),decode((sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)+decode(lncel.LNCEL_UL_CH_BW,'',0,lncel.LNCEL_UL_CH_BW))/2),0,0, decode(sum(lcellr.PERIOD_DURATION*60*1000),0,0,sum(lcellr.PRB_USED_PUSCH)/sum(lcellr.PERIOD_DURATION*60*1000))/ (sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)*decode(lncel.LNCEL_TDD_FRAME_CONF,1,0.4,0.2)+ decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)/35+decode(lncel.LNCEL_UL_CH_BW,'',0, lncel.LNCEL_UL_CH_BW))/2))) AS 上行PRB平均利用率D,



        decode((CASE WHEN c.version='FL16' THEN 'FL16' WHEN c.version='FLF16' THEN 'FL16' WHEN c.version='FL16A' THEN 'FL16' ELSE c.version END),'TL16',   round(100*avg(lcellr.PRB_USED_PDSCH)/(24*60*60*1000*100*4/5),2),    'FL16', decode((decode(sum(lncel.LNCEL_DL_CH_BW),'',0,sum(lncel.LNCEL_DL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60)),0,0, SUM(lcellr.PRB_USED_DL_TOTAL)/ sum(lcellr.PERIOD_DURATION*60*1000)/(decode(sum(lncel.LNCEL_DL_CH_BW),'',0,sum(lncel.LNCEL_DL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60))), decode((sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)+decode(lncel.LNCEL_DL_CH_BW,'',0,lncel.LNCEL_DL_CH_BW))/2),0,0,decode(sum(lcellr.PERIOD_DURATION*60*1000), 0,0, sum(lcellr.PRB_USED_PDSCH) /sum(lcellr.PERIOD_DURATION*60*1000))/(sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)* decode(lncel.LNCEL_TDD_FRAME_CONF,1,0.4,0.6)+decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)*decode(lncel.LNCEL_TSSC_296,5,0.0428,0.1428)+ decode(lncel.LNCEL_DL_CH_BW,'',0,lncel.LNCEL_DL_CH_BW))/2))) AS 下行PRB平均利用率D,













            decode((CASE WHEN c.version='FL16' THEN 'FL16' WHEN c.version='FLF16' THEN 'FL16' WHEN c.version='FL16A' THEN 'FL16' ELSE c.version END), 'TL16',   round(100*avg(lcellr.PRB_USED_PUSCH)*0.8/(60*60*1000*100/5),2),     'FL16', decode((decode(sum(lncel.LNCEL_UL_CH_BW),'',0,sum(lncel.LNCEL_UL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60)),0,0, SUM(lcellr.PRB_USED_UL_TOTAL)/ sum(lcellr.PERIOD_DURATION*60*1000)/(decode(sum(lncel.LNCEL_UL_CH_BW),'',0,sum(lncel.LNCEL_UL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60))),decode((sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)+decode(lncel.LNCEL_UL_CH_BW,'',0,lncel.LNCEL_UL_CH_BW))/2),0,0, decode(sum(lcellr.PERIOD_DURATION*60*1000),0,0,sum(lcellr.PRB_USED_PUSCH)/sum(lcellr.PERIOD_DURATION*60*1000))/ (sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)*decode(lncel.LNCEL_TDD_FRAME_CONF,1,0.4,0.2)+ decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)/35+decode(lncel.LNCEL_UL_CH_BW,'',0, lncel.LNCEL_UL_CH_BW))/2))) AS 上行PRB平均利用率H,
  
  
  
  
            decode((CASE WHEN c.version='FL16' THEN 'FL16' WHEN c.version='FLF16' THEN 'FL16' WHEN c.version='FL16A' THEN 'FL16' ELSE c.version END), 'TL16',   round(100*avg(lcellr.PRB_USED_PDSCH)/(60*60*1000*100*4/5),2),     'FL16', decode((decode(sum(lncel.LNCEL_DL_CH_BW),'',0,sum(lncel.LNCEL_DL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60)),0,0, SUM(lcellr.PRB_USED_DL_TOTAL)/ sum(lcellr.PERIOD_DURATION*60*1000)/(decode(sum(lncel.LNCEL_DL_CH_BW),'',0,sum(lncel.LNCEL_DL_CH_BW)/2) * 10* sum(lcelav.SAMPLES_CELL_AVAIL)/sum(lcellr.PERIOD_DURATION*60))), decode((sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)+decode(lncel.LNCEL_DL_CH_BW,'',0,lncel.LNCEL_DL_CH_BW))/2),0,0,decode(sum(lcellr.PERIOD_DURATION*60*1000), 0,0, sum(lcellr.PRB_USED_PDSCH) /sum(lcellr.PERIOD_DURATION*60*1000))/(sum(decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)* decode(lncel.LNCEL_TDD_FRAME_CONF,1,0.4,0.6)+decode(lncel.LNCEL_CH_BW,'',0,lncel.LNCEL_CH_BW)*decode(lncel.LNCEL_TSSC_296,5,0.0428,0.1428)+ decode(lncel.LNCEL_DL_CH_BW,'',0,lncel.LNCEL_DL_CH_BW))/2))) AS 下行PRB平均利用率H,