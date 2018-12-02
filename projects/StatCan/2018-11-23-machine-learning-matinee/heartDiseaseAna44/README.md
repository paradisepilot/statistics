heartDiseaseAna44
=================

Author: Joanne Leung, BSMD (joanne.leung@canada.ca)

Release Date: February 23, 2018


Overview of the package
=======================
HeartDiseaseAna44 is an implementation of a supervised machine learning 
workflow using tree-based methods.  It is designed to be a workflow template 
executable on Network A.  Its goal is to serve as a viable starting point for 
Statistics Canada colleagues who wish to experiment with Python-based machine 
learning tools or to prototype Python-based machine learning solutions.

HeartDiseaseAna44 contains a single master program called HD_MASTER.py, which 
in turn executes code contained in a collection of supporting Python modules.  
Execution of HD_MASTER.py executes an entire classification (supervised machine 
learning with categorical response variable) workflow on a small embedded 
publicly downloadable data set.  

Complete documentation of a run-through of this pipeline can be found in the
Jupyter Notebook (or the corresponding copies in HTML or PDF), located in the
"doc" folder.


About the Heart Disease classification workflow
===============================================
The Heart Disease data sets are publicly available from the University of 
California, Irvine (UCI) Machine Learning Repository:
http://archive.ics.uci.edu/ml/datasets/heart+Disease

The data set we use in this exercise is produced by the Cleveland Clinic 
Foundation.  It contains 303 observations, with patients' measurements related 
to the diagnosis of heart disease.  We are using a pre-processed version of the
data set, which consists of 14 variables: 13 features and 1 target. 
For more information regarding the variables in the data set, please refer to 
the link above, or see the header in HD_MASTER.py.  

The Cleveland data set, a comma-delimited file, is downloadable via the following 
link:
http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data

The objective of this exercise is to use supervised machine learning techniques 
in Python to predict the presence or absence of heart disease.

The workflow is composed of the following steps: 
(1) Data exploration
(2) Splitting the data into training and test sets
(3) Data pre-processing
(4) Training and model selection
(5) Performance evaluation on the test set

The models being considered are tree-based methods, which include:
-  Classification trees (Breiman et. al., 1984)
-  Bagging (Breiman, 1996)
-  Random forests (Breiman, 2001)
-  AdaBoost (Freund and Schapire, 1997)


How to execute the workflow (HD_MASTER.py)
=======================================
0)  It is assumed that you have downloaded and unzipped the ZIP file 
    heartDiseaseAna44.zip to a folder that you have WRITE access to, and that 
    you have the correct version of Anaconda installed on your Network A 
    workstation running Windows 7.

1)  Launch Anaconda Prompt.
    -  Click on the Windows icon (bottom left on main monitor).
    -  Click on "All Programs".
    -  Click on the folder "Anaconda3" (or "Anaconda2").
    -  Click on "Anaconda Prompt".

2)  Within Anaconda Prompt, change to the disk drive, if necessary, that 
    contains the downloaded template pipeline.

    For example, suppose Anaconda starts by default on the C:\ drive, but you 
    unzipped heartDiseaseAna44.zip to the following location: 
    F:\tmp\heartDiseaseAna44.

    Then, you will need to first change to the F:\ drive. You can do so with 
    the following command at the Anaconda Prompt:
    -  (Anaconda3) C:\> F:
    -  Hit ENTER.

    Your prompt should have changed to: (Anaconda3) F:\>

3)  Next, change directory to the root of the unzipped folder of 
    heartDiseaseAna44. Assuming again you saved the unzipped folder to 
    F:\tmp\heartDiseaseAna44, and you have changed drive to F:\ as shown in (2).

    Then, you can change to the correct folder as follows:
    -  (Anaconda3) F:\> cd tmp\heartDiseaseAna44
    -  Hit ENTER.

    Your prompt should have changed to: (Anaconda3) F:\tmp\heartDiseaseAna44>

4)  Now, you are ready to run the pipeline, by executing HD_MASTER.py as follows:

    -  F:\tmp\heartDiseaseAna44> python HD_MASTER.py
    -  Hit ENTER.

    Watch the output folder (output.<username>) being generated, and output 
    files being generated within it.  Depending on the speed of the 
    processing, the program could take 15 minutes or more to complete.


Software Requirements
=====================
The heartDiseaseAna44 pipeline is tested for Anaconda 4.4/Python 2.7.  

Anaconda is one of the most widely used Python-based data science platforms.  
Anaconda has been approved as part of the Methodologist's standard software 
toolbox.  If you are a methodologist, simply send an SRM to request installation
of Anaconda on your workstation.  Note that the current default version of 
Anaconda may be different from the one cited above.

Anaconda contains an embedded distribution of Python. In particular, only
installation of Anaconda is required; a separate installation of Python is
unnecessary.  For more information about Anaconda, visit: 
https://www.anaconda.com/.


Learning material
=================
For more information regarding the machine learning tools available in the 
Scikit-learn package in Python, please see the following:
-  http://scikit-learn.org/stable/index.html
-  Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, 
   O., Blondel, M., Prettenhofer, P., Weiss, R., Dubourg, V., Vanderplas, J., 
   Passos, A., Cournapeau, D., Brucher, M., Perrot, M., and Duchesnay, É. (2011).  
   Scikit-learn: Machine Learning in Python.  Journal of Machine Learning 
   Research, 12(Oct): 2825-2830.

For conceptual understanding behind a generic machine learning workflow, please
refer to Chapter 2 of the following book:
-  Géron, A. (2017), Hands-On Machine Learning with Scikit-Learn & TensorFlow, 
   O'Reilly.
This book is available at the Statistics Canada library.

For further readings on Python for data analysis or for machine learning, you 
could consult the following books:
-  Géron, A. (2017), Hands-On Machine Learning with Scikit-Learn & TensorFlow, 
   O'Reilly.
-  McKinney, W. (2012), Python for Data Analysis, O'Reilly.
-  Raschka, S. (2015), Python Machine Learning, Packt Publishing.

For mathematical foundations on each method being considered in this pipeline, 
please consult the following resources:
-  Breiman, L. (1996), Bagging predictors, Machine Learning, 24(2), 123-140.
-  Breiman, L. (2001), Random forests, Machine Learning, 45(1), 5-32.
-  Breiman, L., Friedman, J., Stone, C.J. & Olshen, R.A. (1984), Classification
   and Regression Trees, Taylor & Francis.
-  Freund, Y. & Schapire, R. E. (1997), A decision-theoretic generalization of 
   on-line learning and an application to boosting, Journal of Computer and 
   System Sciences, 55(1), 119-139.


Project history
===============
HeartDiseaseAna44 is one of the outreach deliverables of a joint project in 
2017/2018 among members of two reading/working groups within the Methodology 
Branch launched during that fiscal year:
-  Machine Learning and Operational Research Reading/Working Group, and
-  Methodological Group on Big Data and Data Science.

The participating methodologists are: Kenneth Chu, Joanne Leung, Herbert Nkwimi
Tchahou, and Guillaume Rochefort-Maranda.


Help, support, comments
=======================
If you have questions, comments, or would like assistance, please feel free to 
contact the author, or the two aforementioned reading/working groups.

