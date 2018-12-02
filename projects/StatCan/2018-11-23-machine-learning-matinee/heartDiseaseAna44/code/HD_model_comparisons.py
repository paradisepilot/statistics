###############################################################################
# Supervised Machine Learning Pipeline Example:
#              Heart Disease classification using Tree-based methods
#
# Author: Joanne Leung (BSMD)
# February 23, 2018
#
# File: HD_model_comparisons.py
#
###############################################################################
#
# The HD_model_comparisons module contains functions that display performance
# scores for all models considered.  This is for evaluation purposes.
#
###############################################################################

# Import the required modules
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


###############################################################################
# Function: save_classification_metrics
###############################################################################
def save_classification_metrics(metrics_dict, cv_scoring_name=None):
    """
    Creates a data frame to store the scores for each classification method

    Parameter:
    metrics_dict: Dictionary of metrics for the classifiers, where
                  key = Name of the classifer, and 
                  value = Dictionary of metrics (metric, value) for the classifier
    cv_scoring_name: Name of the metric used in cross validation (if applicable)
    """
    # Create an empty data frame with the metrics as columns
    metrics_df = pd.DataFrame(
            columns=["model", "roc_auc", "accuracy", "precision", "recall", 
                     "sensitivity", "specificity", "f1", "MCC", 
                     "confusion_matrix", "true_neg_counts", "false_pos_counts",
                     "false_neg_counts", "true_pos_counts"])

    # For each classifer, enter the scores into a row in the data frame
    i = 0
    for clf_name, metrics in sorted(metrics_dict.items()):
        metrics_df.loc[i, "model"] = clf_name
        
        if "f1" in metrics:
            metrics_df.loc[i, "f1"] = metrics["f1"]
            
        if "accuracy" in metrics:
            metrics_df.loc[i, "accuracy"] = metrics["accuracy"] 
            
        if "precision" in metrics:
            metrics_df.loc[i, "precision"] = metrics["precision"]
            
        if "recall" in metrics:
            metrics_df.loc[i, "recall"] = metrics["recall"]
            
        if "confmat" in metrics:
            metrics_df.loc[i, "confusion_matrix"] = metrics["confmat"]
            
        if "true_neg_counts" in metrics:
            metrics_df.loc[i, "true_neg_counts"] = metrics["true_neg_counts"]
            
        if "false_pos_counts" in metrics:
            metrics_df.loc[i, "false_pos_counts"] = metrics["false_pos_counts"]
            
        if "false_neg_counts" in metrics:
            metrics_df.loc[i, "false_neg_counts"] = metrics["false_neg_counts"]
            
        if "true_pos_counts" in metrics:
            metrics_df.loc[i, "true_pos_counts"] = metrics["true_pos_counts"]
            
        if "sensitivity" in metrics:
            metrics_df.loc[i, "sensitivity"] = metrics["sensitivity"]
            
        if "specificity" in metrics:
            metrics_df.loc[i, "specificity"] = metrics["specificity"]
            
        if "MCC" in metrics:
            metrics_df.loc[i, "MCC"] = metrics["MCC"]
            
        if "roc_auc" in metrics:
            metrics_df.loc[i, "roc_auc"] = metrics["roc_auc"]
        
        i += 1

    # For cross validation scores, only keep the metric that was being
    # evaluated        
    if cv_scoring_name is not None:
        metrics_df = metrics_df.loc[:, ["model", cv_scoring_name]]
    
    return( metrics_df )



###############################################################################
# Function: display_roc_curves
###############################################################################
def display_roc_curves(metrics_dict, save_plots):
    """
    Plot the ROC curves for all classifiers considered.
    Also plot the lines for a perfect and a random classifier for comparison.
    
    Parameter:
    metrics_dict: Dictionary of metrics for the classifiers, where
                  key = Name of the classifer, and 
                  value = Dictionary of metrics (metric, value) for the classifier
    save_plots: boolean indicating whether the plots are saved as PNG files,
                or displayed on screen
    """
    
    # Make sure each model will be easily identifiable on the plot
    # Use a set of rainbow colours with varying line styles
    num_colours = len(metrics_dict.keys())
    cmap = plt.get_cmap("nipy_spectral")
    
    rc = {'xtick.labelsize': 16, 'ytick.labelsize': 16}
    sns.set(rc)

    # Start a new plot
    figure = "HD_model_compare-01-ROC_curves.png"

    fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(8, 7.5))
    
    ax.set_title("Receiver Operating Characteristic (ROC) Curve: \nComparison (test set)",
                 fontsize=24)
    ax.set_prop_cycle("color", [cmap(1.*i/num_colours) for i in range(num_colours)])
    
    # Plot the ROC curve for each classifier
    for clf_name, metrics in sorted(metrics_dict.items()):
        fpr = metrics["roc_fpr"]
        tpr = metrics["roc_tpr"]
        
        roc_auc = metrics["roc_auc"]
        
        clf_label = clf_name + " (area = {:.3f})".format(roc_auc)
        ax.plot(fpr, tpr, label=clf_label)
        
    # Plot the ROC curve for a random classifier
    ax.plot([0, 1], [0, 1], linestyle='--', color=(0.6, 0.6, 0.6), 
            label="Random Classifier (area = 0.5)")
    
    # Plot the ROC curve for the perfect classifier
    ax.plot([0, 0, 1], [0, 1, 1], lw=2, linestyle=':', color='black', 
            label="Perfect Performance (area = 1)")


    ax.set_xlabel("False Positive Rate (1-Specificity)", fontsize=20)
    ax.set_ylabel("True Positive Rate (Sensitivity)", fontsize=20)
    ax.legend(loc="lower right", fontsize=15)

    if save_plots:
        plt.savefig(filename = figure, dpi = 600, bbox_inches='tight', pad_inches=0.2)
        plt.close()
    else:
        plt.show()
        
    sns.set()

    return( None )



###############################################################################
# Function: model_comparisons
###############################################################################
def model_comparisons(metrics_train, metrics_cv, metrics_test, cv_scoring_name,
                      save_plots=True):
    """
    Display the scores at each phase for each model being considered.
    Plot the ROC curves for all models based on the test set.
    Return three data frames that store these scores.
    
    Parameters:
    metrics_train: scores for the training set
    metrics_cv: scores from cross validation
    metrics_test: scores for the test set
    cv_scoring_name: Name of the metric used in cross validation
    save_plots: boolean indicating whether the plots are saved as PNG files
                (True), or displayed on screen (False)  (Default: True)
    """
    
    print("\n### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")
    print("###  Final comparisons")
    print("### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###")

    # Evaluation on the Training set
    print("\n-------------------------------")
    print("Evaluation on the training set:")
    print("-------------------------------")
    metrics_train_df = save_classification_metrics(metrics_train)
    print(metrics_train_df)
    
    # Evaluation on the Test set
    print("\n-----------------------------")
    print("Scores from cross validation:")
    print("-----------------------------")
    metrics_cv_df = save_classification_metrics(metrics_cv, cv_scoring_name)
    print(metrics_cv_df)

    # Evaluation on the Test set
    print("\n-----------------------------")
    print("Evaluation on the test set:")
    print("-----------------------------")
    metrics_test_df = save_classification_metrics(metrics_test)
    print(metrics_test_df)
    
    # Plot the ROC curves for all classifiers (test set), and compute the area
    # under the ROC curves
    display_roc_curves(metrics_test, save_plots)

    return metrics_train_df, metrics_cv_df, metrics_test_df

