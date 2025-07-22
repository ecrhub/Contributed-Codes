; ============================================================================================
 ;===To find Probability Density Function of Rainfall over Central India===
 ;######## Contributed by Dr. Maheswar Pradhan, IITM, Pune #########
; ============================================================================================
fin=addfile("daymean_merged_trmm.nc","r")
time=cd_calendar(fin->time,0)
year=time(:,0)
mon=time(:,1)
indi=ind(year .ge. 1998 .and. year .le. 2008 .and. mon .ge. 06 .and. mon .le. 09)
sst=lonFlip(fin->prate(indi,:,:))
sst=sst*24
if (any(isnan_ieee(sst))) then
    if(.not.isatt(sst,"_FillValue")) then
      sst@_FillValue = default_fillvalue(typeof(sst))
    end if
    replace_ieeenan (sst, sst@_FillValue, 0)
end if

ci_rain=dim_avg_n_Wrap(sst(:,{15:25},{70:85}),(/1,2/))
;print(ci_rain)
oci_pdf  = pdfx(ci_rain, 40, False)
printVarSummary(oci_pdf)
delete(fin)
delete(time)
delete(year)
delete(mon)
delete(indi) 
delete(sst)
delete(ci_rain)

diro="./"
filo="ci_rainfall_pdf.nc"
system("/bin/rm -f "+diro+filo)      ; rm any pre-existing file
setfileoption("nc","Format","LargeFile")
f = addfile(diro+filo, "c")
f->rf_pdf=oci_pdf
delete(f)

