;+
;NAME:
;
;   CloudSat File Information
;
;PURPOSE:
;
;   This procedure is used to obtain the time stamp of any CloudSat file
;
;INPUT: file = CloudSat File Name
;
;OUTPUT: Prefix = common feature to all CloudSat files first 19 characters
;Time(9)
;Time(0) = year
;Time(1) = day of the year (1-365) or (1-366)
;Time(2) = Month
;Time(3) = Day of the month
;Time(4) = Hour (0-23)
;Time(5) = Minute (0-59)
;Time(6) = Second (0-59)
;Time(7) = Time expressed in International Atomic Time (TAI) units are in seconds since January 1, 1993
;Time(8) = Orbit #   Calipso = -99
;
;EXAMPLE
;cs_file_info,'/dingo/cloudsat/2b-geoprof/2008075055414_10003_CS_2B-GEOPROF_GRANULE_P_R04_E02.hdf',p,t
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO CS_FILE_INFO,file,prefix,time

a = strpos(file,'_CS_')  ;CloudSat files all have _CS_ after the prefix
prefix = strmid(file,a-19,19)

year = strmid(prefix,0,4)*1D
yday = strmid(prefix,4,3)*1D
hour = strmid(prefix,7,2)*1D
min = strmid(prefix,9,2)*1D
sec = strmid(prefix,11,2)*1D
orbit = strmid(prefix,14,5)*1D
CALDAT,JULDAY(1,yday,year),month,mday
TAI = ( JULDAY(Month, MDay, Year, Hour, Min, Sec) - JULDAY(1,1,1993,0,0,0) )*24D*3600D

;print,year,' ',yday,'  ',hour,'  ',min,' ',sec,'  ',month,'  ',mday,'  ',TAI
;Confirm Time
;hdf_vd_data,file,'TAI_start',TAI_f
;print,TAI_f - TAI
    
;Construct Time array
time = dblarr(9)
time(0) = year
time(1) = yday
time(2) = month
time(3) = mday
time(4) = hour
time(5) = min
time(6) = sec
time(7) = TAI
time(8) = orbit

return
end