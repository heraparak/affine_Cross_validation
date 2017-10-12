$training_file=shift;
open(IN,$training_file);
@aa=<IN>;
chomp(@aa);

$data_length=scalar @aa;
print($data_length);

@go=(-16,-14,-12,-10,-8,-6,-4,-2);###pick the best number if possible
chomp(@ge);
chomp(@go);
$length_go=scalar @go;
$best_accuracy=-1;
%error={};
$s=0;
$n=0;

for ($i=0; $i< $data_length; $i++)
{	
chomp($aa[$i]);
#opening the amino acids in the file
open(my $handle,$aa[$i]);
chomp(my @lines=<$handle>);
	$t_seq1=$lines[1];
	$t_seq2=$lines[3];
	close $handle;
print("the sequence input from Affine_NW_cross_validation"."\n");
print("The sequence 1 ".$t_seq1."\n");
print("The sequence 2 ".$t_seq2."\n");

for($j=0; $j < $length_go; $j++)
  {
		$gap=$go[$j];

		print("The gap open value is = ".$go[$j]."\n");
#		system("perl affine_modified.pl $aa[$i] $gap");
		(qx(perl needleman_modified.pl $aa[$i] $gap > output_nw.txt));
		
#opening of output text file into an array 		
		open(FILE,"<","output_nw.txt");
		@output_data=<FILE>;
		chomp(@output_data);
		close(FILE);

$len=scalar @output_data;

#printing the NW_affine alignment output
for ($a=0; $a<$len; $a++)
	{ 		
	 print($output_data[$a]."\n");		
	}

$n++;
#for calculating same seq from prefab file
$str=$aa[$i];
$index=index($str,'.unaligned');
$true_alignment_path=substr($str,0,$index);

#print($true_alignment_path."\n");

$accuracy_nw_affine=qx(perl alignment_accuracy.pl $true_alignment_path output_nw.txt);

print("The Accuracy of sequence ".$true_alignment_path." is = ".$accuracy_nw_affine."\n");

$error{$gap}+=$accuracy_nw_affine;
$s+= $accuracy_nw_affine;
#Best alignment accuracy calculation
$current_accuracy=$accuracy_nw_affine;
if ($current_accuracy >= $best_accuracy)
{
		$best_accuracy = $current_accuracy ;
		$gap_open = $go[$j];
}
	

}


}
$sum=0;
$mn=0;
#Average gap theory
for($i=0;$i< scalar(@go); $i++)
{	
	$g=$go[$i];

	$error{$g} +=$error{$g}/$data_length ;
	print("For gap = ".$g." The error is  =".$error{$g}."\n");

} 

print("The best alignment is as follows"."\n");

print("The gap open :- ".$gap_open."\n");
print("The best accuracy is :- ".$best_accuracy."\n");
print("The average of error  is :- ".$s/$n."\n");
print($n."\n");
print($mn."\n");

