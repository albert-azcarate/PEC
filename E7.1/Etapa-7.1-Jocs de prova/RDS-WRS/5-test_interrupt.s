.text
movi r0, 32
movi r1, 34
movi r2, -52
wrs s3, r1
wrs s6, r2
rds r5, s3
rds r6, s6
st 0(r0), r5
st 2(r0), r6
halt