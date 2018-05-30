pro hdf_vd_data,fname,tstr,data

file_id = hdf_open(fname,/read)
Result = HDF_VD_FIND(file_id, tstr)
vdata_h = HDF_VD_ATTACH(file_id, Result, /READ)
hdf_vd_get,vdata_h,name=xname
;print,xname
nscan = hdf_vd_read(vdata_h,data)
hdf_vd_detach,vdata_h

hdf_close,file_id

return
end
