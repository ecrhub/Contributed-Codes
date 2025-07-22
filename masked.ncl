;---- Contributed by Dr. Ankur Srivastava -------
; masking data using shapefiles -------
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 

undef("indiaShpMask")
function indiaShpMask(x[*][*])
begin
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;load "/moes/home/pradhan/TEST_SCRIPTS/shapefile_utils.ncl"

filenames = "~/India/INDIA.shp"
nfiles    = dimsizes(filenames)
shp_filename = "~/India/INDIA.shp"
x!0="lat"
x!1="lon"
 nt        = 0
 hgt       = x
 hgt@lat2d = x&lat
 hgt@lon2d = x&lon
 opt             = True
 opt@debug       = True
 opt@shape_names = "india"
 hgt_mask = shapefile_mask_data(hgt,shp_filename,opt)

;masked=hgt_mask({6.75:37.14},{68.12:97.42})
masked=hgt_mask;({6.75:37.14},{68.12:97.42})

return masked
end

;input data file to be masked
f=addfile("prate.nc","r")
p = f->prate(:,{5:40},{60:100})
p!0="time"
p!1="lat"
p!2="lon"

maskk = indiaShpMask(p(0,:,:))
maskedp=p
maskedp=maskedp@_FillValue

do i=0,dimsizes(maskedp(:,0,0)-1)
	print(""+i)
	maskedp(i,:,:) = where(.not.ismissing(maskk),p(i,:,:),maskedJAN@_FillValue)
end do

printVarSummary(maskedp)

;Write masked output to netcdf

diro="./"
filo="data_masked.nc"
system("/bin/rm -f "+diro+filo)      ; rm any pre-existing file
setfileoption("nc","Format","LargeFile")
f1=addfile(diro+filo, "c")
f1->precip=maskedp
