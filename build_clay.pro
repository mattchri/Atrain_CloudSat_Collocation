;+
;NAME:
;
;   Build Cloud Layer Data
;
;PURPOSE:
;
;   This procedure is used to assimilate the cloud layer properties from Calipso
;
;DESCRIPTION:
;
;  For a complete list of Bit Interpretations see the CALIPSO QAULITY STATEMENTS:
;  Lidar Level 2 Cloud and Aerosol Layer Information
;  VERSION RELEASES:  2.01 & 2.02
;  http://eosweb.larc.nasa.gov/PRODOCS/calipso/Quality_Summaries/CALIOP_L2LayerProducts_2.01.html
;
;OUTPUT:  matched to the CloudSat data foot print.
;clay_num(8,*) = number of aerosol layers
;clay_top(8,*) = top of aerosol layer
;clay_base(8,*) = bottom of aerosol layer
;clay_horz(8,*) = horizontal averaging to obtain layer statistics
;clay_tau_532(8,*) = layer optical depth at 532 nanometers
;clay_tau_1064(8,*) = ' ' at 1064 nm
;clay_flag_byte(8,*) = Feature Classification Flags
;clay_opacity_flag(8,*) = Opaque or non opaque clouds
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
PRO BUILD_CLAY,fcal1,fcal2,fcal3,index

;1st Calipso File
hdf_sd_data,fcal1,'Number_Layers_Found',num1
hdf_sd_data,fcal1,'Layer_Top_Altitude',top1
hdf_sd_data,fcal1,'Layer_Base_Altitude',bot1
hdf_sd_data,fcal1,'Opacity_Flag',o_flag1
hdf_sd_data,fcal1,'Horizontal_Averaging',horz1
hdf_sd_data,fcal1,'Feature_Classification_Flags',fcf1
hdf_sd_data,fcal1,'Feature_Optical_Depth_532',taua1
num1=reform(num1)

;2nd Calipso File
hdf_sd_data,fcal2,'Number_Layers_Found',num2
hdf_sd_data,fcal2,'Layer_Top_Altitude',top2
hdf_sd_data,fcal2,'Layer_Base_Altitude',bot2
hdf_sd_data,fcal2,'Opacity_Flag',o_flag2
hdf_sd_data,fcal2,'Horizontal_Averaging',horz2
hdf_sd_data,fcal2,'Feature_Classification_Flags',fcf2
hdf_sd_data,fcal2,'Feature_Optical_Depth_532',taua2
num2=reform(num2)

;3rd Calipso File
hdf_sd_data,fcal3,'Number_Layers_Found',num3
hdf_sd_data,fcal3,'Layer_Top_Altitude',top3
hdf_sd_data,fcal3,'Layer_Base_Altitude',bot3
hdf_sd_data,fcal3,'Opacity_Flag',o_flag3
hdf_sd_data,fcal3,'Horizontal_Averaging',horz3
hdf_sd_data,fcal3,'Feature_Classification_Flags',fcf3
hdf_sd_data,fcal3,'Feature_Optical_Depth_532',taua3
num3=reform(num3)

;Concatenate Arrays
num = [num1,num2,num3]
top = [ [top1],[top2],[top3] ]
bot = [ [bot1],[bot2],[bot3] ]
opacity = [ [o_flag1],[o_flag2],[o_flag3] ]
horz = [ [horz1],[horz2],[horz3] ]
fcf  = [ [fcf1],[fcf2],[fcf3] ]
tau532 = [ [taua1],[taua2],[taua3] ]

res=size(index)
clay_num = intarr(res(1))
clay_top  = fltarr(10,res(1))
clay_base = fltarr(10,res(1))
clay_opacity_flag = intarr(10,res(1))
clay_horz = intarr(10,res(1))
clay_fcf = make_array(10,res(1),/uint)
clay_tau_532 = fltarr(10,res(1))
for i=0l,res(1)-1 do begin
 if index(i) gt -9999.00 then begin
  clay_num(i)   = num(index(i))
  clay_top(*,i) = top(*,index(i))
  clay_base(*,i) = bot(*,index(i))
  clay_opacity_flag(*,i) = opacity(*,index(i))
  clay_horz(*,i) = horz(*,index(i))
  clay_fcf(*,i) = fcf(*,index(i))
  clay_tau_532(*,i) = tau532(*,index(i))
 endif
 if index(i) eq -9999.00 then begin
  clay_num(i) = -9999.00
  clay_top(*,i) = -9999.00
  clay_base(*,i) = -9999.00
  clay_opacity_flag(*,i) = -9999.00
  clay_horz(*,i) = -9999.00
  clay_fcf(*,i) = 0   ;sets a 0 for all bit interpretations
  clay_tau_532(*,i) = -9999.00
 endif
endfor

clay_flag_byte = clay_fcf

clay_num_5km = clay_num
clay_top_5km = clay_top
clay_base_5km = clay_base
clay_flag_byte_5km = clay_flag_byte

save,filename='clay5km.sav',clay_num_5km,clay_top_5km,clay_base_5km,clay_opacity_flag,clay_horz,clay_flag_byte_5km,clay_tau_532

return
end
