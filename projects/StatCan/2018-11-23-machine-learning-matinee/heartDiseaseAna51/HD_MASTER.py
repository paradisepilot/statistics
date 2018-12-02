#!/usr/bin/env python

###############################################################################
# Supervised Machine Learning Pipeline Example:
#              Heart Disease classification using Tree-based methods
#
# Author: Joanne Leung (BSMD)
# February 23, 2018
#
# File: HD_MASTER.py
#
###############################################################################
#
#  SYNOPSIS
#  ========
#  This Python program (HD_MASTER.py) is a demo supervised machine learning
#  pipeline.  Its purpose is to faciliate learning and experimentation with 
#  machine learning tools available in Python for Statistics Canada colleagues 
#  who are new to machine learning or Python.  This pipeline can be executed
#  on Network A.
#
#  The objective of this exercise is to use supervised machine learning 
#  techniques, tree-based techniques (classification trees, bagging, random
#  forest, AdaBoost) in particular, in Python to predict the presence or 
#  absence of heart disease.
#
#  Please refer to the README.txt for the following information:
#  - About the Heart Disease classification workflow
#  - How the execute this pipeline
#  - Software requirments
#
#  EXECUTION INSTRUCTIONS
#  ======================
#  For how to execute this pipeline (HD_MASTER.py), follow the instructions in
#  the README file, namely:
#
#      ./README.txt
#
#  INPUT
#  =====
#  This pipeline contains a single (input) tabular data file in CSV format:
#
#    1)  ./data/processed.cleveland.data
#
#        This comma-delimited file contains 303 non-header rows. Each row 
#        contains patients' measurements related to the diagnosis of heart
#        disease.  This file contains columns with the following headers:
#
#          - age: Age (continuous)
#          - sex: Sex (categorical)
#          - chest_pain_type: Chest pain type (categorical)
#          - rest_bp: Resting blood pressure on admission to hospital 
#                    (continuous)
#          - cholesterol: Serum cholesterol (continuous)
#          - fast_blood_sugar: Fasting blood sugar > 120 mg/dl (categorical)
#          - rest_ecg: Resting electrocardiographic results (categorical)
#          - max_hr_achieved: Maximum heart rate achieved (continuous)
#          - exer_induced_angina: Exercise induced angina (categorical)
#          - old_peak: ST depression induced by exercise relative to rest 
#                      (continuous)
#          - slope: The slope of the peak exercise ST segment (categorical)
#          - coloured_vessels: Number of major vessels (0-3) coloured by 
#                              flourosopy (categorical)
#          - thal: Normal, fixed defect, reversable defect (categorical)
#          - diagnosis: Diagnosis of heart disease (angiographic disease 
#                       status) (categorical)
#
#        The (categorical) variable "presence" will be used as the
#        response variable for the classificiation exercises performed by this
#        pipeline. It is derived from the "diganosis" variable, as follows:
#          - presence = False (0) refers to cases with diagnosis = 0 
#          - presence = True(1) refers to cases with diagnosics = 1, 2, 3 or 4
#
#        Apart from diagnosis and presence, the rest of the variables will be 
#        used as predictor variables (features).
#
#  OUTPUT
#  ======
#
#  Upon execution, MASTER.py first creates the following output directory:
#  ./output.<username>. When execution finishes without errors, the newly
#  created output directory will contain the following:
#
#    1)  ./output.<username>/HD_MASTER.py
#        a copy of ./HD_MASTER.py (for reproducibility)
#
#    2)  ./output.<username>/code
#        a copy of the code directory ./code (for reproducibility)
#
#    3)  ./output.<username>/log.debug
#        debugging log file (should be empty)
#
#    4)  ./output.<username>/log.stderr
#        standard error log file (should be empty)
#
#    5)  ./output.<username>/log.stdout
#        main output text file of the pipeline.
#        It starts with summary and exploratory statistics of the input file,
#        followed by model-fitting performance metrics of the aforementioned
#        implemented machine learning techniques.
#
#    6)  ./output.<username>/HD_preprocessing-01-visualize_continuous_variables.png
#        histograms of the five continuous variables
#
#    7)  ./output.<username>/HD_preprocessing-02-visualize_categorical_variables.png
#        histograms of the nine categorical variables
#
#    8)  ./output.<username>/HD_preprocessing-03-pairplots_continuous_variables.png
#        pair plots of the five continuous variables
#
#    9)  ./output.<username>/HD_preprocessing-04-correlation_matrix.png
#        heat map that shows the lower triangle of the correlation matrix
#
#    10)  ./output.<username>/HD_model_eval-01-confusion_matrix_ROC.png
#    11)  ./output.<username>/HD_model_eval-02-confusion_matrix_ROC.png
#    12)  ./output.<username>/HD_model_eval-03-confusion_matrix_ROC.png
#    13)  ./output.<username>/HD_model_eval-04-confusion_matrix_ROC.png
#    14)  ./output.<username>/HD_model_eval-05-confusion_matrix_ROC.png
#    15)  ./output.<username>/HD_model_eval-06-confusion_matrix_ROC.png
#        confusion matrix and ROC curve on the test set, for each of the 
#        model considered
#
#    16)  ./output.<username>/HD_model_eval-03-validation_curve.png
#    17)  ./output.<username>/HD_model_eval-04-validation_curve.png
#    18)  ./output.<username>/HD_model_eval-06_validation_curve.png
#        validation curves for some models that go through hyperparameter
#        tuning with only one hyperparameter
#
#    19)  ./output.<username>/HD_model_compare-01-ROC_curves.png
#        ROC curves on the test set, for all the models considered
#
#    20)  ./output.<username>/HD_model_comparisons.xlsx
#        Excel file that contains the training, validation and test scores,
#        for each model considered
#
################################################################################


###############################################################################
### Set up the environment
###############################################################################

import os, sys, shutil, getpass
import pprint, logging, datetime
import stat

thisScript = os.path.realpath(sys.argv[0])
dir_MASTER = os.path.dirname(thisScript)
dir_code   = os.path.join(dir_MASTER, "code")
dir_data   = os.path.join(dir_MASTER, "data")
dir_output = os.path.join(dir_MASTER, "output." + getpass.getuser())

if not os.path.exists(dir_output):
    os.makedirs(dir_output)

os.chdir(dir_output)
sys.stdout = open('log.stdout','w')
sys.stderr = open('log.stderr','w')

print("Running " + thisScript + "...")

print("\n\n####################")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( "\n" + myTime + "\n" )
print("####################")

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

shutil.copy2( src = thisScript, dst = dir_output )

dir_code_replica = os.path.join(dir_output,"code")
shutil.copytree(src = dir_code, dst = dir_code_replica)

# append code directory replica to list of library paths
sys.path.append(dir_code_replica)


###############################################################################
### Beginning of the Heart Disease Classificcation example
###############################################################################
# Import the required modules
import numpy   as np
import pandas  as pd

from HD_preprocessing import read_heart_file
from HD_preprocessing import examine_heart_data
from HD_preprocessing import visualize_heart_data
from HD_preprocessing import split_dataset

from HD_model_evaluation import evaluate_classifier
from HD_model_evaluation import evaluate_grid_classifier

from HD_model_comparisons import model_comparisons

from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import BaggingClassifier
from sklearn.ensemble import AdaBoostClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import KFold
from sklearn.model_selection import GridSearchCV

# For custom creation of scoring method (e.g specificity)
#from sklearn.metrics import make_scorer
#from HD_model_evaluation import specificity_score

# For visualizing decision trees using the Graphviz (or Graphviz online)
#from sklearn.tree import export_graphviz

###############################################################################
### Set up
###############################################################################
# Flag to indicate whether the plots are saved as PNG files or show on screen
save_plots = True

# Set the seed for the random state
# For reproducable results, use an integer for seed.  Otherwise, set seed=None.
seed = 274

# Scoring method for cross validation
# Many of these methods (e.g. f1, roc_auc) are already available in scikit-learn.
# If a scoring method is not available in scikit-learn, you could also create it
# using the make_scorer() function in sklearn.metrics.
# Examples for F1, specificity, accuracy:
#cv_scoring_method = "f1"
#cv_scoring_method = make_scorer(specificity_score, greater_is_better=True)
#cv_scoring_method = "accuracy"
cv_scoring_method = "roc_auc"


# Name for the cv scoring method, to be used as a column name when storing the 
# results (in lower case).
# Examples for F1, specificity, accuracy:
#cv_scoring_name = "f1"
#cv_scoring_name = "specificity"
#cv_scoring_name = "accuracy"
cv_scoring_name = "roc_auc"


###############################################################################
### Read and examine the data
###############################################################################
# load data and add the column names
heart_FILE = os.path.join(dir_data, 'processed.cleveland.data')

heart_disease = read_heart_file(heart_FILE)

# examine full data set
examine_heart_data(dataset = heart_disease)


###############################################################################
### Split the data into training set and test set
###############################################################################
# Split into features (or X, independent variables) 
# and targets (or y, dependent variable)
X = heart_disease.drop(["presence"], axis=1)
y = heart_disease["presence"].copy()

# Split the data into training and test sets
X_train, X_test, y_train, y_test = split_dataset(X, y, stratify=y, 
                                                 test_size=0.3, 
                                                 random_state=seed)


###############################################################################
### Put the test set aside and only visualize the training set to get a 
### general understanding of the data.
###############################################################################

# Combine the features and target to form the complete training data
training_set = pd.concat((X_train, y_train), axis=1)

# visualize the training set
visualize_heart_data(dataset = training_set, save_plots = save_plots)


###############################################################################
### Fit the Training data with various tree-based models.  
### Perform hyperparameter via K-Fold cross validation as necessary.
### Evaluate the performance of the fitted models using various metrics.
###############################################################################

# Number of folds in k-fold cross validation
k = 10

# Use this same k-fold setup to fit each model so that the scores can be
# comparable
kf = KFold(n_splits=k, random_state=seed)


###############################################################################
### Decision Trees
###############################################################################

# Model 1: Decision Tree (max_depth=1, Underfitting)
model_num = 1
Tree1_name = "Decision Tree (max_depth=1)"

Tree1 = DecisionTreeClassifier(max_depth = 1, random_state = seed)

Tree1_metrics = evaluate_classifier(
        X_train = X_train, 
        X_test = X_test, 
        y_train = y_train, 
        y_test = y_test, 
        cv = kf,
        cv_scoring_method = cv_scoring_method,
        cv_scoring_name = cv_scoring_name,
        clf = Tree1,
        clf_name = Tree1_name,
        model_num = model_num,
        save_plots = save_plots)



# Model 2: Decision Tree (fully grown, Overfiting)
model_num += 1
Tree2_name = "Decision Tree (default)"

Tree2 = DecisionTreeClassifier(random_state = seed)

Tree2_metrics = evaluate_classifier(
        X_train = X_train, 
        X_test = X_test, 
        y_train = y_train, 
        y_test = y_test, 
        cv = kf,
        cv_scoring_method = cv_scoring_method,
        cv_scoring_name = cv_scoring_name,
        clf = Tree2,
        clf_name = Tree2_name,
        model_num = model_num,
        save_plots = save_plots)



# Model 3: Decision Tree (hyperparameter = max_depth)
# By default, GridSearchCV retrains the best model found with the entire 
# training set 
model_num += 1
Tree_gs_name = "Decision Tree (grid search)"

Tree3 = DecisionTreeClassifier(random_state = seed)
DT_parameter_grid = [
    { 'max_depth':[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}
    ]

Tree_gs = GridSearchCV(
            estimator = Tree3,
            param_grid = DT_parameter_grid,
            scoring = cv_scoring_method,
            cv = kf,
            n_jobs = 1)

Tree_gs_metrics = evaluate_grid_classifier(
        X_train = X_train,
        X_test = X_test,
        y_train = y_train,
        y_test = y_test,
        cv_scoring_method = cv_scoring_method,
        cv_scoring_name = cv_scoring_name,
        clf = Tree_gs,
        clf_name = Tree_gs_name,
        model_num = model_num,
        plot_valid_curve = True,
        save_plots = save_plots)



###############################################################################
### Optional: Export the tree to a text file for visualization using Graphviz
### (or Graphviz online)
###############################################################################

# Model 1: Decision Tree (max_depth=1, Underfitting)
#from HD_preprocessing import preprocess_X
#X_cols = preprocess_X(X_train, train_flag=False).columns
#with open("Tree1.txt", "w") as f:
#    f = export_graphviz(Tree1, out_file=f, feature_names=X_cols)

# Model 2: Decision Tree (default parameters, Overfiting)
#with open("Tree2.txt", "w") as f:
#    f = export_graphviz(Tree2, out_file=f, feature_names=X_cols)

# Model 3: Decision Tree (hyperparameter = max_depth)
#with open("Tree3.txt", "w") as f:
#    f = export_graphviz(Tree_gs.best_estimator_, out_file=f, feature_names=X_cols)



###############################################################################
### Bagging (Bootstrap Aggregation)
###############################################################################

# Model 4: Bagging (max_depth=3) (with hyperparameter tuning)
model_num += 1
Bag_gs_name = "Bagging (grid search)"

BTree = DecisionTreeClassifier(max_depth=3)
Bag = BaggingClassifier(base_estimator = BTree,
                         random_state = seed)
Bag_parameter_grid = [
    { 'n_estimators': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
                       11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
                       25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 
                       110, 120, 130, 140, 150] }
    ]

Bag_gs = GridSearchCV(
            estimator = Bag,
            param_grid = Bag_parameter_grid,
            scoring = cv_scoring_method,
            cv = kf)

Bag_gs_metrics = evaluate_grid_classifier(
        X_train = X_train,
        X_test = X_test,
        y_train = y_train,
        y_test = y_test,
        cv_scoring_method = cv_scoring_method,
        cv_scoring_name = cv_scoring_name,
        clf = Bag_gs,
        clf_name = Bag_gs_name,
        model_num = model_num,
        plot_valid_curve = True,
        save_plots = save_plots)



###############################################################################
### Random Forests
###############################################################################

# Model 5: Random Forest (with hyperparameter tuning)
# Default parameter: max_features = "sqrt"
model_num += 1
Forest_gs_name = "Random Forest (grid search)"
Forest = RandomForestClassifier(random_state = seed)
Forest_parameter_grid = [
    { 'n_estimators':[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
                      15, 20, 25, 50, 75, 100, 
                      125, 150, 175, 200, 225, 250],
      'max_depth':[3, 4, 5, None],
      'max_features':[4, 5, 6]}
    ]

Forest_gs = GridSearchCV(
            estimator = Forest,
            param_grid = Forest_parameter_grid,
            scoring = cv_scoring_method,
            cv = kf)
 
Forest_gs_metrics = evaluate_grid_classifier(
        X_train = X_train,
        X_test = X_test,
        y_train = y_train,
        y_test = y_test,
        cv_scoring_method = cv_scoring_method,
        cv_scoring_name = cv_scoring_name,
        clf = Forest_gs,
        clf_name = Forest_gs_name,
        model_num = model_num,
        print_feat_impt = True,
        save_plots = save_plots)



###############################################################################
### Boosting (AdaBoost)
###############################################################################

# Model 6: AdaBoost (with hyperparameter tuning)
# Base classifier: Decision Tree of depth 1 (decision stumps)
model_num += 1
Boost_gs_name = "AdaBoost (grid search)"

ABTree = DecisionTreeClassifier(max_depth = 1)

Boost = AdaBoostClassifier(base_estimator = ABTree,
                            learning_rate = 0.12, 
                            random_state = seed)

Boost_parameter_grid = [
    { 'n_estimators': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
                       11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
                       25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100, 
                       110, 120, 130, 140, 150, 160, 170, 180, 190, 200] }
    ]

Boost_gs = GridSearchCV(
            estimator = Boost,
            param_grid = Boost_parameter_grid,
            scoring = cv_scoring_method,
            cv = kf)

Boost_gs_metrics = evaluate_grid_classifier(
        X_train = X_train,
        X_test = X_test,
        y_train = y_train,
        y_test = y_test,
        cv_scoring_method = cv_scoring_method,
        cv_scoring_name = cv_scoring_name,
        clf = Boost_gs,
        clf_name = Boost_gs_name,
        model_num = model_num,
        plot_valid_curve = True,
        save_plots = save_plots)



###############################################################################
### Summary
###############################################################################

# Create a dictionary that stores the metrics for each algorithm
# <Algorithm>_metrics is an array with two components:
# Index 0 contains a dictionary of metrics computed based on the training set
# Index 1 contains a dictionary of metrics computed based on cross validation
# Index 2 contains a dictionary of metrics computed based on the test set

# Scores for the training set
metrics_train = {
        Tree1_name : Tree1_metrics[0],
        Tree2_name : Tree2_metrics[0],
        Tree_gs_name : Tree_gs_metrics[0],
        Bag_gs_name : Bag_gs_metrics[0],
        Forest_gs_name : Forest_gs_metrics[0],
        Boost_gs_name : Boost_gs_metrics[0]
        }

# Scores from cross validation
metrics_cv = {
        Tree1_name : Tree1_metrics[1],
        Tree2_name : Tree2_metrics[1],
        Tree_gs_name : Tree_gs_metrics[1],
        Bag_gs_name : Bag_gs_metrics[1],
        Forest_gs_name : Forest_gs_metrics[1],
        Boost_gs_name : Boost_gs_metrics[1]
        }


# Scores for the test set
metrics_test = {
        Tree1_name : Tree1_metrics[2],
        Tree2_name : Tree2_metrics[2],
        Tree_gs_name : Tree_gs_metrics[2],
        Bag_gs_name : Bag_gs_metrics[2],
        Forest_gs_name : Forest_gs_metrics[2],
        Boost_gs_name : Boost_gs_metrics[2]
        }

# Display the metrics ROC curves
metrics_train_df, metrics_cv_df, metrics_test_df = model_comparisons(metrics_train, 
                                                                     metrics_cv,
                                                                     metrics_test,
                                                                     cv_scoring_name,
                                                                     save_plots = save_plots)

# Save the metrics into an Excel file
Excel_out = "HD_model_comparisons.xlsx"

writer = pd.ExcelWriter(Excel_out)
metrics_train_df.to_excel(writer, "Training set", index=False)
metrics_cv_df.to_excel(writer, "Cross validation", index=False)
metrics_test_df.to_excel(writer, "Test set", index=False)
writer.save()



print("\n\n####################")
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( "\n" + myTime + "\n" )
print("####################")



