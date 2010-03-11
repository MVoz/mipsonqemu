#! /bin/sh
i=0
j=0
m=0
n=0
total=8;
root='tmpsnapshot'
rm -fr $root
mkdir $root
cd $root
for((i=0;i<total;i++))
do
    mkdir $i
    cd $i
	for((j=0;j<total;j++))
	do
		    mkdir $j
		    cd $j
			for((m=0;m<total;m++))
			do
				    mkdir $m
				    cd $m
					for((n=0;n<total;n++))
					do
						 mkdir $n
					done
				     cd .. 				
			done
		     cd .. 
	done
     cd .. 
done