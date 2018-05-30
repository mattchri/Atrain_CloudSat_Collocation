;+
;NAME:
;
;   Build Collocation Variables from CloudSat
;
;PURPOSE:
;
;   This procedure is used to assimilate selected variables from CloudSat to be used to create an 
;   hdf file with the same format as others like it.
;
;
;OUTPUT:  g_str,g_val,height,v_str,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12
;g_str(7) = global attribute names of elements to be included in hdf file
;g_val(7) = strings obtained from CloudSat hdf file
;height   = height index for granule 
;v_str    = v data names
;v0,v1,...ect = v-data
;
;
;SUB PROGRAMS
;
;a)  hdf_attr_data.pro
;b)  hdf_sd_data.pro
;c)  hdf_vd_data.pro
;d)  hdf_vd_lone_data.pro
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO BUILD_COLLOCATION_VARS,fsat

g_str = ['HDFEOSVersion','granule_number','ID_SITE','ID_CENTER',$
'ID_CENTER_URL','start_time','end_time']
v_str = ['Profile_time','UTC_start','TAI_start','Latitude','Longitude',$
'Range_to_intercept','DEM_elevation','Vertical_binsize','Pitch_offset',$
'Roll_offset','Data_quality','Data_status','Data_targetID']

g_val = strarr(7)

;Global Data
hdf_attr_data,fsat,'HDFEOSVersion',g0
hdf_attr_data,fsat,'granule_number',g1
hdf_attr_data,fsat,'ID_SITE',g2
hdf_attr_data,fsat,'ID_CENTER',g3
hdf_attr_data,fsat,'ID_CENTER_URL',g4
hdf_attr_data,fsat,'start_time',g5
hdf_attr_data,fsat,'end_time',g6

g_val(0) = g0
g_val(1) = g1
g_val(2) = g2
g_val(3) = g3
g_val(4) = g4
g_val(5) = g5
g_val(6) = g6

;Scientific Data
hdf_sd_data,fsat,'Height',height

;V Data
hdf_vd_data,fsat,'Profile_time',v0
hdf_vd_data,fsat,'UTC_start',v1
hdf_vd_data,fsat,'TAI_start',v2
hdf_vd_data,fsat,'Latitude',v3
hdf_vd_data,fsat,'Longitude',v4
hdf_vd_data,fsat,'Range_to_intercept',v5
hdf_vd_data,fsat,'DEM_elevation',v6
hdf_vd_data,fsat,'Vertical_binsize',v7
hdf_vd_data,fsat,'Pitch_offset',v8
hdf_vd_data,fsat,'Roll_offset',v9
hdf_vd_data,fsat,'Data_quality',v10
hdf_vd_data,fsat,'Data_status',v11
hdf_vd_data,fsat,'Data_targetID',v12

save,filename='cvars.sav',g_str,g_val,height,v_str,v0,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12

return
end
