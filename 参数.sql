                    select
                        lncel.obj_gid,
                        lncel.lncel_enb_id,
                        lncel.lncel_lcr_id,
                        ctp.co_sys_version,
                        decode(lncel.LNCEL_MAX_NUM_ACT_DRB, null, lncel_fdd.LNCEL_FDD_MAX_NUM_ACT_DRB, lncel.LNCEL_MAX_NUM_ACT_DRB) as maxNumActDrb,
                        
                        decode(lncel.LNCEL_MAX_NUM_ACT_UE, null, lncel_fdd.LNCEL_FDD_MAX_NUM_ACT_UE, lncel.LNCEL_MAX_NUM_ACT_UE) as maxNumActUE,

                        decode((CASE
                                WHEN ctp.co_sys_version='LN7.0' THEN 'FL16' 
                                WHEN ctp.co_sys_version='LNT5.0' THEN 'FL16' 
                                WHEN ctp.co_sys_version='FL16' THEN 'FL16' 
                                WHEN ctp.co_sys_version='TL16' THEN 'FL16' 
                                WHEN ctp.co_sys_version='FLF16' THEN 'FL16' 
                                WHEN ctp.co_sys_version='FL16A' THEN 'FL16A' 
                                WHEN ctp.co_sys_version='FLF16A' THEN 'FL16A' 
                                WHEN ctp.co_sys_version='TLF16A' THEN 'FL16A' 
                                WHEN ctp.co_sys_version='FL17A_1701_07_1701_06' THEN 'FL17A' 
                                WHEN ctp.co_sys_version='xL18_1708_007' THEN 'FL17A' 
                                WHEN ctp.co_sys_version='xL18_1708_008' THEN 'FL17A' 
                                ELSE 'FL16A' 
                            END),
                            'FL16',
                            lncel.LNCEL_MAX_NUM_RRC,
                            'FL16A',
                            cch.m_pu_cch_max_num_rrc,
                            'FL17A',
                            MPUCCH_FDD.M_PU_8350_MAX_NUM_RRC
                        ) AS maxNumRrc

                    from
                        c_lte_lncel lncel
                        left join ctp_common_objects ctp on ctp.co_gid = lncel.obj_gid
                    left join    
                        (select 
                            ctp.co_gid AS obj_gid,
                            ctp.co_sys_version as version,
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
                            --cch.co_sys_version as version,
                            --cch.co_dn,
                            cch.m_pu_cch_max_num_rrc
                             
                        from 
                            (select 
                                cch.obj_gid,
                                cch.m_pu_cch_max_num_rrc,
                                --ctp.co_sys_version,
                                --ctp.co_dn,
                                ctp.co_parent_gid 
                             from 
                                c_lte_m_pu_cch cch
                                inner join ctp_common_objects ctp on ctp.co_gid = cch.obj_gid 
                             where  
                                cch.conf_id =1
                            ) cch 
                            
                        left join ctp_common_objects ctp on cch.co_parent_gid = ctp.co_gid
                        ) cch on cch.obj_gid = lncel.obj_gid and lncel.conf_id = 1
                    
                    
                    
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
                            and mod(lncel.lncel_lcr_id,10) <> 9