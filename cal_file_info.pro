;+
;NAME:
;
;   Calipso File Information
;
;PURPOSE:
;
;   This procedure is used to obtain the time stamp of any Calipso file
;
;INPUT: file = Calipso File Name
;
;OUTPUT: Prefix = common feature to all calipso files last 25 characters
;TIME(9)
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
;cal_file_info,'/raid3/chrismat/calipso/5km_alay/CAL_LID_L2_05kmALay-Prov-V2-01.2007-08-08T22-27-56ZD.hdf',p,t
;
;AUTHOR:
;    Matt Christensen
;    Colorado State University
;###########################################################################
PRO CAL_FILE_INFO,file,prefix,time

a = strpos(file,'.hdf')
prefix = strmid(file,a-21,21)
year = strmid(prefix,0,4)*1D
month = strmid(prefix,5,2)*1D
mday = strmid(prefix,8,2)*1D
hour = strmid(prefix,11,2)*1D
min = strmid(prefix,14,2)*1D
sec = strmid(prefix,17,2)*1D
yday = ( julday(month,mday,year) - julday(1,0,year) )*1D
TAI = ( JULDAY(Month, MDay, Year, Hour, Min, Sec) - JULDAY(1,1,1993,0,0,0) )*24D*3600D

;print,year,' ',yday,'  ',hour,'  ',min,' ',sec,'  ',month,'  ',mday,'  ',TAI
;Confirm
;hdf_sd_data,file,'Profile_Time',TAI_f
;print,TAI_f(0,0)-TAI

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
time(8) = -99

return
end