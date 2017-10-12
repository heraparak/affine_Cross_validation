$file=$ARGV[0];
$file2=$ARGV[1];
$file3=$ARGV[2];

open(FILE,$file);


@data = <FILE>;
$go = $file2;
$ge =$file3;

$gap_extension=$ge;
$gap=$go;

chomp(@data);

$seq1 = $data[1];
$seq2 = $data[3];
$aligned_seq1="";
$aligned_seq2="";
chomp($seq1);
chomp($seq2);
@score_matrix;#V matrix
$score_matrix[0][0] = 0;
@M;@E;@F;
$M[0][0] = 0;
$E[0][0] = $F[0][0] = -Inf;
$match = 5;
$mismatch = -4;
#$gap = -26;
@T;
$T[0][0]=0;
##INITIALIZATION
for (my $i=1; $i <= length($seq1); $i++)
{
$score_matrix[$i][0]  += $gap + ($i-1)*$gap_extension;
$E[$i][0] = -Inf;
$F[$i][0] += $gap + ($i-1)*$gap_extension;
$M[$i][0] = -Inf;
$T[$i][0] = "U";
}
for (my $i=1; $i <= length($seq2); $i++)
{
$score_matrix[0][$i] +=  $gap + ($i-1)*$gap_extension;
$E[0][$i] += $gap + ($i-1)*$gap_extension;
$F[0][$i] = -Inf;
$M[0][$i] = -Inf;
$T[0][$i] = "L";
}

##Recurrence
for (my $i=1; $i<=length($seq1); $i++)
{
for (my $j=1; $j<=length($seq2); $j++)
{ 	$letter_seq1 = substr($seq1,$i-1,1);
	$letter_seq2 = substr($seq2,$j-1,1);
#calculatin the M matrix
	if($letter_seq1 eq $letter_seq2)
	{
	   if($M[$i-1][$j-1] >= $F[$i-1][$j-1] && $M[$i-1][$j-1] >= $E[$i-1][$j-1])
		{ 
		     $M[$i][$j] += $M[$i-1][$j-1] + $match;		
		}
	   elsif($F[$i-1][$j-1]>= $M[$i-1][$j-1] && $F[$i-1][$j-1] >= $E[$i-1][$j-1])
               {	
	        	$M[$i][$j] +=$ F[$i-1][$j-1]+ $match;
	       }
	   else
	      {
		$M[$i][$j] += $E[$i-1][$j-1] + $match;
	      }
	}
	else			
	{
	    if($M[$i-1][$j-1] > $E[$i-1][$j-1] && $M[$i-1][$j-1] > $F[$i-1][$j-1])
		{
			$M[$i][$j] += $M[$i-1][$j-1] + $mismatch;
		
		}
	    elsif($E[$i-1][$j-1] > $F[$i-1][$j-1] && $E[$i-1][$j-1] > $M[$i-1][$j-1])
		{
			#$max = $E[$i-1][$j-1];
			$M[$i][$j] += $E[$i-1][$j] + $mismatch; 
			#print("max value in elsif".$max."\n");
		}
	    else
		{
			$M[$i][$j] += $F[$i-1][$j-1] + $mismatch;
		
		} 
	}
#calculating the F matrix value 																																									
	if($M[$i-1][$j]+$gap > $F[$i-1][$j]+$gap_extension)
	{
		$F[$i][$j] += $M[$i-1][$j]  + $gap;
	}
	else
	{
		$F[$i][$j] += $F[$i-1][$j] + $gap_extension;
	}
#calculating the E matrix
	if($M[$i][$j-1]+$gap > $E[$i][$j-1]+$gap_extension)
	{
		$E[$i][$j] += $M[$i][$j-1] + $gap;
	}
	else
	{
 
		$E[$i][$j] += $E[$i][$j-1] + $gap_extension;
	}
		
#print("M = ".$M[$i][$j]."\n");
#print("E = ".$E[$i][$j]."\n");
#print("F = ".$F[$i][$j]."\n");

##Maximum value selection
if($M[$i][$j] >= $E[$i][$j] && $M[$i][$j] >= $F[$i][$j])
	{
		$score_matrix[$i][$j] += $M[$i][$j];
		$T[$i][$j] = "D";
	}
elsif($F[$i][$j] >= $M[$i][$j] && $F[$i][$j] >= $E[$i][$j])
	{
		$score_matrix[$i][$j] += $F[$i][$j];
		$T[$i][$j] = "U";
	}
else 
	{
		$score_matrix[$i][$j] += $E[$i][$j];
		$T[$i][$j] = "L";
	}

}
}
$L1=length($seq1);
$L2=length($seq2);
#print("length 1= ".$L1."  length of seq2 ".$L2."\n");
#print("The sequence 1  :- ".$seq1."\n");
#print("The sequence 2  :- ".$seq2."\n");
#for ($i=0; $i<=length($seq2); $i++)
#{
#for ($j=0; $j<=length($seq1); $j++)
#{ 
#print($score_matrix[$i][$j]."  ");
#}
#print("\n");
#}

#print("The Traceback matirx"."\n");
#for ($i=0; $i<=length($seq2); $i++)
#{
#for ($j=0; $j<=length($seq1); $j++)
#{
#print($T[$i][$j]);
#}
#print("\n");
#}
##Traceback
$aligned_seq1="";
$aligned_seq2="";
$i=length($seq1);
$j=length($seq2);
while ($i != 0 || $j != 0)
{
 if ($T[$i][$j] eq "L")
	{
	 $aligned_seq1="-".$aligned_seq1;
	 $aligned_seq2=substr($seq2,$j-1,1).$aligned_seq2;
	 $j =$j-1;
	}
elsif ($T[$i][$j] eq "U")
 {
   $aligned_seq2="-".$aligned_seq2;
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
print("The aligned seq 1"."\n");
print($aligned_seq1."\n");
print("The aligned seq 2"."\n");
print($aligned_seq2."\n");
print("the score of the alignment"."\n");
print($score_matrix[$L1][$L2]."\n");

