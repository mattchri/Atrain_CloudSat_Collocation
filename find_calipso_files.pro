;+
;NAME:
;
;   Find Calipso Files
;
;PURPOSE:
;
;   This procedure is used to obtain the span of Calipso files that covers the cloudsat orbit
;
;INPUT:  fsat = cloudsat file  &  cpath = calipso directory where files are stored
;
;OUTPUT: fcal(3) = name of calipso files
;file_flag = 0 all three calipso files were found
;file_flag = 1 some calipso files are missing
;
;Sub Routines
;  cs_file_info.pro
;  cal_file_info.pro
;
;EXAMPLE
;find_calipso_files,'/dingo/cloudsat/2b-geoprof/2007001054820_03610_CS_2B-GEOPROF_GRANULE_P_R04_E02.hdf','/raid3/chrismat/calipso/5km_alay/',fcal
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO FIND_CALIPSO_FILES,fsat,cpath,fcal,file_flag

cs_file_info,fsat,cs_p,cs_time
t0 = cs_time(7)
t1 = t0 + 5933.  ;approximate end of orbit time

;cal_files=file_search(cpath+'*.hdf',count=ct)
restore,cpath

fcal = strarr(3)
fct = 0
for i=0l,ct-2 do begin
 cal_file_info,cal_files(i),cal_p,cal_time
 if (t0 - 3160) lt cal_time(7) and t1 gt cal_time(7) then begin
  ;print,cal_files(i)
  fcal(fct) = cal_files(i)
  fct = fct+1
 endif
endfor
if fct gt 0 then fcal = fcal(0:fct-1)
file_flag = 0
if fct le 2 then begin
 if fct eq 0 then print,'Missing All Calipso Files'
 if fct eq 1 then print,'Missing 2 Calipso Files'
 if fct eq 2 then print,'Missing 1 Calipso File'
 print,''
 file_flag = 1
endif

return
end
