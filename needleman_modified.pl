$file=@ARGV[0];
$file2=@ARGV[1];

open(FILE,$file);
@data = <FILE>;

chomp(@data);

$seq1 = $data[1];
$seq2 = $data[3];
chomp($seq1);
chomp($seq2);
@score_matrix;
$score_matrix[0][0] = 0;
$match = 5;
$mismatch = -4;
$gap =$file2;
@T;
$T[0][0]=0;
##INITIALIZATION
for (my $i=1; $i <= length($seq1); $i++)
{
$score_matrix[$i][0]  +=  $i * $gap;
$T[$i][0] = "U";
}
for (my $i=1; $i <= length($seq2); $i++)
{
$score_matrix[0][$i] +=  ($i * $gap);
$T[0][$i] = "L";
}
print("Needleman_affine_modified"."\n");
##Recurrence
for (my $i=1; $i<=length($seq1); $i++)
{
for (my $j=1; $j<=length($seq2); $j++)
{
 	$letter_seq1 = substr($seq1,$i-1,1);
	$letter_seq2 = substr($seq2,$j-1,1);
	$diagonal_score,$top_score,$left_score = 0;
	if ($letter_seq1 eq $letter_seq2)
	{
	$diagonal_score = $score_matrix[$i-1][$j-1] + $match;
	}
	else
	{
	    $diagonal_score = $score_matrix[$i-1][$j-1] + $mismatch;
	}
	$top_score =  $score_matrix[$i-1][$j] + $gap;
	$left_score = $score_matrix[$i][$j-1] + $gap;

##Maximum value selection
	if($diagonal_score >= $top_score && $diagonal_score >= $left_score)
		{ 
		$score_matrix[$i][$j] = $diagonal_score;
		$T[$i][$j] = "D";
		}
	elsif($top_score >= $diagonal_score && $topscore >= $left_score)
		{
		$score_matrix[$i][$j] = $top_score;
		$T[$i][$j] = "U";
		}
	else{
	$score_matrix[$i][$j] = $left_score;
		$T[$i][$j] = "L";
		}

}
}

##Traceback
$aligned_seq1="";
$aligned_seq2="";
$i=length($seq1);
$j=length($seq2);
while ($i != 0 || $j != 0)
{
#print("The j and I values".$j." ".$i."\n");
 if($T[$i][$j] eq "L")
	{	
	 $aligned_seq1="-".$aligned_seq1;
	 $aligned_seq2=substr($seq2,$j-1,1).$aligned_seq2;
	 $j=$j-1;
	}
elsif($T[$i][$j] eq "U")
 {
	$aligned_seq1=substr($seq1,$i-1,1).$aligned_seq1;
   	$i=$i-1;
  }
else
 { 
   $aligned_seq1=substr($seq1,$i-1,1).$aligned_seq1;
   $aligned_seq2=substr($seq2,$j-1,1).$aligned_seq2;
   $i=$i-1;
   $j=$j-1;
 }
}
$l1=length($seq1);
$l2=length($seq2);
print("The aligned sequence 1 is "."\n");
print($aligned_seq1."\n");
print("The aligned sequence 2 is "."\n");
print($aligned_seq2."\n");
print("The score of the alignemnt"."\n");
print($score_matrix[$l1][$l2]."\n");

