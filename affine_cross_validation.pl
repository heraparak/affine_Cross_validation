$training_file=shift;
open(IN,$training_file);
@aa=<IN>;
chomp(@aa);

$data_length=scalar @aa;
#print($data_length);
@ge=(-2,-1,-.5,-.1);
@go=(-16,-14,-12,-10,-8,-6,-4,-2);
chomp(@ge);
chomp(@go);
$length_ge=scalar @ge;
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


for($j=0; $j < $length_go; $j++)
  {
	for ($k=0; $k < $length_ge; $k++)
		{	
		$gap=$go[$j];
		$gap_extension=$ge[$k];
		print("The gap_extension value = ".$ge[$k]."The gap open value is = ".$go[$j]."\n");
		#system("perl affine_modified.pl $aa[$i] $gap $gap_extension");
		(qx(perl affine_modified.pl $aa[$i] $gap $gap_extension  > output.txt));
		
#opening of output text file into an array 		
		open(FILE,"<","output.txt");
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

$accuracy_nw_affine=qx(perl alignment_accuracy.pl $true_alignment_path output.txt);

print("The Accuracy of sequence ".$true_alignment_path." is = ".$accuracy_nw_affine."\n");

$error{$go[$j]}{$ge[$k]}+=$accuracy_nw_affine;

#Best alignment accuracy calculation
$current_accuracy=$accuracy_nw_affine;
if ($current_accuracy >= $best_accuracy)
{
		$best_accuracy = $current_accuracy ;
		$gap_extension = $ge[$k];
		$gap_open = $go[$j];
}
	

}

}
}

for($i=0; $i < $length_go; $i++)
{
	for ($j=0; $j < $length_ge; $j++)
	{
		$gap=$go[$i];
		$gap_ext=$ge[$j];
	$error{$gap}{$gap_ext}= $error{$gap}{$gap_ext}/$data_length;
print(" For gap open = ".$go[$i]." and for gap extension = ".$ge[$j]." the error is = ".$error{$gap}{$gap_ext}."\n");
}
} 

print("The best alignment is as follows"."\n");
print("The gap extension :-".$gap_extension."\n");
print("The gap open :- ".$gap_open."\n");
