#!/usr/bin/perl
$latex = 'platex';
$pdflatex = 'platex';

# DVIからPDFに変換するための設定
$postscript_mode = 0;  # DVI -> PDF モードにする
$pdf_mode = 1;         # DVI -> PDF モードにする
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';

$bibtex = 'pbibtex';
$recorder = 1;