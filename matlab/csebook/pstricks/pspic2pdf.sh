#!/bin/sh
# $Id: pspic2pdf.sh$
# Convert TEX -> DVI -> Ps -> PDF -> cropped-PDF -> EPS.
# usage:
# pspic2pdf <picture number> <tex file without .tex ext>

latex $2.tex 
dvips $2.dvi 
rm $2.dvi
rm $2.log
rm $2.aux
ps2pdf $2.ps 
rm $2.ps
pdfcrop $2.pdf
pdftops -f $1 -l $1 -eps "$2-crop.pdf" 
rm  "$2-crop.pdf"
rm $2.pdf
mv  "$2-crop.eps" $2.eps
