# DLTG

Matlab implementation for the reconstruction of undersampled dynamic magnitude MR data using the algorithm presented in TMI 2014;33(4):979-994 [pdf]. The demo will restrospectively undersample a 32-coil recombined (no SENSE acceleration) cardiac cine dataset and reconstruct it with the proposed method.

_Note 1:_
The demo requires to download and install the packages KSVD-Box v13 and OMP-Box 10, which can be obtained from Ron Rubinstein's website.


_Note 2:_
There are two versions available. DLTG_v1 is an older version (October 2012) of the software which was used for the results in MICCAI 2012;1:256-263 [pdf]. The main difference with v2 is that v1 will only process magnitude real-valued data, but not complex-valued data.