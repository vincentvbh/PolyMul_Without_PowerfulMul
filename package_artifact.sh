#!/bin/bash

rm -rf artifact
mkdir artifact
cp -r bench_core code_kem code_sign common examples gen_const_table img m3_util range avr.md cortex-m3.md LICENSE README.md setup_libopencm3_all.sh artifact/
cd artifact
find . -name 'Makefile' -execdir make clean \;
find . -name '.git*' -exec rm -rf {} \;
find . -name '__pycache__' -exec rm -rf {} \;
find . -name '.DS_Store' -exec rm -rf {} \;
find . -name 'libopencm3' -exec rm -rf {} \;
cd ../
rm -f artifact.zip
zip -r artifact.zip artifact

