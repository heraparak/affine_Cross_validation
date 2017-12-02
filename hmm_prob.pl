$file=@ARGV[0];
#$file2=@ARGV[1];
#$file3=@ARGV[2];
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
$delta =0.2;
$eta=0.4;
#print($delta,$eta);
#defining traceback
@T;
$T[0][0]=0;
###Emission Probabilities###
$pgap=1;$pm=0.6;$pmm=1-$pm;
$tau=0;
###Transition Probabilities###
$BX=$delta;$BY=$delta;$BM=1-2*$delta-$tau;
$MX=$delta;$MY=$delta;$MM=1-2*$delta-$tau;
$XX=$eta;$XY=0;$XM=1-$eta-$tau;
$YY=$eta;$YX=0;$YM=1-$eta-$tau;
#print("$BX".$BX." $BM ".$BM."\n");

print(X);
###INitailze the first row and column of M,X,Y,B
$B[0][0]=1;
$B[0][1]=0;
$B[1][0]=0;

$M[0][0]=0;
$M[1][0]=0;
$M[0][1]=0;

$X[0][0]=0;
$X[0][1]=0;
$X[1][0]=$pgap*$BX*$B[0][0];

$Y[0][0]=0;
$Y[1][0]=0;
$Y[0][1]=$pgap*$BY*$B[0][0];

@f;
#######################################Forward Probability##################################
##Initialize begin state##
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
for($i=0;$i<=length($seq2);$i++)
{
$M[$i][0]=0;
}
for($i=0;$i<=length($seq1);$i++)
{
$M[0][$i]=0;
}

###Initialize X####
for($i=2;$i<=length($seq2);$i++)
{
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
#Recurrence
for (my $i=1; $i<=length($seq2); $i++)
{
for (my $j=1; $j<=length($seq1); $j++)
{
 	$letter_seq1 = substr($seq1,$j-1,1);
	$letter_seq2 = substr($seq2,$i-1,1);
	$p=0;$dm=0;$dy=0;$dx=0;$db=0;
	
	if ($letter_seq1 eq $letter_seq2)
	{
		$p=$pm;
	}
	else
	{	
		 $p=$pmm;
	}	
	$dm=$MM*$M[$i-1][$j-1];
	$dx=$XM*$X[$i-1][$j-1];
	$dy=$YM*$Y[$i-1][$j-1];
	$db=$BM*$B[$i-1][$j-1];
	$M[$i][$j]=$p*$dm+$p*$dx+$p*$dy+$p*$db;

#For X matrix
$um=$MX*$M[$i-1][$j];
$ux=$XX*$X[$i-1][$j]; 
$ub=$BX*$B[$i-1][$j];
$X[$i][$j]=$pgap*$um+$pgap*$ux+$pgap*$ub;

#For Y MATRIX
$lm=$MY*$M[$i][$j-1];
$ly=$YY*$Y[$i][$j-1]; 
$lb=$BY*$B[$i][$j-1];
$Y[$i][$j]=$pgap*$lm+$pgap*$ly+$pgap*$lb;

$f[$i][$j]=$M[$i][$j]+$X[$i][$j]+$Y[$i][$j];
print("Row value= ".$i."  "."column Value = ".$j."\n");
print("Forward Probability ".$f[$i][$j]."  "."\n");
print("M value =".$M[$i][$j]."\n");
print("X value =".$X[$i][$j]."\n");
print("Y value =".$Y[$i][$j]."\n");
}
}
@b;
#######################################Backward Probability##################################
$tau=0;
@B=();@X=();@Y=();@M=();

$x=length($seq2);
$y=length($seq1);

###Transition Probabilities###
$BX=$delta;$BY=$delta;$BM=1-2*$delta-$tau;
#$MB=1-2*$delta-$tau;$XB=$delta;$YB=$delta;
$XM=$delta;$YM=$delta;$MM=1-2*$delta-$tau;
$XX=$eta;$XY=0;$MX=1-$eta-$tau;
$YY=$eta;$YX=0;$MY=1-$eta-$tau;

###INitailze the first row and column of M,X,Y,B
$B[$x][$y]=1;
$B[$x][$y-1]=0;
$B[$x-1][$y]=0;

$M[$x][$y]=0;
$M[$x][$y-1]=0;
$M[$x-1][$y]=0;

$X[$x][$y]=0;
$X[$x][$y-1]=0;
$X[$x-1][$y]=$pgap*$BX*$B[$x][$y];

$Y[$x][$y]=0;
$Y[$x-1][$y]=0;
$Y[$x][$y-1]=$pgap*$BY*$B[$x][$y];
$T[$x][$y-1]='L';
$T[$x-1][$y]='U';

###Initialize X####
for($i=length($seq2)-2;$i>=0;$i--)
{
$M[$i][$y]=0;
$Y[$i][$y]=0;
$T[$i][$y]='U';
$X[$i][$y]=$pgap*$XX*$X[$i+1][$y];
}
for($i=length($seq1)-2;$i>=0;$i--)
{
$M[$x][$i]=0;
$X[$x][$i]=0;
$Y[$x][$i]=$pgap*$YY*$Y[$x][$i+1];
$T[$x][$i]='L';
}

################Recurrence
for($i=length($seq2)-1; $i>=0; $i--)
{
for ( $j=length($seq1)-1; $j>=0; $j--)
{
 	$letter_seq1 = substr($seq1,$j,1);
	$letter_seq2 = substr($seq2,$i,1);
	$p=0;$dm=0;$dy=0;$dx=0;$db=0;
	$um=0;$ux=0;$ub=0;
	$lm=0;$ly=0;$lb=0;
#	print($letter_seq1."   ".$letter_seq2);
	if ($letter_seq1 eq $letter_seq2)
	{
		$p=$pm;
	}
	else
	{	
		 $p=$pmm;
	}	
	$dm=$MM*$M[$i+1][$j+1];
	#print($M[$i+1][$j+1]." M value ","\n");
	$dx=$MX*$X[$i+1][$j+1];
	$dy=$YM*$Y[$i+1][$j+1];
	$db=$BM*$B[$i+1][$j+1];
	print($dm." ".$dx." ".$dy." ".$db."\n");

	$M[$i][$j]=$p*$dm+$p*$dx+$p*$dy+$p*$db;

#For X matrix
$um=$XM*$M[$i+1][$j];
$ux=$XX*$X[$i+1][$j]; 
$ub=$XB*$B[$i+1][$j];
$X[$i][$j]=$pgap*$um+$pgap*$ux+$pgap*$ub;

#For Y MATRIX
$lm=$MY*$M[$i][$j+1];
$ly=$YY*$Y[$i][$j+1]; 
$lb=$YB*$B[$i][$j+1];
$Y[$i][$j]=$pgap*$lm+$pgap*$ly+$pgap*$lb;

$b[$i][$j]=$M[$i][$j]+$X[$i][$j]+$Y[$i][$j];
print("Row value= ".$i."  "."column Value = ".$j."\n");
print("Backward Probability ".$b[$i][$j]."  "."\n");
print("M value =".$M[$i][$j]."\n");
print("X value =".$X[$i][$j]."\n");
print("Y value =".$Y[$i][$j]."\n");

}
}
for (my $i=1; $i<=length($seq2); $i++)
{
for (my $j=1; $j<=length($seq1); $j++)
{
$p[$i][$j]=($f[$i][$j]*$b[$i-1][$j-1])/$f[(length($seq2))][(length($seq1))];
}
}

print("The forward matrix "."\n");
for (my $i=1; $i<=length($seq2); $i++)
{
for (my $j=1; $j<=length($seq1); $j++)
{
print($f[$i][$j]."  ");
}
print("\n");
}

print("The backward matrix "."\n");
for (my $i=0; $i<length($seq2); $i++)
{
for (my $j=0; $j<length($seq1); $j++)
{
print($b[$i][$j]."  ");
}
print("\n");
}

print("The probability matrix "."\n");
for (my $i=1; $i<=length($seq2); $i++)
{
for (my $j=1; $j<=length($seq1); $j++)
{
print($p[$i][$j]."  ");
}
print("\n");
}


