# Toolbox BASH

Collections of different small BASH scripts or scripts examples.

## rsync_with_email.sh

Script syncs 2 locations. It writes full log and sends short report by email.

Usage:
```bash
chmod +x rsync_with_email.sh
mkdir /tmp2
./rsync_with_email.sh '/tmp/' '/tmp2/' 'my_log_file' my@example.com
```


Report example:
```bash
# cat /var/log/rsync_my_log_file_status.log
Start time:  2015-11-12 16:37:54

Hostname:    test-srv
Source:      /tmp/
Destination: /tmp2/

Time output:

real	0m0.051s
user	0m0.007s
sys	0m0.001s

Finish time: 2015-11-12 16:37:54

Status: OK successful, exit code = 0

Full log:  test-srv   /var/log/rsync_my_log_file_full.log

```

## duplicate_finder.sh

Script looking for duplicates by name and MD5sum. Then it measures size and sends report by email. Script will create 12 list files and 1 report file in current working directory.

Usage:
```bash
chmod +x duplicate_finder.sh
./duplicate_finder.sh /data/
```

report.txt
```
Start time:                   2015-11-12 17-51-24
Total size of all duplicates: 2.52006 GB
Unique duplicates size:       1.20709 GB
Total size of all files:      169.475 GB
End time:                     2015-11-12 18-10-00
```

Duplicated you can find in file list8.txt.

Format: MD5sum_hash;File_Name;Full_Path
```bash
. . .
6de2072a26d020150cdee0bb183fe649;chunk.py;/data/lib/python2.7/chunk.py
6de2072a26d020150cdee0bb183fe649;chunk.py;/data/pkgs/python-2.7.8-1/lib/python2.7/chunk.py
6de2072a26d020150cdee0bb183fe649;chunk.py;/data/python/lib/python2.7/chunk.py
6de2072a26d020150cdee0bb183fe649;chunk.py;/data/gitdemo2/python/Lib/chunk.py
. . .
```


## date_manipulation.sh

Example script to manipulate dates in BASH. Script will take last line from file and will try to modify date.

It expects log lines like:

```bash
Nov 12 15:17:01 test-srv ........
```

Usage:

```bash
chmod +x date_manipulation.sh
./date_manipulation.sh /var/log/syslog
```

Output example:

```bash
### Start ###
String from log file:     Nov 12 15:17:01
Date from log in seconds: 1447337821
Date_time now in seconds: 1447338456
It happend:               635 seconds ago
It happend:               10 minutes ago
### End ###
```
## du_mail.sh

Measures size of hidden and not hidden files in given directory. It sorts by size and sends by email.

Usage:
```bash
chmod +x du_mail.sh
./du_mail.sh /home/test/
```

Email:
```bash
169G	total
94G		/home/test/VirtualBox VMs
6,8M	/home/test/.eclipse
5,8M	/home/test/.java
140K	/home/test/.gconf
. . .
```

## ftp_upload_file.sh

Example script to upload or replace file on FTP server.

## storage_test.sh

Simple storage test with dd and drop_caches.

Usage:
```bash
chmod +x storage_test.sh
./storage_test.sh /test/directory/location
```

Output example:
```
# ./storage_test.sh /
Test directory: //storage_test/
Test 1:  write 10k files 1k byte: 12sec.
Test 2:   read 10k files 1k byte: 11sec.
Test 3: delete 10k files 1k byte: 9sec.
Test 4:           write 10G file: 110sec.
Test 5:            read 10G file: 30sec.
Test 6:          delete 10G file: 1sec.
Deleting directory: //storage_test/
```
