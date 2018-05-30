;+
;NAME:
;
;   Vertical Feature Mask Flag Detection
;
;PURPOSE:
;
;   This procedure is used to convert 16-bit numbers to integers for interpretation.
;
;DESCRIPTION:
;
;  For a complete list of Bit Interpretations see the CALIPSO QAULITY STATEMENTS:
;  LIDAR LEVEL 2 VERTICAL FEATURE MASK  
;  VERSION RELEASES:  2.01 & 2.02
;  http://eosweb.larc.nasa.gov/PRODOCS/calipso/Quality_Summaries/CALIOP_L2VFMProducts_2.01.html
;
;OUTPUT:  FLAG_NUM = (10,HEIGHT INDEX, COLUMN INDEX)
;BITS 1-3   -->  FLAG_NUM(0,*,*) = Feature Type (2=cloud 3=aerosol)
;BITS 4-5   -->  FLAG_NUM(1,*,*) = Feature Type QA
;BITS 6-7   -->  FLAG_NUM(2,*,*) = Phase (1=ice, 2=water, 3=mixed)
;BITS 8-9   -->  FLAG_NUM(3,*,*) = Ice/Water Phase QA
;BITS 10    -->  FLAG_NUM(4,*,*) = Aerosol Feature Sub-type
;BITS 11    -->  FLAG_NUM(5,*,*) = Cloud Feature sub-type
;BITS 12    -->  FLAG_NUM(6,*,*) = Cloud Feature sub-type
;BITS 13    -->  FLAG_NUM(7,*,*) = Cloud / Aerosol/PSC Type QA
;BITS 14-16 -->  FLAG_NUM(8,*,*) = Horizontal Averaging
;ERROR      -->  FLAG_NUM(9,*,*)  *if no error then val = 0 else val eq 1
;
;SUB ROUTINE:  DECOMPOSE_BYTE.PRO
;  modified from the calipso data sets VFM Feature Flag Reader
;  http://eosweb.larc.nasa.gov/PRODOCS/calipso/Tools/vfm_feature_flags.html
;
;all websites last accessed on 01/15/09
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################

PRO VFM_FLAGS,FLAG_BYTE,FLAG_NUM

res=size(flag_byte)
flag_num    = intarr(10,res(1),res(2))
ct=0
for i=0l,res(2)-1 do begin
  for j=0,res(1)-1 do begin
    val = flag_byte(j,i)
    decompose_byte,val,data_num
    flag_num(*,ct,i) = data_num 
    ct=ct+1    
  endfor
ct=0
endfor

return
end
