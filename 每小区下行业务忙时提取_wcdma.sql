/*--#####################################################################
--
--此脚本 提取每天每小区 下行流量最大的一个小时的 wcel_id 和 period_start_time
--一个小区 每天下行流量最大的一个小时
--
*/--#####################################################################


WITH busyhour as
(SELECT 
       wcel_id,
       period_start_time  AS period_start_time
       
FROM 
        (SELECT
                wcel_id,
                period_start_time,
                DAY,
                下行最大业务量,
                rank() over( Partition by wcel_id,DAY Order by 下行最大业务量 DESC) AS RANKS
                
        FROM
                 (SELECT 
                    celltp.wcel_id AS wcel_id,
                    to_char(celltp.period_start_time, 'yyyymmdd')  AS DAY,
                    celltp.period_start_time AS  period_start_time,
                    SUM(celltp.HS_DSCH_DATA_VOL + celltp.NRT_DCH_DL_DATA_VOL)  AS 下行最大业务量
                    
                FROM 
                    NOKRWW_PS_CELLTP_MNC1_RAW celltp
                WHERE 
                        celltp.period_start_time >= to_date(&start_date, 'yyyy-mm-dd')
                    AND celltp.period_start_time < to_date(&end_date, 'yyyy-mm-dd')
                    AND celltp.HS_DSCH_DATA_VOL + celltp.NRT_DCH_DL_DATA_VOL >0

                GROUP BY 
                    celltp.wcel_id,
                    to_char(celltp.period_start_time, 'yyyymmdd'),
                    celltp.period_start_time
                    
                )
                
        )
        
WHERE
    RANKS =1
       
)


select * from busyhour
