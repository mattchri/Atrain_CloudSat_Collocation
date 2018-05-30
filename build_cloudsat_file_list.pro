pro build_cloudsat_file_list,geoprof_lidar_path,year,month,files,ct

yday1 = ( julday(month,1,year) - julday(1,0,year) )
yday2 = ( julday(month+1,1,year) - julday(1,0,year) )-1

print,'Day Range = ',yday1,yday2

files = strarr(500)
ct = 0
for i=yday1,yday2 do begin
 tstr = string(format='(i4,i03)',year,i)
 YYYY = string(format='(i4)',year)
 DDD = STRING(FORMAT='(I03)',I)
 cloudsat_files = file_search(geoprof_lidar_path+YYYY+'/'+DDD+'/*'+tstr+'*.hdf',count=sct)
 if sct gt 0 then begin
  for j=0,sct-1 do begin
   files(ct) = cloudsat_files(j)
   ct = ct+1
  endfor
 endif else begin
  print,'MISSING DAY:  ',tstr+'*.hdf'
 endelse
endfor
files = files(0:ct-1)

print,string(format='("# of files found:  ",i3)',ct)

return
end
