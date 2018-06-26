/*--#####################################################################
--
--�˽ű� ��ȡÿ��ÿС�� ������������һ��Сʱ�� wcel_id �� period_start_time
--һ��С�� ÿ��������������һ��Сʱ
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
                �������ҵ����,
                rank() over( Partition by wcel_id,DAY Order by �������ҵ���� DESC) AS RANKS
                
        FROM
                 (SELECT 
                    celltp.wcel_id AS wcel_id,
                    to_char(celltp.period_start_time, 'yyyymmdd')  AS DAY,
                    celltp.period_start_time AS  period_start_time,
                    SUM(celltp.HS_DSCH_DATA_VOL + celltp.NRT_DCH_DL_DATA_VOL)  AS �������ҵ����
                    
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
