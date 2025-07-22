* Contributed by Dr. Avijit Dey
function colorbar (args)

sdate=subwrd(args,1)
year=subwrd(args,2)
phys=subwrd(args,3)

'clear'

'run GREEN-65.gs'

cl=' 2   4   8   12  18  25  35'
cc=' 0  70  65   60  55  50  45  40 35'

tt=1
m=1
while (tt<=31)

'reinit'
'open ~/'phys'/'sdate'/enmean/prec/prec'year''sdate'00_0.5X0.5_24hr.ctl'

'set vpage 0.0 11.0 0.0 8.5'
'set parea 1.0 10.0 1 7.1'
'set grads off';'set grid off'
'set mproj scaled';'set mpdset ./rupres';'set map 1 1 7'
'set lon 20 180';'set lat -25 48';'set t 'tt

'set ylint 10';'set xlint 20'
'set xlopts  1 6 0.16 `0';'set ylopts  1 6 0.16 `0'
'set gxout shaded'
'set clevs 'cl;'set ccols 'cc
'd APCPsfc'

'q dims'
line3=sublin(result,5)
ttime=subwrd(line3,6) 
timestamp = 'MPME Forecast Valid Time = ' % ttime
say timestamp
'close 1'

'open ~/'phys'/'sdate'/enmean/uwnd/uwnd'year''sdate'00_0.5X0.5.ctl'
'open ~/'phys'/'sdate'/enmean/vwnd/vwnd'year''sdate'00_0.5X0.5.ctl'

'set lon 20 180';'set lat -25 48';'set lev 850';'set t 'tt+1
'set gxout vector'
len = 0.5;scale = 20;xrit = 9.73;ybot =7.28

'set arrscl 'len' 'scale;'set arrowhead 0.06';'set arrlab off'
'set ccolor 1';'set cthick 5'
'd skip(UGRDprs.1,7);VGRDprs.2'

'set string 2 l 8 0'
'set strsiz 0.23'
'draw string 1.2 8.3 `4' % timestamp

'set string 4 l 8 0'
'set strsiz 0.19'
'draw string 0.8 7.4 `4 Rainfall (shaded, mm/day) &'
'draw string 5.6 7.4 `4 850hPa winds (vector,   )'

'set string 1 c 8 0'
'draw string 5 7.85 `4 Initial Condition : 'year''sdate''

rc = arrow(xrit-0.25,ybot+0.2,len,scale)

'run cbarn-1.gs 0.8 0 5.5 0.35'
'gxprint PLOTS_ANIM/'year'/'sdate'/PNG/prec_'phys'_'year''sdate'_'m'.png png white'

tt=tt+1
m=m+1
'close 2'
'close 1'
endwhile
'quit'

function arrow(x,y,len,scale)
'set line 4 1 4'
'draw line 'x-len/3.' 'y' 'x+len/2.' 'y
'draw line 'x+len/3.-0.05' 'y+0.025' 'x+len/2.' 'y
'draw line 'x+len/3.-0.05' 'y-0.025' 'x+len/2.' 'y
'set string 4 c 6 0'
'set strsiz 0.15 0.15'
'draw string 'x' 'y-0.1' 'scale
return

