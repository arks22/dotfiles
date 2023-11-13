#!/usr/bin/perl
$latex = 'platex';
$pdflatex = 'platex';

# DVIからPDFに変換するための設定
$postscript_mode = 0;  # DVI -> PDF モードにする
$pdf_mode = 1;         # DVI -> PDF モードにする
$dvipdf = 'dvipdfmx %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';

$bibtex = 'pbibtex';
#$pdf_update_method = 2;
#$pdf_previewer = "start mupdf %O %S";
#max_repeat       = 5;
# Prevent latexmk from removing PDF after typeset.
# $pvc_view_file_via_temporary = 0;
#   $pdf_previewer    = "open -ga /Applications/Skim.app";
