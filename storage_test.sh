#!/bin/bash
location=$1

if [[ -z "$location" ]]; then
    echo "Usage example: storage_test.sh /test/directory/location"
    exit 0
fi

test_dir=${location}'/storage_test/'

if [[ -z "$location" ]]; then
    echo "Usage example: storage_test.sh /test/directory/location"
    exit 0
fi

echo "Test directory: ${test_dir}"

mkdir $test_dir

echo -n "Test 1:  write 10k files 1k byte: "
t1s=`date +%s`
for i in {1..10000}
do
    dd if=/dev/zero of=${test_dir}file_$i bs=1k count=1 &> /dev/null
done
sync; echo 3 > /proc/sys/vm/drop_caches
t1e=`date +%s`
let result=t1e-t1s
echo ${result}sec.

echo -n "Test 2:   read 10k files 1k byte: "
t2s=`date +%s`
for i in {1..10000}
do
    dd if=${test_dir}file_$i of=/dev/null bs=1k count=1 &> /dev/null
done
sync; echo 3 > /proc/sys/vm/drop_caches
t2e=`date +%s`
let result=t2e-t2s
echo ${result}sec.

echo -n "Test 3: delete 10k files 1k byte: "
t3s=`date +%s`
for i in {1..10000}
do
    rm ${test_dir}file_$i
done
sync; echo 3 > /proc/sys/vm/drop_caches
t3e=`date +%s`
let result=t3e-t3s
echo ${result}sec.

echo -n "Test 4:           write 10G file: "
t4s=`date +%s`
dd if=/dev/zero of=${test_dir}file bs=1M count=10000 &> /dev/null
sync; echo 3 > /proc/sys/vm/drop_caches
t4e=`date +%s`
let result=t4e-t4s
echo ${result}sec.

echo -n "Test 5:            read 10G file: "
t5s=`date +%s`
dd if=${test_dir}file of=/dev/null bs=1M count=10000 &> /dev/null
sync; echo 3 > /proc/sys/vm/drop_caches
t5e=`date +%s`
let result=t5e-t5s
echo ${result}sec.

echo -n "Test 6:          delete 10G file: "
t6s=`date +%s`
rm -rf ${test_dir}file
sync; echo 3 > /proc/sys/vm/drop_caches
t6e=`date +%s`
let result=t6e-t6s
echo ${result}sec.

echo "Deleting directory: ${test_dir}"
rm -rf $test_dir
