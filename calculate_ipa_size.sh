#!/bin/bash

exe_compression=${2:-100}


echo "Calculating likely maximum size op IPA: $1";
rm -r .IPASIZECALC;
mkdir .IPASIZECALC > /dev/null;
unzip $1 -d .IPASIZECALC > /dev/null;

# check how many exe's we got, we can only handle 1
exe_count=$(ls -l .IPASIZECALC/Payload/cityisland4.app | grep -c '\-rwxr\-xr\-x');

if [ "$exe_count" -ne "1" ]; then
	echo "Can only handle one executable in the IPA at the moment, ask Yuri to update this script. Count: $exe_count"; 
	exit;
fi

# Calculating uncompressable part
exe_name=$(ls -l .IPASIZECALC/Payload/cityisland4.app | grep '\-rwxr\-xr\-x' | awk 'NF{print $NF; exit}');
exe_size=$(ls -l .IPASIZECALC/Payload/cityisland4.app/$exe_name | awk 'NF { print $5; exit}');
exe_size=$(( $exe_size * $exe_compression / 100 ));
echo -e "Executable '$exe_name' size with $(($exe_compression))% uncompressable:\t$(($exe_size / 1000)) KB";

rm .IPASIZECALC/Payload/cityisland4.app/$exe_name;

# Calculating compressable part
zip -r .IPASIZECALC/Payload .IPASIZECALC > /dev/null;
compressable_size=$(ls -l .IPASIZECALC/Payload.zip | awk 'NF { print $5; exit}');
echo -e "Compressable size:\t\t$(($compressable_size / 1000)) KB";

# Calculating total maximum size
max_size=$(( $exe_size + $compressable_size + 100000 ));
max_size=$(( $max_size / 1000 ));
echo -e "Maximum size:\t\t\t$max_size KB";