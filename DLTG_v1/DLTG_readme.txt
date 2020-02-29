Jose Caballero

Biomedical and Image Analysis Group
Department of Computing
Imperial College London, London SW7 2AZ, UK
E: jose.caballero06@imperial.ac.uk
W: http://www.doc.ic.ac.uk/~jc1006

Please report any bugs or problems.

October 2012

------------------------
DLTG code guide
------------------------

How to run the example provided
	1) Include in the Matlab path the DLTG demo directory with all subdirectories.

	2) Make sure the ksvdbox13 and ompbox10 packages are also in the directory and correctly installed.
		* If after installing ksvdbox13 and ompbox10 using the instructions provided therein Matlab is unable to locate and use the function reggrid.m, try changing the name of folders private to something different (eg. private_f) and include them in the Matlab path.

	3) Run command main

Comments:
The code as it stands is suboptimal but is adapted so that it delivers a decent result in a reasonable time. For better (but slower) results change the code in DLTG.m such that params.epsilon is set fixed and small. The parameter lambda can also be made smaller for a better reconstruction.

Useful functions in analysis_functions:
	- PlaySeq(seq): Plays the sequence seq as a video. To stop use force stop (cmd+. or ctrl+c)
	- PlaySeqError(seq1, seq2): Compares visually videos from seq1 and seq2. Useful to compare the original seq 	with a given reconstruction like seq_zf or seq_dltg.
	- Profile(seq, row): Displays the profile through time a given row from sequence seq.
	- ProfileError(seq1, seq2, row): Compares the profiles of seq1 and seq2. Useful to compare profiles 	from the DLTG result with the zf result and the original seq.
	
