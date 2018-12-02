###############################################################################
# Supervised Machine Learning Pipeline Example:
#              Heart Disease classification using Tree-based methods
#
# Author: Joanne Leung (BSMD)
# February 23, 2018
#
# File: HD_model_evaluation.py
#
###############################################################################
#
# The HD_model_evaluation module contains functions that involve training and 
# model selection.  It also computes peformance scores for a given model based
# on the test set.
#
###############################################################################

# Import the required modules
import numpy as np

from sklearn.metrics import confusion_matrix
from sklearn.metrics import precision_score, recall_score, f1_score, accuracy_score
from sklearn.metrics import roc_auc_score, roc_curve
from sklearn.metrics import matthews_corrcoef

from sklearn.model_selection import cross_val_score

import matplotlib.pyplot as plt
import seaborn as sns

from HD_preprocessing import preprocess_X

###############################################################################
# Function: specificity_score
###############################################################################
def specificity_score(y_true, y_pred):
    """
    (This function is not currently used in this pipeline.)
    Define specificity score as it is not available in scikit-learn.
    In case you would like to use it as a scoring metric in cross validation.
    """
    # Individual elements in the confusion matrix
    tn, fp, fn, tp = confusion_matrix(y_true=y_true, y_pred=y_pred).ravel()

    # convert the integers to float in case this is run in Python 2
    tn = float(tn)
    fp = float(fp)
    fn = float(fn)
    tp = float(tp)
    
    specificity = tn / (fp + tn)
    return specificity



###############################################################################
# Function: classification_metrics
###############################################################################
def classification_metrics(y_true, y_pred, y_score):
    """
    Computes various metrics to evaluate a ML model for a binary (two-class)
    classification problem.
    
    Returns a dictionary of following metrics:
    (1) precision,
    (2) recall,
    (3) F1 score,
    (4) accuracy,
    (5) area under the ROC curve (roc_auc),
    (6) confusion matrix,
    (7) counts of true positives,
    (8) counts of false positives,
    (9) counts of true negatives,
    (10) counts of false positives,
    (11) sensitivity,
    (12) specificity,
    (13) Matthews Correlation coefficient
    
    and for plotting of ROC curves:
    (14) false positive rates (fpr),
    (15) true positive rates (tpr), and
    (16) threholds.
    """
    metrics = {}
    
    metrics["precision"] = precision_score(y_true = y_true, y_pred = y_pred)
    metrics["recall"]    = recall_score(y_true = y_true, y_pred = y_pred)
    metrics["f1"]        = f1_score(y_true = y_true, y_pred = y_pred)
    metrics["accuracy"]  = accuracy_score(y_true = y_true, y_pred = y_pred)
    metrics["roc_auc"]   = roc_auc_score(y_true = y_true, y_score = y_score)
    metrics["confmat"]   = confusion_matrix(y_true = y_true, y_pred = y_pred)
    
    # Individual elements in the confusion matrix
    tn, fp, fn, tp = confusion_matrix(y_true = y_true, y_pred = y_pred).ravel()
    
    # convert the integers to float in case this is run in Python 2
    tn = float(tn)
    fp = float(fp)
    fn = float(fn)
    tp = float(tp)
    
    metrics["true_neg_counts"] = tn
    metrics["false_pos_counts"] = fp
    metrics["false_neg_counts"] = fn
    metrics["true_pos_counts"] = tp
    
    # sensitivity (same as recall) and specificity
    metrics["sensitivity"] = tp / (tp + fn)
    metrics["specificity"] = tn / (fp + tn)
    
    # Matthews correlation coeffient
    metrics["MCC"] = matthews_corrcoef(y_true = y_true, y_pred = y_pred)

    # ROC curve
    fpr, tpr, thresholds = roc_curve(y_true = y_true, y_score = y_score)
    metrics["roc_fpr"] = fpr
    metrics["roc_tpr"] = tpr
    metrics["thresholds"] = thresholds

    return metrics



###############################################################################
# Function: display_scores
###############################################################################
def display_scores(metrics):
    """
    Show the scores (6 decimal places) for various metrics for a given classifier.
    """
    print("\nAccuracy: {:.6f}".format(metrics["accuracy"]))
    print("Precision: {:.6f}".format(metrics["precision"]))
    print("Recall: {:.6f}".format(metrics["recall"]))
    print("Sensitivity: {:.6f}".format(metrics["sensitivity"]))
    print("Specificity: {:.6f}".format(metrics["specificity"]))
    print("Matthews Correlation Coefficient: {:.6f}".format(metrics["MCC"]))
    print("F1 score: {:.6f}".format(metrics["f1"]))
    print("Area under ROC: {:.6f}".format(metrics["roc_auc"]))
    
    return( None )



###############################################################################
# Function: plot_validation_curve
###############################################################################
def plot_validation_curve(cv_scoring_name, cv_results, clf_name, model_num, 
                          save_plots):
    """
    Plots the training and validation scores for cross validation.
    Only works for cases where we tune only one hyperparameter in a given classifier,
    and that the values for the hyperparameter are all numeric.
    
    Adapted from Raschka (2015), Python Machine Learning, Packt Publishing.
    """
    # Mean scores from cross validation (training set and validation set)    
    train_mean = cv_results["mean_train_score"]    
    valid_mean = cv_results["mean_test_score"]
    
    # Obtain the name of the hyperparameter so that we can put it on the title
    # and on the x-axis of the graph
    i = 0
    param_val = []
    for param_dict in cv_results["params"]:
        for name, val in param_dict.items():
            if i == 0:
                param_name = name
            param_val.append(val)
            i += 1

    # Plot settings            
    rc = {'xtick.labelsize': 16, 'ytick.labelsize': 16}
    sns.set(rc)

    if model_num < 10:
        figure = "HD_model_eval-0" + str(model_num) + "-validation_curve.png"
    else:
        figure = "HD_model_eval-" + str(model_num) + "-validation_curve.png"

    plt.figure(figsize=(8, 6))

    plt.title("Model {0} - {1}: \nAverage scores for varying {2}\n (10-fold cross-validation)\n".format(
            model_num, clf_name, param_name), fontsize=24)

    # Plot training scores        
    plt.plot(param_val, train_mean, color="blue", marker='o', markersize=5, 
             label="Training score")

    # Plot validation scores
    plt.plot(param_val, valid_mean, color="green", linestyle='--', marker='s', markersize=5, 
             label="Validation score")

    plt.xlabel(param_name, fontsize=20)
    plt.ylabel("Score ({})".format(cv_scoring_name.title()), fontsize=20)
    
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)

    plt.grid(True)
    plt.legend(loc="lower right", fontsize=20)
    plt.ylim([0.0, 1.05])
    
    plt.tight_layout()

    if save_plots:    
        plt.savefig(figure, dpi = 600, bbox_inches='tight', pad_inches=0.2)
        plt.close()
    else:
        plt.show()
        
    sns.set()

    return( None )



###############################################################################
# Function: display_confusion_matrix
###############################################################################
def display_confusion_matrix(mat, ax):
    """
    Show the confusion matrix as a heatmap. 
    """ 
    ax.set_title("Confusion matrix (test set)", fontsize=20)

    sns.heatmap(mat, square=True, annot=True, fmt='d', cbar=False, ax=ax, annot_kws={"size": 24})
    
    ax.set_xlabel("Predicted Class", fontsize=18)
    ax.set_ylabel("True Class", fontsize=18)
    
    return( None )



###############################################################################
# Function: plot_ROC
###############################################################################
def plot_ROC(metrics, ax):
    """
    Plot the ROC curve.
    """
    ax.set_title("ROC curve (test set)", fontsize=20)
    
    fpr = metrics["roc_fpr"]
    tpr = metrics["roc_tpr"]
    thresholds = metrics["thresholds"]
    roc_auc = metrics["roc_auc"]
        
    clf_label = "ROC (area = {:.3f})".format(roc_auc)
    thres_label = "Threshold 0.5"
    
    # Plot the ROC curve
    ax.plot(fpr, tpr, label=clf_label)

    # Plot the default threshold for class probabilities (0.5)
    # Find the closest index that gives threshold of 0.5 to locate its
    # corresponding FPR and TPR
    default_thres = np.argmin(np.abs(thresholds - 0.5))
    plt.plot(fpr[default_thres], tpr[default_thres], 'o', markersize=8,
             label=thres_label, fillstyle="none", c='k', mew=2)
    
    ax.set_xlabel("False Positive Rate (1-Specificity)", fontsize=18)
    ax.set_ylabel("True Positive Rate (Sensitivity)", fontsize=18)
    
    ax.legend(loc="lower right", fontsize=16)

    return( None )

    

###############################################################################
# Function: display_confmat_ROC
###############################################################################
def display_confmat_ROC(metrics, clf_name, model_num, save_plots):
    """
    Display the confusion matrix and the ROC curve side by side on a PNG file.
    """
    rc = {'xtick.labelsize': 16, 'ytick.labelsize': 16}
    sns.set(rc)

    if model_num < 10:
        figure = "HD_model_eval-0" + str(model_num) + "-confusion_matrix_ROC.png"
    else:
        figure = "HD_model_eval-" + str(model_num) + "-confusion_matrix_ROC.png"

    fig, (ax_confmat, ax_roc) = plt.subplots(nrows=1, ncols=2, figsize=(12, 6))
    fig.suptitle("Model {0} - {1}".format(model_num, clf_name), fontsize=24)
    
    # Display the confusion matrix
    display_confusion_matrix(metrics["confmat"], ax_confmat)
    
    # Plot the ROC curve
    plot_ROC(metrics, ax_roc)

    plt.subplots_adjust(top=0.8, wspace=0.3)
    
    if save_plots:    
        plt.savefig(figure, dpi = 600, bbox_inches='tight', pad_inches=0.2)
        plt.close()
    else:
        plt.show()

    sns.set()

    return( None )



###############################################################################
# Function: display_feature_importances
###############################################################################
def display_feature_importances(clf, X_train):
    """
    Show the feature importances for a given classifier (classification tree or
    random forest).
    """
    feature_importances = clf.feature_importances_
    numeric_attribs = list(X_train.columns)
    attributes = list(numeric_attribs)

    print("\nfeature_importances_:")
    for curr_item in sorted(zip(feature_importances, attributes), reverse=True):
        print( curr_item )

    return( None )



###############################################################################
# Function: report_best_parameters
###############################################################################
def report_best_parameters(cvresults, n_top=5):
    """
    Prints the top (5 by default) results from grid search based on validation scores.
    
    Adapted from the following example from scikitlearn:
    http://scikit-learn.org/stable/auto_examples/model_selection/plot_randomized_search.html
    """
    for i in range(1, n_top + 1):
        candidates = np.flatnonzero(cvresults["rank_test_score"] == i)
        
        for candidate in candidates:
            print("Model with rank: {0}".format(i))
            print("Mean validation score: {0:.6f} (std: {1:.6f})".format(
                  cvresults["mean_test_score"][candidate],
                  cvresults["std_test_score"][candidate]))
            print("Parameters: {0}".format(cvresults["params"][candidate]))
            print("")

    return( None )



###############################################################################
# Function: evaluate_classifer
###############################################################################
def evaluate_classifier(X_train, X_test, y_train, y_test, 
                        cv, cv_scoring_method, cv_scoring_name,
                        clf, clf_name, model_num, 
                        print_feat_impt=False,
                        save_plots=True):
    """
    Evaluate a given classification model.
    For a given classification model with a fixed hyperparameter, 
    (1) Pre-process the training set.  Fit the model with the training set.  
        Compute various metrics.
    (2) Use 10-fold cross validation on the training set.  Compute the scores.
    (3) Pre-process the test set then compute predictions for the test set 
        using the trained model.  Compute various metrics.
    Print out the metrics for each step.
    Display the confusion matrix and the ROC curves based on the test set.
    Return the metrics for the training, validation and test sets.
    
    Parameters:
    X_train = features in training set
    X_test = features in the test set
    y_train = target in training set
    y_test = target in test set
    cv = cross validation folds
    cv_socring_method = scoring method for cross validation
    cv_scoring_name = string representing the scoring method for cross
                      validation
    clf = classifier object
    clf_name = name of the classifier
    model_num = id of the classifer
    print_feat_impt = boolean (default=False) that indicates whether feature
                      importances are printed.  (Note that methods such as
                      Bagging does not have the feature importances attribute.) 
    save_plots = boolean (default=True) that indicates whether the plots will
                 be saved as PNG files or shown on screen
    """

    #########################################
    ### Training                       
    #########################################
    # Pre-process the training data
    X_train = preprocess_X(X_train, train_flag=True)

    # Train the model with the full training set
    # Compute the predicted values in the training set
    # Compute the predicted probabilities for class=1
    clf.fit(X_train, y_train)
    y_train_pred = clf.predict(X_train)
    y_train_score = clf.predict_proba(X_train)[:, 1]

    # Use k-fold cross validation on the training set
    y_cv_score = cross_val_score(clf, X_train, y_train, cv=cv, scoring=cv_scoring_method)

    #########################################
    ### Predictions    
    ######################################### 
    # pre-process the test set
    X_test = preprocess_X(X_test, train_flag=False)
    
    # Predictions using the test set
    y_test_pred = clf.predict(X_test)
    y_test_score = clf.predict_proba(X_test)[:, 1]

    ###########################################################
    # Classification metrics (training, cross validation, test)
    ###########################################################
    metrics_train = classification_metrics(y_true = y_train, 
                                           y_pred = y_train_pred, 
                                           y_score = y_train_score)

    # Record the average validation score in a dictionary for comparisons later on
    metrics_cv = {}
    metrics_cv[cv_scoring_name] = y_cv_score.mean()

    metrics_test = classification_metrics(y_true = y_test, 
                                          y_pred = y_test_pred, 
                                          y_score = y_test_score)
 
    # Print the scores
    print("\n\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("###  Model {0}: {1}".format(model_num, clf_name))
    print("### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")

    print("\n-------------------------------")
    print("Evaluation on the training set:")
    print("-------------------------------")
    display_scores(metrics_train)

    print("\n-----------------------------")
    print("10-Fold Cross Validation:")
    print("-----------------------------")
    print("\n{} score:".format(cv_scoring_name.title()))
    print("        mean: {:.6f}".format(y_cv_score.mean()))
    print("         std: {:.6f}".format(y_cv_score.std()))

    print("\n-----------------------------")
    print("Evaluation on the test set:")
    print("-----------------------------")
    display_scores(metrics_test)

    # Display the confusion matrix and plot the ROC curve (test set)
    display_confmat_ROC(metrics_test, clf_name, model_num, save_plots)
    
    # examine feature importances (if applicable)
    if print_feat_impt: 
        display_feature_importances(clf, X_train)

    return [metrics_train, metrics_cv, metrics_test]



###############################################################################
# Function: evaluate_grid_classifier
###############################################################################
def evaluate_grid_classifier(X_train, X_test, y_train, y_test, 
                             cv_scoring_method, cv_scoring_name,
                             clf, clf_name, model_num, 
                             plot_valid_curve=False, print_feat_impt=False,
                             save_plots=True):
    """
    Evaluate a given classification model that has gone through hyperparameter 
    tuning via GridSearchCV.
    For a given classification model with the hyperparameters that give the 
    best score in cross validation, 
    (1) Pre-process the training set.  Fit the best model with the training  
        set.  Compute various metrics.
    (2) Report the scores from cross validation.  Print the best model.
    (3) Pre-process the test set then compute predictions for the test set 
        using the trained model.  Compute various metrics.
    Print out the metrics for each step.
    Display the confusion matrix and the ROC curves based on the test set.
    Return the metrics for the training, validation and test sets.
    
    Parameters:
    X_train = features in training set
    X_test = features in the test set
    y_train = target in training set
    y_test = target in test set
    cv_scoring_method = scoring method for cross validation
    cv_scoring_name = string representing the scoring method for cross
                      validation
    clf = classifier object
    clf_name = name of the classifier
    model_num = id of the classifer
    print_valid_curve = boolean (default=False) that indicates whether the 
                        validation curve is printed.  (Note that it only works
                        when there is only one hyperparameter to tune, and that 
                        the hyperparameter values are all numeric.)
    print_feat_impt = boolean (default=False) that indicates whether feature
                      importances are printed.  (Note that methods such as
                      Bagging does not have the feature importances attribute.)    
    save_plots = boolean (default=True) that indicates whether the plots will
                 be saved as PNG files or shown on screen
    """    
    #########################################
    ### Training                       
    #########################################
    # Pre-process the training data
    X_train = preprocess_X(X_train, train_flag=True)

    # Train the model with the full training set, using the best model found
    # from grid search
    # Compute the predicted values in the training set
    # Compute the predicted probabilities for class=1
    clf.fit(X_train, y_train)    
    y_train_pred = clf.predict(X_train)
    y_train_score = clf.predict_proba(X_train)[:, 1]
    
    #########################################
    ### Predictions    
    ######################################### 
    # pre-process the test data
    X_test = preprocess_X(X_test, train_flag=False)

    # Predictions using the test set
    y_test_pred = clf.predict(X_test)
    y_test_score = clf.predict_proba(X_test)[:, 1]

    ###########################################################
    # Classification metrics (training, cross validation, test)
    ###########################################################
    metrics_train = classification_metrics(y_true = y_train, 
                                           y_pred = y_train_pred, 
                                           y_score = y_train_score)

    metrics_test = classification_metrics(y_true = y_test, 
                                          y_pred = y_test_pred, 
                                          y_score = y_test_score)

    # Record the best validation score in a dictionary for comparisons later on
    metrics_cv = {}
    metrics_cv[cv_scoring_name] = clf.best_score_

    # Print the scores
    print("\n\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("###  Model {0}: {1}".format(model_num, clf_name))
    print("### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")

    print("\n-------------------------------")
    print("Evaluation on the training set:")
    print("-------------------------------")
    display_scores(metrics_train)

    print("\n--------------------------------------------------")
    print("(Cross validation, grid search) Average F1 score:")
    print("--------------------------------------------------")
    CVResults = clf.cv_results_
    
    
    # Plot the training vs validation score in the grid search  (if applicable)
    # (only works for cases with only one all-numeric hyperparameter)
    if plot_valid_curve:
        plot_validation_curve(cv_scoring_name, CVResults, clf_name, model_num, save_plots)

    # Display the scores for each of the hyperparameter values
    for mean_score, std_score, params in zip(CVResults["mean_test_score"], 
                                             CVResults["std_test_score"], 
                                             CVResults["params"]):
        print("mean={:.6f}, std={:.6f}, {}".format(mean_score , std_score , params))
        
    print("\nThe top 5 models are as follows:")
    report_best_parameters(CVResults)
    
    print("\nbest_params_:")
    print(   clf.best_params_ )
        
    print("\nbest_estimator_:")
    print(   clf.best_estimator_ )
   
    # Print the test scores
    print("\n-----------------------------")
    print("Evaluation on the test set:")
    print("-----------------------------")
    display_scores(metrics_test)

    # Display the confusion matrix and plot the ROC curve (test set)
    display_confmat_ROC(metrics_test, clf_name, model_num, save_plots)
    
    # examine feature importances (if applicable)
    if print_feat_impt:
        display_feature_importances(clf.best_estimator_, X_train)

    return [metrics_train, metrics_cv, metrics_test]


