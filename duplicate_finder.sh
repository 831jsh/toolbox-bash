#!/bin/bash
# Fide duplicates and measure size then send by email.
echo "Start time:                   `date +"%Y-%m-%d %H-%M-%S"`" > ./report.txt
# Find files
find $1 -not -empty -type f -printf "%p\n" > list1.txt
# List only names
cat list1.txt | xargs -I{} basename {} > list2.txt
# Get list of uniq names
cat list2.txt | sort | uniq -d > list3.txt
# Create sorted list of similar files grouped by similar name
while read file_name;
do
    grep "/${file_name}$" list1.txt;
done < list3.txt > list4.txt
# Create list of files with MD5sums
cat list4.txt | xargs -I{} md5sum {} > list5.txt
# Create new list before compare
while read line;
do
    md5sum_hash="`echo $line | awk '{print $1}'`";
    file_path="`echo $line | cut -c34-`";
    base_name="`echo $line | xargs -I{} basename {}`";
    echo "${md5sum_hash};${base_name};${file_path}";
done < list5.txt > list6.txt
# Create sorted list
sort -t ';' -k 2,2 -k 1,1 list6.txt > list7.txt

cat list7.txt | uniq -w32 --all-repeated=separate > list8.txt

cat list8.txt | grep -v "^$" | cut -d ";" -f 3- | xargs -I{} stat --format=%s\|%n {} > list9.txt
# Creating report file
echo -n 'Total size of all duplicates: ' >> ./report.txt
awk -F '|' '{ sum+=$1} END {print sum}' list9.txt | awk '{print $1/1024/1024/1024,"GB"}' >> ./report.txt

cat list8.txt | grep -v "^$" | uniq -w32 > list10.txt
cat list10.txt | grep -v "^$" | cut -d ";" -f 3- | tr '\n' '\0' | xargs -0 stat --format=%s\|%n  > list11.txt

echo -n 'Unique duplicates size:       ' >> ./report.txt
awk -F '|' '{ sum+=$1} END {print sum}' list11.txt | awk '{print $1/1024/1024/1024,"GB"}' >> ./report.txt

cat list1.txt | tr '\n' '\0' | xargs -0 stat --format=%s\|%n > list12.txt

echo -n 'Total size of all files:      ' >> ./report.txt
awk -F '|' '{ sum+=$1} END {print sum}' list12.txt | awk '{print $1/1024/1024/1024,"GB"}' >> ./report.txt

echo "End time:                     `date +"%Y-%m-%d %H-%M-%S"`" >> ./report.txt
# Send email
cat ./report.txt | mail -s "Duplicates in $1" my@example.com
