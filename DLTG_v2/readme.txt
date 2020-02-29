Jose Caballero

Biomedical and Image Analysis Group
Department of Computing
Imperial College London
London SW7 2AZ, UK

E: jose.caballero06@imperial.ac.uk
W: http://www.doc.ic.ac.uk/~jc1006

Please report any bugs or problems.

May 2014

------------------------
DLTG v2.0 code guide
------------------------

Running the demo:
	
    1) Make sure the ksvdbox13 and ompbox10 (http://www.cs.technion.ac.il/~ronrubin/software.html) packages are correctly installed and in the directory.
		* If after installing ksvdbox13 and ompbox10 using the instructions provided therein Matlab is unable to locate and use the function reggrid.m, try changing the name of folders private to something different (eg. private_f) and include them in the Matlab path.
	
    2) Include in the Matlab path the DLTG demo directory with all subdirectories.

	3) Run command main or main_fast.

Comments:
The script main_fast.m is provided for quick prototyping and experiments. The script main.m will run a complete simulation with a better parameter choice, but will take long to converge. Please see TMI paper for details on convergence speed.
To use data of different dimensions, make sure to precompute matrices D and Dt using function genD.m and store them.

Useful functions in analysis_functions:
	- playSeq(seq): Plays the sequence seq as a video. To stop use force stop (cmd+. or ctrl+c)
	- playSeqError(seq1, seq2): Compares visually videos from seq1 and seq2. Useful to compare the original seq 	with a given reconstruction like seq_zf or seq_dltg.
	- profile(seq, row): Displays the profile through time a given row from sequence seq.
	- profileError(seq1, seq2, row): Compares the profiles of seq1 and seq2. Useful to compare profiles 	from the DLTG result with the zf result and the original seq.
	
