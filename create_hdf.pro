;+
;NAME:
;
;   Create Collocated HDF file
;
;PURPOSE:
;
;   This procedure is used to create the Collocated HDF file
;
;DESCRIPTION:
;
;    Restores several save files to assimilate the data into 1 HDF File
;
;OUTPUT:  /raid3/chrismat/hdf_files
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO CREATE_HDF,filename

restore,'ccc.sav'
restore,'alayhdf.sav'
restore,'clayhdf.sav'
restore,'cvars.sav'

cs_file_info,ffsat,p1
cal_file_info,fcal_alay(0),p2
cal_file_info,fcal_alay(1),p3
cal_file_info,fcal_alay(2),p4

;Build HDF file for collocated Calipso data
filename = p1+'_CS_2B-GEOPROF-AEROSOL_GRANULE_'+strmid(ffsat,strpos(ffsat,'.hdf')-7,11)
print,filename

res1=size(index_5km)

file_id = hdf_open(filename,/CREATE)
fileID = HDF_SD_START(filename, /RDWR)

     ;Global Attributes
     for i=0,6 do HDF_SD_ATTRSET, fileID,g_str(i),g_val(i)
     HDF_SD_ATTRSET, fileID, 'Cloudsat_File',p1
     HDF_SD_ATTRSET, fileID, 'First_Calipso_File',p2
     HDF_SD_ATTRSET, fileID, 'Second_Calipso_File',p3
     HDF_SD_ATTRSET, fileID, 'Third_Calipso_File',p4
     HDF_SD_ATTRSET, fileID, 'DATE', systime(0)
     HDF_SD_ATTRSET, fileID, 'NAME','Matthew Christensen'
     HDF_SD_ATTRSET, fileID, 'EMAIL ADDRESS','chrismat@atmos.colostate.edu'

     ;Scientific Data Set
     htID = hdf_sd_create( fileID,'Height',[125,res1(1)], /INT)
     hdf_sd_adddata,htID,height
     hdf_sd_endaccess, htID

     dnID = hdf_sd_create( fileID,'Day_Night_Flag', [1,res1(1)], /BYTE)
       newdn = intarr(1,res1(1))
       newdn(0,*) = DN_flag
     hdf_sd_adddata,dnID,newdn
     hdf_sd_endaccess, dnID

     coID = hdf_sd_create( fileID,'L1_Collocated_Index_concat', [1L,res1(1)], /LONG)
      new_arr = lonarr(1,res1(1))
      new_arr(0,*) = index_l1
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'L1_Collocated_Index_inFile', [1L,res1(1)], /LONG)
      new_arr = lonarr(1,res1(1))
      new_arr(0,*) = f_index_l1
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'L1_Distance', [1,res1(1)], /FLOAT)
      new_arr = fltarr(1,res1(1))
      new_arr(0,*) = dist_l1
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'L1_Elements', [1L,3], /LONG)
      new_arr = lonarr(1,3)
      new_arr(0,*) = num_l1
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'5km_Collocated_Index_concat', [1L,res1(1)], /LONG)
      new_arr = lonarr(1,res1(1))
      new_arr(0,*) = index_5km
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'5km_Collocated_Index_inFile', [1L,res1(1)], /LONG)
      new_arr = lonarr(1,res1(1))
      new_arr(0,*) = f_index_5km
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'5km_Distance', [1,res1(1)], /FLOAT)
      new_arr = fltarr(1,res1(1))
      new_arr(0,*) = dist_5km
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'5km_Elements', [1L,3], /LONG)
      new_arr = lonarr(1,3)
      new_arr(0,*) = num_5km
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     coID = hdf_sd_create( fileID,'File_Number', [1,res1(1)], /INT)
      new_arr = intarr(1,res1(1))
      new_arr(0,*) = filen
     hdf_sd_adddata,coID,new_arr
     hdf_sd_endaccess, coID

     nmID = hdf_sd_create( fileID,'A_Number_Layers_Found',[1,res1(1)], /BYTE)
       new_anum = intarr(1,res1(1))
       new_anum(0,*) = alay_num
     hdf_sd_adddata,nmID,new_anum
     hdf_sd_endaccess, nmID

     bsID = hdf_sd_create( fileID,'A_Layer_Base',[8,res1(1)], /FLOAT)
     hdf_sd_adddata,bsID,alay_bot
     hdf_sd_endaccess, bsID

     tpID = hdf_sd_create( fileID,'A_Layer_Top',[8,res1(1)], /FLOAT)
     hdf_sd_adddata,tpID,alay_top
     hdf_sd_endaccess, tpID

     opID = hdf_sd_create( fileID,'A_Layer_Opacity_Flag',[8,res1(1)], /BYTE)
     hdf_sd_adddata,opID,alay_opacity_flag
     hdf_sd_endaccess, opID

     lfID = hdf_sd_create( fileID,'A_Layer_Feature_Mask',[8,res1(1)], /UINT)
     hdf_sd_adddata,lfID,alay_FCF
     hdf_sd_endaccess, lfID

     taID = hdf_sd_create( fileID,'A_Layer_Optical_Depth_532',[8,res1(1)], /FLOAT)
     hdf_sd_adddata,taID,alay_tau_532
     hdf_sd_endaccess, taID

     tbID = hdf_sd_create( fileID,'A_Layer_Optical_Depth_1064',[8,res1(1)], /FLOAT)
     hdf_sd_adddata,tbID,alay_tau_1064
     hdf_sd_endaccess, tbID

     nmID = hdf_sd_create( fileID,'C_Number_Layers_Found',[1,res1(1)], /BYTE)
       new_cnum = intarr(1,res1(1))
       new_cnum(0,*) = clay_num     
     hdf_sd_adddata,nmID,new_cnum
     hdf_sd_endaccess, nmID

     bsID = hdf_sd_create( fileID,'C_Layer_Base',[10,res1(1)], /FLOAT)
     hdf_sd_adddata,bsID,clay_bot
     hdf_sd_endaccess, bsID

     tpID = hdf_sd_create( fileID,'C_Layer_Top',[10,res1(1)], /FLOAT)
     hdf_sd_adddata,tpID,clay_top
     hdf_sd_endaccess, tpID

     opID = hdf_sd_create( fileID,'C_Layer_Opacity_Flag',[10,res1(1)], /BYTE)
     hdf_sd_adddata,opID,clay_opacity_flag
     hdf_sd_endaccess, opID

     lfID = hdf_sd_create( fileID,'C_Layer_Feature_Mask',[10,res1(1)], /UINT)
     hdf_sd_adddata,lfID,clay_FCF
     hdf_sd_endaccess, lfID

     taID = hdf_sd_create( fileID,'C_Layer_Optical_Depth_532',[10,res1(1)], /FLOAT)
     hdf_sd_adddata,taID,clay_tau_532
     hdf_sd_endaccess, taID

     ;V Data Set
     ;fieldname = 'Missings'
     ;vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     ;HDF_VD_SETINFO, vID, NAME=fieldname
     ;HDF_VD_FDefine, vID, fieldname
     ;HDF_VD_WRITE, vID,fieldname,missing
     ;HDF_VD_DETACH,vID

     fieldname = v_str(0)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v0
     HDF_VD_DETACH,vID

     fieldname = v_str(1)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v1
     HDF_VD_DETACH,vID

     fieldname = v_str(2)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v2
     HDF_VD_DETACH,vID

     fieldname = v_str(3)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v3
     HDF_VD_DETACH,vID

     fieldname = v_str(4)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v4
     HDF_VD_DETACH,vID

     fieldname = v_str(5)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v5
     HDF_VD_DETACH,vID

     fieldname = v_str(6)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v6
     HDF_VD_DETACH,vID

     fieldname = v_str(7)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v7
     HDF_VD_DETACH,vID

     fieldname = v_str(8)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v8
     HDF_VD_DETACH,vID

     fieldname = v_str(9)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v9
     HDF_VD_DETACH,vID

     fieldname = v_str(10)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v10
     HDF_VD_DETACH,vID

     fieldname = v_str(11)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v11
     HDF_VD_DETACH,vID

     fieldname = v_str(12)
     vID = HDF_VD_ATTACH( file_id, -1, /WRITE)
     HDF_VD_SETINFO, vID, NAME=fieldname
     HDF_VD_FDefine, vID, fieldname
     HDF_VD_WRITE, vID,fieldname,v12
     HDF_VD_DETACH,vID

HDF_SD_END, fileID
hdf_close,file_id

return
end
