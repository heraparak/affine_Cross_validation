$true_file=shift;
$aligned_file=shift;
open(IN,$true_file);
open(FILE,$aligned_file);
@data=<IN>;
@data1=<FILE>;

chomp(@data);
$t_seq1 = $data[1];
$t_seq2 = $data[3];
chomp($t_seq1);
chomp($t_seq2);

#print($t_seq1."\n");
#print($t_seq2."\n");
chomp(@data1);
$c_seq1 = $data1[1];
$c_seq2 = $data1[3];
chomp($c_seq1);
chomp($c_seq2);
#print($c_seq1."\n");
#print($c_seq2."\n");

%t_hash={};
$x=1;
$y=1;
for ($i =0; $i< length($t_seq1); $i++)
{
	$ch1=substr($t_seq1,$i,1);
	$ch2=substr($t_seq2,$i,1);
	if($ch1 ne "-" && $ch2 ne "-" && $ch1 =~ /[A-Z]/ && $ch2 =~ /[A-Z]/)
	{
		$t_hash{$x}=$y;
	}
	if(substr($t_seq1,$i,1) ne "-")
	{	
		$x++;
	}
	if(substr($t_seq2,$i,1) ne "-")
	{
		$y++;
		
	}
}
@t_k = keys(%t_hash);
foreach $key(keys %t_hash)
{
if(($t_hash{$key}) ne '')
{
$den += 1;
}
else 
{
delete($t_hash{$key});
}
}
$den1=scalar(@t_k);
$a=1;
$b=1;
for($i=0; $i < length($c_seq1); $i++)
{
	$c1=substr($c_seq1,$i,1);
	$c2=substr($c_seq2,$i,1);	
	if($c1 ne "-" && $c2 ne "-")
	{

		if($t_hash{$a} == $b)
		{
		$num++;
		}
	}

	if(substr($c_seq2,$i,1) ne "-")
	{
		$b++;
	}
	if(substr($c_seq1,$i,1) ne "-")
	{
		$a++;

	}
}
#print("num = ".$num."\n");
#print("DEN = ".$den."\n");
#print("DEN1 = ".$den1."\n");
$accuracy=($num/$den);
print($accuracy."\n");

#for($i=0; $i< scalar(@t_k); $i++)
#{
#	print($t_hash{$t_k[$i]}."  "."\n");
#}

