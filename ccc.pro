;+
;NAME:
;
;   Cloudsat Calipso Collocation
;
;PURPOSE:
;
;   This procedure is used to collocate the nearest calipso positions with cloudsat.
;
;DESCRIPTION:
;
;   Cloudsat has 1km horz resolution
;   Calipso has 5km horz res divided into 15 for the lowest
;   portion of the atmosphere ~333m
;
;INPUT: fsat  = cloudsat file
;       fcal1 = 1st calipso file
;	    fcal2 = 2nd calipso file
;       fcal3 = 3rd calipso file
;		search_range = Farthest Distance to find a nearest neighbor [km]
;       acceptable_dist = Farthest Distance to do a collocation
;
;OUTPUT:
;index(cs_index)  = calipso bin along 3 files matched to the cloudsat bin
;dist(cs_index)   = distance between nearest cloudsat and calipso neighbors
;num(3) = # of elements in each calipso file
;filen(cs_index) = Calipso file number (1-3 e.g. 1st, 2nd, 3rd in collocation)
;bkflag = 0 collocation was successful;  = 1 collocation was unsuccessful  ("break out of loop flag")
;
;Example
;CCC,'/dingo/cloudsat/2b-geoprof-lidar/2007001054820_03610_CS_2B-GEOPROF-LIDAR_GRANULE_P1_R04_E02.hdf','/dingo/cloudsat/cal_lid_l1/CAL_LID_L1-Prov-V2-01.2007-01-01T05-19-30ZN.hdf','/dingo/cloudsat/cal_lid_l1/CAL_LID_L1-Prov-V2-01.2007-01-01T06-05-50ZD.hdf','/dingo/cloudsat/cal_lid_l1/CAL_LID_L1-Prov-V2-01.2007-01-01T06-58-25ZN.hdf',1,1.,index,dist,num
;CCC,'/dingo/cloudsat/2b-geoprof-lidar/2007001054820_03610_CS_2B-GEOPROF-LIDAR_GRANULE_P1_R04_E02.hdf','/raid3/chrismat/calipso/5km_clay/CAL_LID_L2_05kmCLay-Prov-V2-01.2007-01-01T05-19-30ZN.hdf','/raid3/chrismat/calipso/5km_clay/CAL_LID_L2_05kmCLay-Prov-V2-01.2007-01-01T06-05-50ZD.hdf','/raid3/chrismat/calipso/5km_clay/CAL_LID_L2_05kmCLay-Prov-V2-01.2007-01-01T06-58-25ZN.hdf',1,15.,index,dist,num
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO CCC,fsat,fcal1,fcal2,fcal3,search_range,acceptable_dist,index,dist,num,f_index,filen,bkflag

;CloudSat Lat and Lon
hdf_vd_data,fsat,'Latitude',latsat
hdf_vd_data,fsat,'Longitude',lonsat

;Determine array structure
hdf_sd_data,fcal1,'Latitude',latcal1
arrsz = size(latcal1)
if arrsz(1) eq 1 then ftype=1
if arrsz(1) eq 3 then ftype=2

;Calipso 1 LAT and LON are sd data
hdf_sd_data,fcal1,'Latitude',latcal1
  if ftype eq 1 then latcal1 = reform(latcal1)
  if ftype eq 2 then latcal1 = reform(latcal1(1,*))
hdf_sd_data,fcal1,'Longitude',loncal1
  if ftype eq 1 then loncal1 = reform(loncal1)
  if ftype eq 2 then loncal1 = reform(loncal1(1,*))
  n1 = n_elements(loncal1)
  
;Calipso 2 LAT and LON are sd data
hdf_sd_data,fcal2,'Latitude',latcal2
  if ftype eq 1 then latcal2 = reform(latcal2)
  if ftype eq 2 then latcal2 = reform(latcal2(1,*))
hdf_sd_data,fcal2,'Longitude',loncal2
  if ftype eq 1 then loncal2 = reform(loncal2)
  if ftype eq 2 then loncal2 = reform(loncal2(1,*))
  n2 = n_elements(loncal2)
  
;Calipso 3 LAT and LON are sd data
hdf_sd_data,fcal3,'Latitude',latcal3
  if ftype eq 1 then latcal3 = reform(latcal3)
  if ftype eq 2 then latcal3 = reform(latcal3(1,*))
hdf_sd_data,fcal3,'Longitude',loncal3
  if ftype eq 1 then loncal3 = reform(loncal3)
  if ftype eq 2 then loncal3 = reform(loncal3(1,*))
  n3 = n_elements(loncal3)
  
num = lonarr(3)
num(0) = n1
num(1) = n2
num(2) = n3
latcal = [latcal1,latcal2,latcal3]
loncal = [loncal1,loncal2,loncal3]

if 4 gt 5 then begin
 ;Plot Orbits
 id=0
 lonll=lonsat(id)-.25
 lonur=lonsat(id)+.25
 latll=latsat(id)-.25
 latur=latsat(id)+.25
 map_set,0.,0.,limit=[latll,lonll,latur,lonur],londel=60,latdel=30,title=titl,$
 /label,lonalign=-.5,lonlab=latll,latlab=lonll,/continents
 oplot,lonsat,latsat,psym=1,color=50
 oplot,loncal,latcal,psym=1,color=250
 for i=0,20000 do xyouts,loncal(i)+.001,latcal(i),string(format='(i4)',i)
endif

res=size(lonsat)
res1=size(loncal)

index = fltarr(2,res(1))

;search_range = 1.      ;Distance to collocation within 1km
view_window  = ( fix(search_range/0.334)+1 )*2.     ;# of indices away from starting collocation

new_dis = fltarr(res(1))
flag = intarr(res(1))
ist = 0l
ied = res(1)-1
jst=0
jed=res1(1)-1
ct=0
sct=0
break_counter = 250     ;if nearest neighbor isn't found within 250 pixels 'scrap' the collocation
bct=0
bkflag=0
for i=ist,ied do begin  ;loop over cloudsat index
 if bkflag eq 0 then begin
 jct   = lonarr(50*search_range)
 dist  = fltarr(50*search_range)
 sct = 0
 
 for j=long(jst),jed do begin  ;loop over calipso ~8 times per cloudsat
    sdist = MAP_2POINTS( lonsat(i), latsat(i), loncal(j), latcal(j),/METERS)/1000.  
    if sdist lt search_range then begin
      jct(sct)   = j
      dist(sct)  = sdist
      sct=sct+1
    endif
  endfor

;print,i,jst,jed,sct
 
 if sct gt 0 then begin
  bct = 0                       ;reset break counter to zero because nearest neighbor was found
  jct = jct(0:sct-1)
  dist = dist(0:sct-1)
  ;Find the minimum distance
  a = where( dist eq min(dist) )
  cal_match = jct(a)
    match = cal_match(0)
  cal_dist  = dist(a)
    cdist = cal_dist(0)
    
  jst = match      ;Start Search from the last collocation
  jed = match+view_window
  if jed ge (res1(1)-1) then jed = res1(1)-1
   if cdist lt acceptable_dist then begin  ;nearest neighbor is within acceptable range
    index(0,i) = match
    index(1,i) = cdist   
   endif else begin						  ;nearest neighbor is NOT within acceptable range
    index(0,i) = -9999.00
    index(1,i) = -9999.00    
   endelse 
 endif else begin     ;Nearest neighbor wasn't found  
   bct = bct+1        ;bump bct because a nearest neighbor was not found    
   index(0,i) = -9999.00
   index(1,i) = -9999.00
   jed = res1(1)-1   ;make search range out to the end   
 endelse
 
 ;print,i,index(0,i),index(1,i),bct
 
 if bct eq break_counter then bkflag=1   ;if collocation isn't found within 250 iterations break out of the loop
 endif
endfor

if bkflag eq 0 then begin
temp  = index(0,*)
dist  = index(1,*)
dist  = reform(dist)
index = lonarr(res(1))
for i=0l,res(1)-1 do index(i)=temp(0,i)

;Routine to broaden index information
sz = size(index)
filen = lonarr(sz(1))
f_index = lonarr(sz(1))
filen(*) = -9999.00
f_index(*) = -9999.00
for i=0l,sz(1)-1 do begin
 if index(i) ge 0. and index(i) lt num(0) then begin
   f_index(i) = index(i)
   filen(i)=0
 endif
 if index(i) ge num(0) and index(i) lt (num(0)+num(1)) then begin
   f_index(i) = index(i)-num(0)
   filen(i)=1
 endif
 if index(i) ge (num(0)+num(1)) then begin
   f_index(i) = index(i)-(num(0)+num(1))
   filen(i)=2
 endif
endfor 

endif

return
end
