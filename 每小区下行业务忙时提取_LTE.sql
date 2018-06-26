/*--#####################################################################
--
--此脚本 提取每天每小区 下行流量最大的一个小时的 lncel_id 和 period_start_time
--一个小区 每天下行流量最大的一个小时
--
*/--#####################################################################



WITH busyhour_dl as
(SELECT 
       lncel_id,
       period_start_time  AS period_start_time
       
FROM 
        (SELECT
                lncel_id,
                period_start_time,
                DAY,
                下行最大业务量,
                rank() over( Partition by lncel_id,DAY Order by 下行最大业务量 DESC) AS RANKS
                
        FROM
                 (SELECT 
                    lcellt.lncel_id AS lncel_id,
                    to_char(lcellt.period_start_time, 'yyyymmdd')  AS DAY,
                    lcellt.period_start_time AS  period_start_time,
                    SUM(PDCP_SDU_VOL_DL)  AS 下行最大业务量
                    
                FROM 
                    NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt
                WHERE 
                        lcellt.period_start_time >= to_date(&start_date, 'yyyy-mm-dd')
                    AND lcellt.period_start_time < to_date(&end_date, 'yyyy-mm-dd')
                    AND PDCP_SDU_VOL_DL >0

                GROUP BY 
                    lcellt.lncel_id,
                    to_char(lcellt.period_start_time, 'yyyymmdd'),
                    lcellt.period_start_time
                    
                )
                
        )
        
WHERE
    RANKS =1
       
)


SELECT *  FROM busyhour_dl