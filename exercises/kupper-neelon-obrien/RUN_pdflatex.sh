#!/bin/bash

####################################################################################################
fileStem=kupper-neelon-obrien

pdflatex ${fileStem}
bibtex   ${fileStem}
pdflatex ${fileStem}
pdflatex ${fileStem}

####################################################################################################

