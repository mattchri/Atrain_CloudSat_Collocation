;+
;NAME:
;
;   Start CloudSat/Calipso Collocation Procedure
;
;PURPOSE:
;
;   This procedure is used to collocate the aerosol and cloud layer product from Calipso
;   with the geoprof-lidar product from CloudSat for a specified month and year period.
;
;INPUT: Year and Month
;INSIDE PROGRAM first couple of lines:  change the path names to the directory with calipso data
;Need:  5km Aerosol and Cloud Layer Products and the Level 1 Data
;
;OUTPUT: collocated hdf file
;
;EXAMPLE
;start_collocation,2007,1
;for i=2007,2010 do for j=1,12 do start_collocation,i,j
;
;start_collocation,2008,6
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO START_COLLOCATION,year,month

geoprof_path = '/group_workspaces/cems2/nceo_generic/satellite_data/cloudsat/2b-geoprof/R05/'
alay_5km_path = '/group_workspaces/cems2/nceo_generic/satellite_data/calipso/ALay5km/'
clay_5km_path = '/group_workspaces/cems2/nceo_generic/satellite_data/calipso/CLay5km/'
outPath       = '/group_workspaces/cems2/nceo_generic/satellite_data/cloudsat/2b-geoprof-aerosol/'
 FILE_MKDIR,outPath

cal_files=file_search(alay_5km_path+'*.hdf',count=ct)
save,filename=outPath+'alay_dirlist.sav',cal_files,ct

cal_files=file_search(clay_5km_path+'*.hdf',count=ct)
save,filename=outPath+'clay_dirlist.sav',cal_files,ct

;Construct year month string
fstrng = string(format='(i4,"_",i02)',year,month)

;openw,2,fstrng+'_missing_log.list'

build_cloudsat_file_list,geoprof_path,year,month,fsat,fct
if fct gt 0 then begin
sz = size(fsat)
for i=0,sz(1)-1 do begin

;Check to see if the data was already constructed
cs_file_info,fsat(i),prefix
temp=file_search(outPath+prefix+'*.sav',count=tempct)

if tempct eq 1 then print,'Skip '+temp(0)

if tempct eq 0 then begin
print,'Acquire '+prefix
  
 find_calipso_files,fsat(i),outPath+'alay_dirlist.sav',fcal_alay,file_flag_alay
 find_calipso_files,fsat(i),outPath+'clay_dirlist.sav',fcal_clay,file_flag_clay
 if file_flag_alay eq 0 and file_flag_clay eq 0 then begin   ;All calipso files need to exist

 ;Plot orbits to make sure they line up
 ;find_calipso_files,fsat(i),'clay_dirlist.sav',fcal  
 ;plot_orbit_collocation,fsat(i),fcal(0),fcal(1),fcal(2)

  ;Collocate 5km Layer
  CCC,fsat(i),fcal_alay(0),fcal_alay(1),fcal_alay(2),5,20.,index_5km,dist_5km,num_5km,f_index_5km,filen,bkflag
  ffsat=fsat(i)
  
  save,filename=outPath+'ccc.sav',index_5km,dist_5km,num_5km,f_index_5km,filen,fcal_alay,fcal_clay,ffsat
  BUILD_ALAY,fcal_alay(0),fcal_alay(1),fcal_alay(2),index_5km
  BUILD_CLAY,fcal_clay(0),fcal_clay(1),fcal_clay(2),index_5km
  BUILD_COLLOCATION_VARS,fsat(i)
  CREATE_SAV,filename
  stop
   junkstr='mv '+filename+' ./2b-geoprof-aerosol/'
   spawn,junkstr
   print,'SAV FILE CREATED   ',junkstr 
 endif else begin
  cs_file_info,fsat(i),p,t
  printf,2,p
 endelse

endif
  
endfor

endif else begin
 printf,2,'No_CloudSat_Files_to_do_collocation'
endelse

;close,2

return
end
