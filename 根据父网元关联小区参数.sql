                    select
                        lncel.obj_gid,
                        lncel.lncel_enb_id,
                        lncel.lncel_lcr_id,
                        lncel_fdd.co_sys_version,
                        decode(lncel.LNCEL_MAX_NUM_ACT_DRB, null, lncel_fdd.LNCEL_FDD_MAX_NUM_ACT_DRB, lncel.LNCEL_MAX_NUM_ACT_DRB) as maxNumActDrb,
                        
                        decode(lncel.LNCEL_MAX_NUM_ACT_UE, null, lncel_fdd.LNCEL_FDD_MAX_NUM_ACT_UE, lncel.LNCEL_MAX_NUM_ACT_UE) as maxNumActUE,

                        decode(lncel.LNCEL_MAX_NUM_RRC, null, MPUCCH_FDD.M_PU_8350_MAX_NUM_RRC, lncel.LNCEL_MAX_NUM_RRC) as maxNumRrc

                    from
                        c_lte_lncel lncel
                    left join    
                        (select 
                            ctp.co_gid AS obj_gid,
                            ctp.co_sys_version,
                            fdd_0.LNCEL_FDD_MAX_NUM_ACT_DRB,
                            fdd_0.LNCEL_FDD_MAX_NUM_ACT_UE
                             
                        from 
                            (select 
                                lncel_fdd.obj_gid,
                                lncel_fdd.LNCEL_FDD_MAX_NUM_ACT_DRB,
                                lncel_fdd.LNCEL_FDD_MAX_NUM_ACT_UE,
                                ctp.co_parent_gid 
                             from 
                                C_LTE_LNCEL_FDD lncel_fdd 
                                inner join ctp_common_objects ctp on ctp.co_gid = lncel_fdd.obj_gid 
                             where  
                                lncel_fdd.conf_id =1
                            ) fdd_0 
                            
                        left join ctp_common_objects ctp on fdd_0.co_parent_gid = ctp.co_gid
                        
                        ) lncel_fdd on  lncel_fdd.obj_gid = lncel.obj_gid and lncel.conf_id = 1
                    
                    left join 
                        (select 
                            ctp.co_gid AS obj_gid,
                            --ctp.co_dn,
                            MPUCCH_FDD.M_PU_8350_MAX_NUM_RRC
                             
                        from 
                            (select 
                                MPUCCH_FDD.co_parent_gid AS obj_gid,
                                ctp.co_parent_gid ,
                                ctp.co_dn,
                                MPUCCH_FDD.M_PU_8350_MAX_NUM_RRC
                                 
                            from 
                                (select 
                                    MPUCCH_FDD.obj_gid,
                                    MPUCCH_FDD.M_PU_8350_MAX_NUM_RRC,
                                    ctp.co_dn,
                                    ctp.co_parent_gid 
                                 from 
                                    C_LTE_M_PU_8350 MPUCCH_FDD 
                                    inner join ctp_common_objects ctp on ctp.co_gid = MPUCCH_FDD.obj_gid 
                                 where  
                                    MPUCCH_FDD.conf_id =1
                                    
                                 )  MPUCCH_FDD 
                                
                            left join ctp_common_objects ctp on MPUCCH_FDD.co_parent_gid = ctp.co_gid
                            ) MPUCCH_FDD 
                            
                        left join ctp_common_objects ctp on MPUCCH_FDD.co_parent_gid = ctp.co_gid
                        
                        ) MPUCCH_FDD on  MPUCCH_FDD.obj_gid = lncel.obj_gid and lncel.conf_id = 1
                        
                        
                        where
                            lncel.conf_id = 1 
                            --and lncel.lncel_enb_id in (772525)