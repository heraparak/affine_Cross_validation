$true_file=shift;
$aligned_file=shift;
open(IN,$true_file);
open(FILE,$aligned_file);
@data=<IN>;
@data1=<FILE>;

chomp(@data);
$t_seq1 = $data[1];
$t_seq2 = $data[3];
#print($t_seq1."\n");
#print($t_seq2."\n");
chomp(@data1);
$c_seq1 = $data1[1];
$c_seq2 = $data1[3];
#print($c_seq1."\n");
#print($c_seq2."\n");

%t_hash=();
$pos1=1;
$pos2=1;

for ($i =0; $i<	length($t_seq1); $i++)
{
	$ch1=substr($t_seq1,$i,1);
	$ch2=substr($t_seq2,$i,1);

	if($ch1 ne "-" && $ch2 ne "-" && $ch1 =~ /[A-Z]/ && $ch2 =~ /[A-Z]/)
	{
		$t_hash{$pos1}=$pos2;
	}
	if(substr(t_seq1,$i,1) ne "-")
	{
		$pos1++;
	}
	if(substr(t_seq2,$i,1) ne "-")
	{
		$pos2++;
	}
}
@t_k = keys(%t_hash);
$den=scalar(@t_k);
$pos1=1;
$pos2=1;
for($i=0; $i < length($c_seq1); $i++)
{
	if(substr($c_seq1,$i,1) ne "-" && substr($C_seq2,$i,1) ne "-")
	{
		if($t_hash{$pos1} == $pos2)
		{
			$num++;
		}
	}
	if(substr($c_seq1,$i,1) ne "-")
	{
		$pos1++;
	}
	if(substr($c_seq2,$i,1) ne "-")
	{
		$pos2++;
	}

}
#print($num."\n");
#print($den."\n");
$accuracy=($num/$den);
print($accuracy."\n");

#for($i=0; $i<=$den; $i++)
#{
#	print($t_hash{$t_k[i]}."  ");
#}

#print("\n");

