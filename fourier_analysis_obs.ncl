; ============================================================================================
 ;===To find diurnal phase and amplitude of rainfall ===
 ;######## Contributed by Dr. Maheswar Pradhan, IITM, Pune #########
; ============================================================================================
fc=addfile("./trmm_data.nc","r")
time    = fc->time 
TIME    = cd_calendar(time, 0)             ; type float 
month   = toint( TIME(:,1) )
indi    = ind(month .ge. 06 .and. month .le. 09)
rainc   = fc->prate(indi,{-40:40},:)
dims=dimsizes(rainc)
ntim=dims(0)
nlat=dims(1)
nlon=dims(2)
print(ntim)
print(nlat)
print(nlon)
climh=new((/8,nlat,nlon/),float)
do i=0,7
 climh(i,:,:)=dim_avg_n_Wrap(rainc(i:ntim-(8-i):8,:,:),0)
end do
copy_VarCoords(rainc(0,:,:) ,climh(0,:,:))
climh!0="time"
printVarSummary(climh)

;time=cd_calendar(f->time,0)
;indi=ind(time(:,1) .ge. 06 .and. time(:,1) .le. 09)
;rain=f->prate(indi,{5:40},{60:100})
nhar=4
finfo = fourier_info(climh(lat|:,lon|:,time|:), nhar, 1.) ; fourier_info works on right dim
copy_VarCoords(climh(0,:,:),finfo(0,:,:,0))

diro="./"
filo="fourier_clim_trmm_Global.nc"
system("/bin/rm -f "+diro+filo)      ; rm any pre-existing file
setfileoption("nc","Format","LargeFile")
f = addfile(diro+filo, "c")
f->finfo=finfo
delete(f)
