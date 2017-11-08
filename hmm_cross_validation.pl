$training_file=shift;
open(IN,$training_file);
@aa=<IN>;
chomp(@aa);

$data_length=scalar @aa;
#print($data_length);
@delta=(.1,.15,.2,.25,.3,.35,.4,.45,.5);
@eta=(.2,.25,.3,.35,.4,.45,.5,.55,.6);
chomp(@ge);
chomp(@go);
$length_delta=scalar @delta;
$length_eta=scalar @eta;
$best_accuracy=-1;
%error={};
$error{$delta[0]}{$eta[0]}=0;
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


for($j=0; $j < $length_delta; $j++)
  {
	for ($k=0; $k < $length_eta; $k++)
		{	
		$d=$delta[$j];
		$e=$eta[$k];
		print("The eta value = ".$eta[$k]." The delta value is = ".$delta[$j]."\n");
			(qx(perl hmm1.pl $aa[$i] $d $e  > output.txt));
		
#opening of output text file into an array 		
		open(FILE,"<","output.txt");
		@output_data=<FILE>;
		chomp(@output_data);
		close(FILE);

$len=scalar @output_data;

#printing the NW_affine alignment output

#for ($a=0; $a<$len; $a++)
#	{ 		
#	 print($output_data[$a]."\n");		
#	}


#for calculating same seq from prefab file
$str=$aa[$i];
$index=index($str,'.unaligned');
$true_alignment_path=substr($str,0,$index);

#print($true_alignment_path."\n");
#with blossom aligned matrix
$accuracy_nw_affine1=qx(perl alignment_accuracy.pl  $true_alignment_path output.txt);

print("The Accuracy of sequence with blossom ".$true_alignment_path." is = ".$accuracy_nw_affine1." ");

$error{$delta[$j]}{$eta[$k]} = $error{$delta[$j]}{$eta[$k]} + $accuracy_nw_affine1;
print("the cumulative error ".$error{$delta[$j]}{$eta[$k]}."\n");
#Best alignment accuracy calculation

}

}
}
$max1=-1;
$max2=-1;
for($i=0; $i < $length_delta; $i++)
{
	for ($j=0; $j < $length_eta; $j++)
	{
		$delta_new=$delta[$i];
		$eta_new=$eta[$j];
#	print(" the error before averaging = ".$error{$delta_new}{$eta_new}."\n");
	$error{$delta_new}{$eta_new}= $error{$delta_new}{$eta_new}/$data_length;
#$data_length;
#	print("For delta value = ".$delta[$i]." and for eta value = ".$eta[$j]." the error is = ".$error{$delta_new}{$eta_new}."\n");
#	if($error{$delta_new}{$eta_new} > $max1)
#	{
#	 	$max1=$error{$delta_new}{$eta_new};
#		$best_delta=$delta_new;
#		$best_eta=$eta_new;
#	}	

}

} 
print("This represents the descending order of mean error of the delta-eta combinations"."\n");
foreach $keypair(
sort{$error{$b->[0]}{$b->[1]}<=>$error{$a->[0]}{$a->[1]}}
map{my $intkey=$_;map [$intkey,$_],keys %{$error{$intkey}}} 
keys %error
){
print("Delta value: ".$keypair->[0]." Eta value: ".$keypair->[1]." Respective mean error value is: ".$error{$keypair->[0]}{$keypair->[1]}."\n");
}
