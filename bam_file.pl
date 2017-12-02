$file1=@ARGV[0];
$file2=@ARGV[1];
$file3=@ARGV[2];
$file4=@ARGV[3];
$file5=@ARGV[4];
$file6=@ARGV[5];

chomp($file1);
chomp($file2);
chomp($file3);
chomp($file4);
chomp($file5);
chomp($file6);
  

sub file_function
{
my ($file)=@_;


#print($file);
@col1=`cut -f 1 $file`;
@col2=`cut -f 2 $file`;
@col4=`cut -f 4 $file`;
@col6=`cut -f 6 $file`;
$row=length(@col1);
$col=scalar(@col1);
$count=$c=0;
for ($i=2;$i<$col;$i++)
{
if($col2[$i] != "4")
{
$c++;
chomp($col1[$i]);
chomp($col2[$i]);
chomp($col4[$i]);
chomp($col6[$i]);
#print($col[$i]);
$a=$col1[$i];
$len=length($a);
$index=index($col1[$i],':');
if($a=~(/\:(\d+)\:/))
{
$index2=$1;
}
print("Column 1= ".$a."  ".$index2." Column 4 = ".$col4[$i]."\n");
$difference=abs($col4[$i]-$index2);
print("the difference = ".$difference."\n");
$b=("Query ID ".$col1[$i])."   "."Bitwise Flag ".($col2[$i])."   "."POS ".($col4[$i])."   "."CIGAR ".($col6[$i]);
if($difference <= 100)
{
print($b."\n");
$count=$count+1;
}
}
}
#print("Function count :".$count."\n");
return $c,$count;
}

print("The alignement of read.01"."\n");
@c1=file_function($file1);
$total_count1=`wc -l $file1|cut -f 1 -d" "`;

print("The alignement of read.05"."\n");
@c2=file_function($file2);
$total_count2=`wc -l $file2|cut -f 1 -d" "`;

print("The alignement of read.1"."\n");
@c3=file_function($file3);
$total_count3=`wc -l $file3|cut -f 1 -d" "`;

print("The alignement of read.15"."\n");
@c4=file_function($file4);
$total_count4=`wc -l $file4|cut -f 1 -d" "`;

print("The alignement of read.2"."\n");
@c5=file_function($file5);
$total_count5=`wc -l $file5|cut -f 1 -d" "`;

print("The alignement data information of read.25"."\n");
@c6=file_function($file6);
$total_count6=`wc -l $file6|cut -f 1 -d" "`;

print("The alignement data information of read.01"."\n");
print("The correctly algined reads of  alignment ".$c1[1]."\n");
print("The algined reads of  alignment ".$c1[0]."\n");
print("The total number of alignment ".($total_count1-2)."\n");
print("\n");

print("The alignement data information of read.05"."\n");
print("The correctly algined reads of  alignment ".$c2[1]."\n");
print("The algined reads of  alignment ".$c2[0]."\n");
print("The total number of alignment ".($total_count2-2)."\n");
print("\n");

print("The alignement data information of read.1"."\n");
print("The correctly algined reads of  alignment ".$c3[1]."\n");
print("The algined reads of  alignment ".$c3[0]."\n");
print("The total number of alignment ".($total_count3-2)."\n");
print("\n");

print("The alignement data information of read.15"."\n");
print("The correctly algined reads of  alignment ".$c4[1]."\n");
print("The algined reads of  alignment ".$c4[0]."\n");
print("The total number of alignment ".($total_count4-2)."\n");
print("\n");

print("The alignement data information of read.2"."\n");
print("The correctly algined reads of  alignment ".$c5[1]."\n");
print("The algined reads of  alignment ".$c5[0]."\n");
print("The total number of alignment ".($total_count5-2)."\n");
print("\n");

print("The alignement data information of read.25"."\n");
print("The correctly algined reads of  alignment ".$c6[1]."\n");
print("The algined reads of  alignment ".$c6[0]."\n");
print("The total number of alignment ".($total_count6-2)."\n");

