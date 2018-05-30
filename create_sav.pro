;+
;NAME:
;
;   Create Collocated SAV file
;
;PURPOSE:
;
;   This procedure is used to create the Collocated SAV file
;
;DESCRIPTION:
;
;    Restores several save files to assimilate the data into 1 SAV File
;
;OUTPUT:  SAV filename and save filename
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO CREATE_SAV,sav_f

restore,'ccc.sav'
restore,'alay.sav'
restore,'clay5km.sav'
restore,'cvars.sav'

cs_file_info,ffsat,p1
cal_file_info,fcal_alay(0),p2
cal_file_info,fcal_alay(1),p3
cal_file_info,fcal_alay(2),p4

;Build HDF file for collocated Calipso data
sav_f = p1+'_CS_2B-GEOPROF-AEROSOL_GRANULE_'+strmid(ffsat,strpos(ffsat,'.hdf')-7,7)+'.sav'
print,sav_f

fname = strarr(4)
fname(0) = p1
fname(1) = p2
fname(2) = p3
fname(3) = p4

save,filename=sav_f,fname,index_5km,f_index_5km,dist_5km,num_5km,filen,$
                          alay_num,alay_top,alay_base,alay_flag_byte,alay_horz,alay_opacity_flag,alay_tau_532,alay_tau_1064,$
                          clay_num_5km,clay_top_5km,clay_base_5km,clay_flag_byte_5km,clay_horz,clay_opacity_flag,clay_tau_532,dn_flag                    
return
end