; Contributed by Dr. Sandeep Narayanasetti 
; Calculate ice areas
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;load "./area_rectlinear_grid.ncl"
;
;       nlat = 200 
;       lat = latGau(nlat, "lat", "latitude", "degrees_north")
;
;       mlon = 360
;       lon = lonGlobeF(mlon, "lon", "longitude", "degrees_east")
;
;       area = area_global_rectilinear_grid (lat, lon, False)
;       printVarSummary(area) 
;
; diro="./"
; filo="cell_area.nc"
; system("/bin/rm -f "+diro+filo)      ; rm any pre-existing file
; setfileoption("nc","Format","LargeFile")
; f = addfile(diro+filo, "c")
; f->area=area

;;;;;;;;;;;;;;;;This Script is used to Calculate Ice Area Extent ;;;;;;;;;;;;;;;;;;;;;;;;

f4=addfile("./grid_spec.nc","r")

AREA_OCN=doubletofloat(f4->AREA_ATM)

rad=6371.0*10^3

area_cell_ocn=AREA_OCN/4*3.14*rad*rad

;f1=addfile("","r")
f1=addfile("cn_merged_1850-2014_monmean_hist_iitmesm_reg_clim.nc","r")

cn_sum=f1->cn_sum

;cn_sum=dim_sum_n_Wrap(cn,1)

printVarSummary(cn_sum)

;print(cn_sum)

cn_sum_annmean=dim_avg_n_Wrap(cn_sum,0)

printVarSummary(cn_sum_annmean)

;copy_VarCoords(cn_sum_annmean,AREA_OCN)
copy_VarCoords(cn_sum_annmean,area_cell_ocn)

printVarSummary(AREA_OCN)

area_extent=cn_sum

printVarSummary(area_extent)

do k=0,11
	do j=0,93
		do i=0,191
			if (.not.ismissing(cn_sum(k,j,i))) then
 				if (cn_sum(k,j,i).gt.0.15)
			    area_extent(k,j,i)=cn_sum(k,j,i)*area_cell_ocn(j,i)
     	   else
				area_extent(k,j,i)=0.0
      	end if
      end if
		end do
	end do
end do
 diro="./"
 filo="cell_area_esmv2.nc"
 system("/bin/rm -f "+diro+filo)      ; rm any pre-existing file
 setfileoption("nc","Format","LargeFile")
 f = addfile(diro+filo, "c")
 f->area=area_extent !!! Area in Million Sq km
exit
end

