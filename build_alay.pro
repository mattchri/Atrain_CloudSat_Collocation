;+
;NAME:
;
;   Build Aerosol Layer Data
;
;PURPOSE:
;
;   This procedure is used to assimilate the aerosol layer properties from Calipso
;
;DESCRIPTION:
;
;  For a complete list of Bit Interpretations see the CALIPSO QAULITY STATEMENTS:
;  Lidar Level 2 Cloud and Aerosol Layer Information
;  VERSION RELEASES:  2.01 & 2.02
;  http://eosweb.larc.nasa.gov/PRODOCS/calipso/Quality_Summaries/CALIOP_L2LayerProducts_2.01.html
;
;OUTPUT:  matched to the CloudSat data foot print.
;alay_num(8,*) = number of aerosol layers
;alay_top(8,*) = top of aerosol layer
;alay_base(8,*) = bottom of aerosol layer
;alay_horz(8,*) = horizontal averaging to obtain layer statistics
;alay_tau_532(8,*) = layer optical depth at 532 nanometers
;alay_tau_1064(8,*) = ' ' at 1064 nm
;alay_flag_byte(8,*) = Feature Classification Flags
;alay_opacity_flag(8,*) = Opaque or non opaque clouds
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
PRO BUILD_ALAY,fcal1,fcal2,fcal3,index

;1st Calipso File
hdf_sd_data,fcal1,'Number_Layers_Found',num1
hdf_sd_data,fcal1,'Layer_Top_Altitude',top1
hdf_sd_data,fcal1,'Layer_Base_Altitude',bot1
hdf_sd_data,fcal1,'Opacity_Flag',o_flag1
hdf_sd_data,fcal1,'Horizontal_Averaging',horz1
hdf_sd_data,fcal1,'Feature_Classification_Flags',fcf1
hdf_sd_data,fcal1,'Feature_Optical_Depth_532',taua1
hdf_sd_data,fcal1,'Feature_Optical_Depth_1064',taub1
hdf_sd_data,fcal1,'CAD_Score',cad1
hdf_sd_data,fcal1,'Day_Night_Flag',DN1
num1=reform(num1)
DN1=reform(DN1)

;2nd Calipso File
hdf_sd_data,fcal2,'Number_Layers_Found',num2
hdf_sd_data,fcal2,'Layer_Top_Altitude',top2
hdf_sd_data,fcal2,'Layer_Base_Altitude',bot2
hdf_sd_data,fcal2,'Opacity_Flag',o_flag2
hdf_sd_data,fcal2,'Horizontal_Averaging',horz2
hdf_sd_data,fcal2,'Feature_Classification_Flags',fcf2
hdf_sd_data,fcal2,'Feature_Optical_Depth_532',taua2
hdf_sd_data,fcal2,'Feature_Optical_Depth_1064',taub2
hdf_sd_data,fcal2,'CAD_Score',cad2
hdf_sd_data,fcal2,'Day_Night_Flag',DN2
num2=reform(num2)
DN2=reform(DN2)

;3rd Calipso File
hdf_sd_data,fcal3,'Number_Layers_Found',num3
hdf_sd_data,fcal3,'Layer_Top_Altitude',top3
hdf_sd_data,fcal3,'Layer_Base_Altitude',bot3
hdf_sd_data,fcal3,'Opacity_Flag',o_flag3
hdf_sd_data,fcal3,'Horizontal_Averaging',horz3
hdf_sd_data,fcal3,'Feature_Classification_Flags',fcf3
hdf_sd_data,fcal3,'Feature_Optical_Depth_532',taua3
hdf_sd_data,fcal3,'Feature_Optical_Depth_1064',taub3
hdf_sd_data,fcal3,'CAD_Score',cad3
hdf_sd_data,fcal3,'Day_Night_Flag',DN3
num3=reform(num3)
DN3=reform(DN3)

;Concatenate Arrays
num = [num1,num2,num3]
top = [ [top1],[top2],[top3] ]
bot = [ [bot1],[bot2],[bot3] ]
opacity = [ [o_flag1],[o_flag2],[o_flag3] ]
horz = [ [horz1],[horz2],[horz3] ]
fcf  = [ [fcf1],[fcf2],[fcf3] ]
tau532 = [ [taua1],[taua2],[taua3] ]
tau1064 = [ [taub1],[taub2],[taub3] ]
cad = [ [cad1],[cad2],[cad3] ]
dn  = [dn1,dn2,dn3]

res=size(index)
alay_num = intarr(res(1))
alay_top = fltarr(8,res(1))
alay_base = fltarr(8,res(1))
alay_opacity_flag = intarr(8,res(1))
alay_horz = intarr(8,res(1))
alay_fcf = make_array(8,res(1),/uint)
alay_tau_532 = fltarr(8,res(1))
alay_tau_1064 = fltarr(8,res(1))
DN_flag = intarr(res(1))
for i=0l,res(1)-1 do begin
 if index(i) gt -9999.00 then begin
  alay_num(i)   = num(index(i))
  alay_top(*,i) = top(*,index(i))
  alay_base(*,i) = bot(*,index(i))
  alay_opacity_flag(*,i) = opacity(*,index(i))
  alay_horz(*,i) = horz(*,index(i))
  alay_fcf(*,i) = fcf(*,index(i))
  alay_tau_532(*,i) = tau532(*,index(i))
  alay_tau_1064(*,i) = tau1064(*,index(i))
  dn_flag(i) = dn(index(i))
 endif
 if index(i) eq -9999.00 then begin
  alay_num(i) = -9999.00
  alay_top(*,i) = -9999.00
  alay_base(*,i) = -9999.00
  alay_opacity_flag(*,i) = -9999.00
  alay_horz(*,i) = -9999.00
  alay_fcf(*,i) = 0   ;sets a 0 for all bit interpretations
  alay_tau_532(*,i) = -9999.00
  alay_tau_1064(*,i) = -9999.00
  dn_flag(i) = -9999.00
 endif
endfor

alay_flag_byte = alay_fcf

save,filename='alay.sav',alay_num,alay_top,alay_base,alay_opacity_flag,alay_horz,alay_flag_byte,alay_tau_532,alay_tau_1064,DN_flag

return
end
