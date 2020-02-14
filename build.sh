#!/bin/sh

set -e


echo "Generating Static fonts"

mkdir -p ./test/variable/
mkdir -p ./test/variable/static/
echo "Made font directories"

# fontmake -g source/manrope.glyphs -i --round-instances -o ttf --output-dir ./test/ttf/ 
# echo "Made ttfs"
echo "Generating Statics"
fontmake -g source/manrope.glyphs -o ttf --round-instances -a --keep-direction -i --output-dir ./test/variable/static/
echo "Made Statics"

echo "Generating VFs"
fontmake -g source/manrope.glyphs -o variable --output-path ./test/variable/Manrope\[wght\].ttf
echo "Made VF"

cd ./test/variable/

echo "adding dummy dsig"
gftools fix-dsig Manrope\[wght\].ttf --autofix
echo "dummy dsig added"

cd ..

cd ..

echo "Post processing"

vfs=$(ls ./test/variable/*.ttf)
for vf in $vfs
do
	gftools fix-dsig -f $vf;
	gftools fix-nonhinting $vf "$vf.fix";
	mv "$vf.fix" $vf;
	ttx -f -x "MVAR" $vf; # Drop MVAR. Table has issue in DW
	rtrip=$(basename -s .ttf $vf)
	new_file=./test/variable/$rtrip.ttx;
	rm $vf;
	ttx $new_file
	rm ./test/variable/*.ttx
done
rm ./test/variable/*backup*.ttf

echo "build complete zerg rush denied"



