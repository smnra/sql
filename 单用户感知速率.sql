 select    
    
    c.city,
    c.lnbtsid,
    c.lncel_lcr_id,
    lcellt.PERIOD_START_TIME,
    round(sum(lcellt.�տ�ҵ���ֽ���)/1024/1024,4) as �տ�ҵ���ֽ���_MB,
    round(sum(lcellt.�տ�����ҵ���ֽ���)/1024/1024,4)  as �տ�����ҵ���ֽ���_MB,
    round(sum(lcellt.�տ�����ҵ���ֽ���)/1024/1024,4)  as �տ�����ҵ���ֽ���_MB,
    round(decode(sum(lcellt.CUCL_46b_y),0,0,sum(CUCL_46b_x)/sum(CUCL_46b_y)/1000),4) as ���û�����_M


from
(
SELECT
        lcellt.lncel_id,
        to_char(lcellt.PERIOD_START_TIME,'yyyy-mm-dd') as PERIOD_START_TIME,
        SUM(lcellt.PDCP_SDU_VOL_UL + lcellt.PDCP_SDU_VOL_DL) AS �տ�ҵ���ֽ���,
        SUM(lcellt.PDCP_SDU_VOL_UL )  AS �տ�����ҵ���ֽ���,
        SUM(lcellt.PDCP_SDU_VOL_DL )  AS �տ�����ҵ���ֽ���,
        sum(IP_TPUT_VOL_DL_QCI_1+IP_TPUT_VOL_DL_QCI_2+ IP_TPUT_VOL_DL_QCI_3+
              IP_TPUT_VOL_DL_QCI_4+IP_TPUT_VOL_DL_QCI_5 +
              IP_TPUT_VOL_DL_QCI_6+IP_TPUT_VOL_DL_QCI_7+ IP_TPUT_VOL_DL_QCI_8+
              IP_TPUT_VOL_DL_QCI_9) as CUCL_46b_x
        ,sum(IP_TPUT_NET_TIME_DL_QCI1+IP_TPUT_NET_TIME_DL_QCI2+IP_TPUT_NET_TIME_DL_QCI3+
                      IP_TPUT_NET_TIME_DL_QCI4+IP_TPUT_NET_TIME_DL_QCI5+
                      IP_TPUT_NET_TIME_DL_QCI6+IP_TPUT_NET_TIME_DL_QCI7+IP_TPUT_NET_TIME_DL_QCI8+
                      IP_TPUT_NET_TIME_DL_QCI9)  as CUCL_46b_y
    FROM
            NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt
    
    WHERE
            lcellt.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
        AND lcellt.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')

    GROUP BY
        lcellt.lncel_id,
        to_char(lcellt.PERIOD_START_TIME,'yyyy-mm-dd')
        
)   lcellt
        
        
left join  c_lte_custom c on c.lncel_objid = lcellt.lncel_id
        

group by 
        
    c.city,
    c.lnbtsid,
    c.lncel_lcr_id,
    lcellt.PERIOD_START_TIME      
        
        
        
        
        
        