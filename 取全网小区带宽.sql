                    select
                        lncel.obj_gid,
                        --lncel.lncel_enb_id,
                        --lncel.lncel_lcr_id,
                        decode(lncel.lncel_dl_ch_bw, null, lncel_fdd.LNCEL_FDD_DL_CH_BW, lncel.lncel_dl_ch_bw) as lncel_dl_ch_bw,
                        decode(lncel.lncel_ul_ch_bw, null, lncel_fdd.LNCEL_FDD_UL_CH_BW, lncel.lncel_ul_ch_bw) as lncel_ul_ch_bw
     
                        
                    from
                        c_lte_lncel lncel
                    left join    
                        (select 
                            ctp.co_gid AS obj_gid,
                            --ctp.co_dn,
                            fdd_0.LNCEL_FDD_UL_CH_BW,
                            fdd_0.LNCEL_FDD_DL_CH_BW
                             
                        from 
                            (select 
                                lncel_fdd.obj_gid,
                                lncel_fdd.LNCEL_FDD_UL_CH_BW,
                                lncel_fdd.LNCEL_FDD_DL_CH_BW,
                                ctp.co_parent_gid 
                             from 
                                C_LTE_LNCEL_FDD lncel_fdd 
                                inner join ctp_common_objects ctp on ctp.co_gid = lncel_fdd.obj_gid 
                             where  
                                lncel_fdd.conf_id =1
                            ) fdd_0 
                            
                        left join ctp_common_objects ctp on fdd_0.co_parent_gid = ctp.co_gid
                        
                        ) lncel_fdd on  lncel_fdd.obj_gid = lncel.obj_gid and lncel.conf_id = 1
                        
                        where
                            lncel.conf_id = 1