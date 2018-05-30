pro start_regrid_calipso

;hmax: aerosol layers less than 500 mb and temperature gt 273 K
dx = 100   ;cloudsat filtering width
files = file_search('./2b-geoprof-aerosol/*.sav',count=fct)

;Loop over each geoprof-aerosol file
for i=0,fct-1 do begin
 print,i,'  ',files(i)
 cs_file_info,files(i),prefix
 
 ;Check to see if the data was already constructed
 temp=file_search('./aerosol-profile/'+prefix+'*.sav',count=tempct)
 
 if tempct eq 1 then print,'Skip '+temp(0)
 if tempct eq 0 then begin  ;create file if it is missing
 print,'Acquire '+prefix

 
 ;Get ECMWF-AUX
 f_ecm = file_search('../../satellite/cloudsat/ecmwf-aux/'+prefix+'*.hdf',count=ecm_ct)
 if ecm_ct eq 1 then begin  ;begin only if ECMWF file exists
 restore,files(i)
 aalay_base = alay_base
 vfm_flags,alay_flag_byte,alay_flag_num
 
 ;Get temp, pressure, and height from ECMWF
 hdf_sd_data,f_ecm(0),'Temperature',T
 hdf_sd_data,f_ecm(0),'Pressure',P
 P=P*.01
 hdf_vd_data,f_ecm(0),'EC_height',h
 h=h*.001
 
 ;Define arrays
 aer_top = fltarr(n_elements(alay_num))			      ;top of highest aerosol layer
 aer_base = fltarr(n_elements(alay_num))		      ;base of lowest aerosol layer
 aer_tau532 = fltarr(n_elements(alay_num))		      ;total optical depth 532 nm
 aer_tau1064 = fltarr(n_elements(alay_num))		      ;total optical depth 1064 nm
 aer_species = fltarr(7,n_elements(alay_num))		      ;['Total','Marine','Dust','Polluted Continental','Clean Continental','Polluted Dust','Smoke']
 num_anthropogenic_fraction = fltarr(n_elements(alay_num))    ;anthropogenic fraction based on number
 tau_anthropogenic_fraction = fltarr(n_elements(alay_num))    ;anthropogenic fraction based on number weighted by optical thickness
 
 ;Loop over CloudSat
 for j=fix(dx/2.),n_elements(alay_num)-fix(dx/2.)-1 do begin
  
  ;Scanning window
  j0 = j-fix(dx/2.)
  j1 = j+fix(dx/2.)
  
  ;Aerosol tops less than 500 mb and warmer than 273 K
  vid = where( T(*,j) gt 273. and P(*,j) gt 500.,vct) 
  if vct gt 0. then begin  ;freezing level identified
   junk = where( h(vid) eq max(h(vid)) )
   hmax = h(vid(junk))
   hmax = hmax(0)
   
   ;Temp. Arrays
   atop    = fltarr(dx+1)
   a_base   = fltarr(dx+1)
   aod532  = fltarr(dx+1)
   aod1064 = fltarr(dx+1)
   species = fltarr(7,dx+1)  ;fraction for each species
   aprof = 0
   anum = 0
   ;Find all aerosol layers that are below hmax
   for k=j0,j1 do begin ;loop/filter over horizontal
    
    junk=where( (alay_top(*,k) gt -9999. and alay_top(*,k) lt hmax) and alay_flag_num(4,*,k) gt 0.,junkct)
    if junkct gt 0. then begin  ;want to know if an aerosol layer exists in profile and whether it is below hmax with an identifiable species.
     atop(aprof)    = max(ALAY_TOP(junk,k))        ;layer top height of highest aerosol layer
     a_base(aprof)  = min(AALAY_BASE(junk,k))      ;layer base height of lowest aerosol layer
     aod532(aprof)  = total(alay_tau_532(junk,k))  ;summation of all layers
     aod1064(aprof) = total(alay_tau_1064(junk,k)) ;summation of all layers
     
     id = where( alay_flag_num(4,junk,k) ge 1 and alay_flag_num(4,junk,k) le 6,totct)
     species(0,aprof) = totct    ;total number of aerosol layers in column
     for kk=1,6 do begin ;loop over each species
      id = where( alay_flag_num(4,junk,k) eq kk,totct)
      species(kk,aprof) = totct  ;total number of aerosol layers by *type*
     endfor    
     aprof = aprof + 1
    endif
   endfor
   if aprof gt 0 then begin ;collect data only if an aerosol layer was found in column
    aer_top(j)  = mean(atop(0:aprof-1))
    aer_base(j) = mean(a_base(0:aprof-1))
    aer_tau532(j) = mean(aod532(0:aprof-1))
    aer_tau1064(j)= mean(aod1064(0:aprof-1))
    for kk=0,6 do aer_species(kk,j) = total(species(kk,0:aprof-1))
    
    ;simple sum of polluted continental + polluted dust + smoke divided by the total    
    num_anthropogenic_fraction(j) = (aer_species(3,j) + aer_species(5,j) + aer_species(6,j))/(aer_species(0,j))   
    
     
    ;Now find anthropogenic fraction by the weight of the aerosol optical depth
    numerator = fltarr(aprof)
    denominator = fltarr(aprof)
    for jj=0,aprof-1 do begin
     
     ;Note this is for (polluted cont., dust, and smoke) we might want to calculate this for different combinations!!!!!!!!!
     numerator(jj) = aod532(jj)*species(3,jj) + aod532(jj)*species(5,jj) + aod532(jj)*species(6,jj)
     denominator(jj) = aod532(jj)*species(0,jj)
    endfor
     ;print,'num = ',total(numerator)
     ;print,'den = ',total(denominator)
     ;print,total(numerator)/total(denominator)
     tau_anthropogenic_fraction(j) = total(numerator)/total(denominator)
    
   endif else begin    ;if an aerosol layer does not exist within the window (100 km) set values to -9999
    aer_top(j)  = -9999.
    aer_base(j) = -9999.
    aer_tau532(j) = -9999.
    aer_tau1064(j)= -9999.
    for kk=0,6 do aer_species(kk,j) = 0
    num_anthropogenic_fraction(j) = -9999.
    tau_anthropogenic_fraction(j) = -9999.
   endelse
   
   ;print,j,j0,j1,hmax,aer_top(j),aer_tau532(j),aer_tau1064(j),aer_spec(0,j)
   ;print,j,num_anthropogenic_fraction(j),tau_anthropogenic_fraction(j)
   
  endif
  
 endfor
 
 ;id=where(tau_anthfrac ge 0.)
 ;window,0
 ;histo,-0.1,1.1,.1,1,'',tau_anthfrac(id)
 ;window,1
 ;histo,-0.1,1.1,.1,1,'',num_anthfrac(id)
 ;window,2
 ;histo,-1.1,1.1,.01,1,'',tau_anthfrac(id)-num_anthfrac(id)

 spcid=[1,2,3,4,5,6]
 species_id=['Total','Marine','Dust','Polluted Continental','Clean Continental','Polluted Dust','Smoke'] 
 savf = prefix+'_AEROSOL_PROFILE.sav'
 save,filename=savf,aer_top,aer_base,aer_tau532,aer_tau1064,aer_species,species_id,num_anthropogenic_fraction,tau_anthropogenic_fraction
 tstr = 'mv '+savf+' ./aerosol-profile/'
 print,tstr
 spawn,tstr
 endif

endif 
endfor

return
end

