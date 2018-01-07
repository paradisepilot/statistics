
californiaAna44
===============
-  californiaAna44 is a simple implementation of a generic supervised machine learning workflow.
-  It is designed to be a workflow template executable on Network A.
-  Its goal is to serve as a viable starting point for Statistics Canada colleagues who wish
   to experiment with Python-based machine learning tools or to prototype Python-based machine
   learning solutions.
-  californiaAna44 contains a single master program called MASTER.py, which in turn executes code
   contained in a collection of supporting Python modules. Execution of MASTER.py executes an
   entire generic regression (supervised machine learning with continuous response variable)
   workflow on a small embedded publicly downloadable data set.
   The workflow is composed of the following steps: visualization, preprocessing, training
   (including hyperparameter tuning via cross validation where applicable) and testing.
-  The workflow implemented in californiaAna44 is based on Chapter 2 of the following book:

   Aurélien Géron, Hands-On Machine Learning with Scikit-Learn & TensorFlow, O'Reilly, March 2017

-  The embedded data set can also be downloaded from either of the following two web sites:

   1)  https://github.com/ageron/handson-ml/tree/master/datasets/housing
   2)  https://www.kaggle.com/camnugent/california-housing-prices

Author
======
Kenneth Chu, Statistics Canada (kenneth.chu@canada.ca)

Release Date
=============
March 31, 2018

Software requirements
=====================
-  californiaAna44 is tested for Anaconda 4.4/Python 2.7.
-  Anaconda is one of the most widely used Python-based data science platforms.
   For more information about Anaconda, visit: https://www.anaconda.com/
-  Anaconda has been approved as part of the Methodologist's standard toolbox.
   If you are a methodologist, simply send an SRM to request installation of Anaconda on your
   workstation.
-  Note that the current default version of Anaconda may be different from the one cited above.
-  Anaconda contains an embedded distribution of Python. In particular, only installation of
   Anaconda is required; a separate installation of Python is unnecessary.

How to execute the workflow (MASTER.py)
=======================================
0)  It is assumed that you have downloaded and unzipped the ZIP file californiaAna44.zip, and
    that you have the correction version of Anaconda installed on your Network A workstation
    running Windows 7.

1)  Launch the Anaconda Prompt.
    -  Click on the Windows icon (bottom left on main monitor).

2)  Change directory to the root of the unzipped folder of californiaAna44.

3)  Execute MASTER.py.
    -  Anaconda> python MASTER.py
    -  Hit ENTER.

Learning material
=================
For conceptual understanding behind the implemented workflow, the user is referred to Chapter 2
of the book by Géron cited above. This book is available at the Statistics Canada library.

Project history
===============
californiaAna44 is one of the outreach deliverables of a joint project in 2017/2018 among members
of two reading/working groups within the Methodology Branch launched during that fiscal year:
-  Machine Learning and Operations Research Reading/Working Group, and
-  Methodological Group on Big Science and Data Science.
The participating methodologists are: Kenneth Chu, Joanne Leung, Herbert Nkwimi-Tchahou, and
Guillaume Rochefort-Maranda.

Help, support, comments
=======================
If you have questions, comments, or would like assistance, please feel free to contact the author,
or the two aforementioned reading/working groups.

