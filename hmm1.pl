$file=@ARGV[0];
$file2=@ARGV[1];
$file3=@ARGV[2];
open(FILE,$file);
@data = <FILE>;

chomp(@data);

$seq1 = $data[1];
$seq2 = $data[3];
chomp($seq1);
chomp($seq2);
#@score_matrix;
#$score_matrix[0][0] = 0;

#defining delta and eta
$delta =$file2;
$eta=$file3;
#print($delta,$eta);
#defining traceback
@T;
$T[0][0]=0;

###Transition Probabilities###
$BX=$delta;$BY=$delta;$BM=1-2*$delta;
$MX=$delta;$MY=$delta;$MM=1-2*$delta;
$XX=$eta;$XY=0;$XM=1-$eta;
$YY=$eta;$YX=0;$YM=1-$eta;
#print("$BX".$BX." $BM ".$BM."\n");
###Emission Probabilities###
$pgap=1;$pm=0.6;$pmm=1-$pm;

##Initialize begin state##
$B[0][0]=1;$B[0][1]=0;$B[1][0]=0;
for($i=1;$i<=length($seq2);$i++)
{
for($j=1;$j<=length($seq1);$j++)
{
$B[$i][$j]=0;
}
}
#print("The initialized B"."\n");
#printing(\@B,$seq1,$seq2);
###Initialize M####
$M[0][0]=0;
for($i=0;$i<=length($seq2);$i++)
{
$M[$i][0]=0;
}
for($i=0;$i<=length($seq1);$i++)
{
$M[0][$i]=0;
}

###Initialize X####
$X[0][0]=0;
$X[1][0]=$pgap*$BX*$B[0][0];
#print($X[1][0]."X value "."\n");
for($i=2;$i<=length($seq2);$i++)
{#print("The x values "."\n");
$X[$i][0]=$pgap*$XX*$X[$i-1][0];
#print($X[$i][0]."\n");
}
for($i=1;$i<=length($seq1);$i++)
{
$X[0][$i]=0;
}
#print("Initailized X"."\n");
#printing(\@X,$seq1,$seq2);
###Initialize Y####
$Y[0][0]=0;
$Y[0][1]=$pgap*$BY*$B[0][0];
for($i=1;$i<=length($seq2);$i++)
{
$Y[$i][0]=0;
}
for($i=2;$i<=length($seq1);$i++)
{
$Y[0][$i]=$pgap*$YY*$Y[0][$i-1];
}

###Initialize traceback###
for($i=1;$i<=length($seq2);$i++)
{
$T[$i][0]="U";
}
for($i=1;$i<=length($seq1);$i++)
{
$T[0][$i]="L";
}

#function for printing matrix
sub printing {
my ($ref,$s1,$s2)=@_;
my @matrix =@{$ref};
for(my $i=0;$i<=length($s2);$i++)
{
for(my $j=0;$j<=length($s1);$j++)
{
print($matrix[$i][$j]." ");
}
print("\n");
}
return;
}
#Recurrence
for (my $i=1; $i<=length($seq2); $i++)
{
for (my $j=1; $j<=length($seq1); $j++)
{
 	$letter_seq1 = substr($seq1,$i-1,1);
	$letter_seq2 = substr($seq2,$j-1,1);
	if ($letter_seq1 eq $letter_seq2)
	{
	  if(($MM*$M[$i-1][$j-1]>$XM*$X[$i-1][$j-1]) && ($MM*$M[$i-1][$j-1]>$YM*$Y[$i-1][$j-1]) &&($MM*$M[$i-1][$j-1]>$BM*$B[$i-1][$j-1]) )
		{			 $M[$i][$j]= $pm*($MM*$M[$i-1][$j-1]);
		}
	 elsif(($XM*$X[$i-1][$j-1]>$MM*$M[$i-1][$j-1]) && ($XM*$X[$i-1][$j-1]>$YM*$Y[$i-1][$j-1]) &&($XM*$X[$i-1][$j-1]>$BM*$B[$i-1][$j-1]) )
		{			 $M[$i][$j]= $pm*($XM*$X[$i-1][$j-1]);
		}
	elsif(($BM*$B[$i-1][$j-1]>$MM*$M[$i-1][$j-1]) && ($BM*$B[$i-1][$j-1]>$YM*$Y[$i-1][$j-1]) &&($BM*$B[$i-1][$j-1]>$XM*$X[$i-1][$j-1]) )
		{			 $M[$i][$j]= $pm*($BM*$B[$i-1][$j-1]);
		}
	else
		{			 $M[$i][$j]= $pm*($YM*$Y[$i-1][$j-1]);

		}
	}	
	else
	{
	  if(($MM*$M[$i-1][$j-1]>$XM*$X[$i-1][$j-1]) && ($MM*$M[$i-1][$j-1]>$YM*$Y[$i-1][$j-1]) &&($MM*$M[$i-1][$j-1]>$BM*$B[$i-1][$j-1]) )
		{			 $M[$i][$j]= $pmm*($MM*$M[$i-1][$j-1]);
		}
	 elsif(($XM*$X[$i-1][$j-1]>$MM*$M[$i-1][$j-1]) && ($XM*$X[$i-1][$j-1]>$YM*$Y[$i-1][$j-1]) &&($XM*$X[$i-1][$j-1]>$BM*$B[$i-1][$j-1]) )
		{			 $M[$i][$j]= $pmm*($XM*$X[$i-1][$j-1]);
		}
	elsif(($BM*$B[$i-1][$j-1]>$MM*$M[$i-1][$j-1]) && ($BM*$B[$i-1][$j-1]>$YM*$Y[$i-1][$j-1]) &&($BM*$B[$i-1][$j-1]>$XM*$X[$i-1][$j-1]) )
		{			 $M[$i][$j]= $pmm*($BM*$B[$i-1][$j-1]);
		}
	else
		{			 $M[$i][$j]= $pmm*($YM*$Y[$i-1][$j-1]);

		}
	}	


#For X matrix
if(($MX*$M[$i-1][$j]>$XX*$X[$i-1][$j]) &&($MX*$M[$i-1][$j]>$BX*$B[$i-1][$j]) )
{
$X[$i][$j]=$pgap*($MX*$M[$i-1][$j]);
}
elsif(($XX*$X[$i-1][$j]>$MX*$M[$i-1][$j]) &&($XX*$X[$i-1][$j]>$BX*$B[$i-1][$j]) )
{
$X[$i][$j]=$pgap*($XX*$X[$i-1][$j]);
}
else
{
$X[$i][$j]=$pgap*($BX*$B[$i-1][$j]);
}

#For Y MATRIX
if(($MY*$M[$i][$j-1]>$YY*$Y[$i][$j-1]) &&($MY*$M[$i][$j-1]>$BY*$B[$i][$j-1]) )
{
$Y[$i][$j]=$pgap*($MY*$M[$i][$j-1]);
}
elsif(($YY*$Y[$i][$j-1]>$MY*$M[$i][$j-1]) &&($YY*$Y[$i][$j-1]>$BY*$B[$i][$j-1]) )
{
$Y[$i][$j]=$pgap*($YY*$Y[$i][$j-1]);
}
else
{
$Y[$i][$j]=$pgap*($BY*$B[$i][$j-1]);
}




##Maximum value selection
	if($M[$i][$j]>= $X[$i][$j] && $M[$i][$j] >= $Y[$i][$j])
		{ 
#		$score_matrix[$i][$j] = $M[$i][$j];
		$T[$i][$j] = "D";
		}
	elsif($X[$i][$j] >= $M[$i][$j] && $X[$i][$j] >= $Y[$i][$j])
		{
#		$score_matrix[$i][$j] = $X[$i][$j];
		$T[$i][$j] = "U";
		}
	else{
#	$score_matrix[$i][$j] = $Y[$i][$j];
		$T[$i][$j] = "L";
		}

}
}
#for ($i=0;$i<=length($seq1);$i++)
#{
#for ($j=0;$j<=length($seq2);$j++)
#{
#print($score_matrix[$i][$j]." ");
#}
#print("\n");
#}
##Traceback
$aligned_seq1="";
$aligned_seq2="";
$i=length($seq2);
$j=length($seq1);
while ($i != 0 || $j != 0)
{
#print("The j and I values".$j." ".$i."\n");
 if($T[$i][$j] eq "L")
	{	
	 $aligned_seq2="-".$aligned_seq2;
	 $aligned_seq1=substr($seq1,$j-1,1).$aligned_seq1;
	 $j=$j-1;
	}
elsif($T[$i][$j] eq "U")
 {
	$aligned_seq1="-".$aligned_seq1;
	$aligned_seq2=substr($seq2,$i-1,1).$aligned_seq2;
   	$i=$i-1;
  }
else
 { 
   $aligned_seq1=substr($seq1,$j-1,1).$aligned_seq1;
   $aligned_seq2=substr($seq2,$i-1,1).$aligned_seq2;
   $i=$i-1;
   $j=$j-1;
 }
}
#print("the matrix M"."\n");
#printing(\@M,$seq1,$seq2);
#print("the matrix X"."\n");
#printing(\@X,$seq1,$seq2);
#print("the matrix Y"."\n");
#printing(\@Y,$seq1,$seq2);
#print("the matrix V"."\n");
#printing(\@score_matrix,$seq1,$seq2);
#print("the matrix T"."\n");
#printing(\@T,$seq1,$seq2);


$l1=length($seq1);
$l2=length($seq2);
print("The aligned sequence 1 is "."\n");
print($aligned_seq1."\n");
print("The aligned sequence 2 is "."\n");
print($aligned_seq2."\n");
#print("The score of the alignemnt"."\n");
#print($score_matrix[$l1][$l2]."\n");

