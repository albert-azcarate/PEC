.text
movi r0, 32
rds r5, s7
st 0(r0), r5
movi r1,255
wrs s7, r1
rds r5, s7
st 2(r0), r5
di
rds r5, s7
st 4(r0), r5
ei
rds r5, s7
st 6(r0), r5
ld r5, 0(r0)
ld r5, 2(r0)
ld r5, 4(r0)
ld r5, 6(r0)
halt