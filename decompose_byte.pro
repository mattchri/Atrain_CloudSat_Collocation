pro decompose_byte,val,data_num

data_num = intarr(10)

feature_type = 0
feature_type_qa = 0
ice_water_phase = 0
ice_water_phase_qa = 0
feature_subtype = 0
cloud_aerosol_psc_type_qa = 0
horizontal_averaging = 0

for i=0,15 do begin
  if ((val and 2L^i) NE 0) then begin
    ;print,'Bit set: ',i+1
    case i+1 of
    1 : feature_type = feature_type + 1
    2 : feature_type = feature_type + 2
    3 : feature_type = feature_type + 4
    4 : feature_type_qa = feature_type_qa + 1
    5 : feature_type_qa = feature_type_qa + 2
    6 : ice_water_phase = ice_water_phase + 1
    7 : ice_water_phase = ice_water_phase + 2
    8 : ice_water_phase_qa = ice_water_phase_qa + 1
    9 : ice_water_phase_qa = ice_water_phase_qa + 2
    10 : feature_subtype = feature_subtype + 1
    11 : feature_subtype = feature_subtype + 2
    12 : feature_subtype = feature_subtype + 4
    13 : cloud_aerosol_psc_type_qa = cloud_aerosol_psc_type_qa + 1
    14 : horizontal_averaging = horizontal_averaging + 1
    15 : horizontal_averaging = horizontal_averaging + 2
    16: horizontal_averaging = horizontal_averaging + 4
    else:
    endcase
  endif
endfor

case feature_type of
0 : data_num(0) = 0
1 : data_num(0) = 1
2 : begin
      data_num(0) = 2;print,"Feature Type : cloud"
      case feature_subtype of
      0 : data_num(5) = 0;print, "Feature Subtype : low overcast, transparent"
      1 : data_num(5) = 1;print, "Feature Subtype : low overcast, opaque"
      2 : data_num(5) = 2;print, "Feature Subtype : transition stratocumulus"
      3 : data_num(5) = 3;print, "Feature Subtype : low, broken cumulus"
      4 : data_num(5) = 4;print, "Feature Subtype : altocumulus (transparent)"
      5 : data_num(5) = 5;print, "Feature Subtype : altostratus (opaque)"
      6 : data_num(5) = 6;print, "Feature Subtype : cirrus (transparent)"
      7 : data_num(5) = 7;print, "Feature Subtype : deep convective (opaque)"
      else : data_num(9) = 1;print,"*** error getting Feature Subtype"
      endcase
    end
3 : begin
      data_num(0) = 3;print,"Feature Type : aerosol"
      case feature_subtype of
      0 : data_num(4) = 0;print, "Feature Subtype : not determined"
      1 : data_num(4) = 1;print, "Feature Subtype : clean marine"
      2 : data_num(4) = 2;print, "Feature Subtype : dust"
      3 : data_num(4) = 3;print, "Feature Subtype : polluted continental"
      4 : data_num(4) = 4;print, "Feature Subtype : clean continental"
      5 : data_num(4) = 5;print, "Feature Subtype : polluted dust"
      6 : data_num(4) = 6;print, "Feature Subtype : smoke"
      7 : data_num(4) = 7;print, "Feature Subtype : other"
      else : data_num(9) = 1;print,"*** error getting Feature Subtype"
      endcase
    end
4 : begin
      data_num(0) = 4;print,"Feature Type : stratospheric feature--PSC or stratospheric aerosol"
      case feature_subtype of
      0 : data_num(6) = 0;print, "Feature Subtype : not determined"
      1 : data_num(6) = 1;print, "Feature Subtype : non-depolarizing PSC"
      2 : data_num(6) = 2;print, "Feature Subtype : depolarizing PSC"
      3 : data_num(6) = 3;print, "Feature Subtype : non-depolarizing aerosol"
      4 : data_num(6) = 4;print, "Feature Subtype : depolarizing aerosol"
      5 : data_num(6) = 5;print, "Feature Subtype : spare"
      6 : data_num(6) = 6;print, "Feature Subtype : spare"
      7 : data_num(6) = 7;print, "Feature Subtype : other"
      else : data_num(9) = 1;print,"*** error getting Feature Subtype"
      endcase
    end
5 : data_num(0) = 5;print,"Feature Type : surface"
6 : data_num(0) = 6;print,"Feature Type : subsurface"
7 : data_num(0) = 7;print,"Feature Type : no signal (totally attenuated)"
else : data_num(9) = 1;print,"*** error getting Feature Type"
endcase

case feature_type_qa of
0 : data_num(1) = 0;print,"Feature Type QA : none"
1 : data_num(1) = 1;print,"Feature Type QA : low"
2 : data_num(1) = 2;print,"Feature Type QA : medium"
3 : data_num(1) = 3;print,"Feature Type QA : high"
else : data_num(9) = 1;print,"*** error getting Feature Type QA"
endcase

case ice_water_phase of
0 : data_num(2) = 0;print,"Ice/Water Phase : unknown/not determined"
1 : data_num(2) = 1;print,"Ice/Water Phase : ice"
2 : data_num(2) = 2;print,"Ice/Water Phase : water"
3 : data_num(2) = 3;print,"Ice/Water Phase : mixed phase"
else : data_num(9) = 1;print,"*** error getting Ice/Water Phase"
endcase

case ice_water_phase_qa of
0 : data_num(3) = 0;print,"Ice/Water Phase QA: none"
1 : data_num(3) = 1;print,"Ice/Water Phase QA: low"
2 : data_num(3) = 2;print,"Ice/Water Phase QA: medium"
3 : data_num(3) = 3;print,"Ice/Water Phase QA: high"
else : data_num(9) = 1;print,"*** error getting Ice/Water Phase QA"
endcase

if (cloud_aerosol_psc_type_qa eq 0) then begin
  data_num(7) = 0;print,"Cloud/Aerosol/PSC Type QA : not confident"
endif else begin
  data_num(7) = 1;print,"Cloud/Aerosol/PSC Type QA : confident"
endelse

case horizontal_averaging of
0 : data_num(8) = 0;print,"Horizontal averaging required for detection: not applicable"
1 : data_num(8) = 1;print,"Horizontal averaging required for detection: 1/3 km"
2 : data_num(8) = 2;print,"Horizontal averaging required for detection: 1 km"
3 : data_num(8) = 3;print,"Horizontal averaging required for detection: 5 km"
4 : data_num(8) = 4;print,"Horizontal averaging required for detection: 20 km"
5 : data_num(8) = 5;print,"Horizontal averaging required for detection: 80 km"
else : data_num(8) = 6;print,"*** error getting Horizontal averaging"
endcase
return
end