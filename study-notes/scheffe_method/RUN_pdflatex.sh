#!/bin/bash

####################################################################################################
fileStem=scheffe-method-simultaneous-confidence-intervals

pdflatex ${fileStem}
bibtex   ${fileStem}
pdflatex ${fileStem}
pdflatex ${fileStem}

####################################################################################################

