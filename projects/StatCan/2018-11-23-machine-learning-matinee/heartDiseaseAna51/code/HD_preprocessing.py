###############################################################################
# Supervised Machine Learning Pipeline Example:
#              Heart Disease classification using Tree-based methods
#
# Author: Joanne Leung (BSMD)
# February 23, 2018
#
# File: HD_preprocessing.py
# 
###############################################################################
#
# The HD_preprocessing module contains functions that read, examine and
# visualize the data set.  It has a function that splits the data into a
# training and a test set.  It also contains a function that does pre-processing,
# where the detailed steps for pre-processing is defined in the a separate 
# module called HD_pipeline_preprocess.
#
###############################################################################

# Import the required modules
import numpy   as np
import pandas  as pd

import matplotlib.pyplot as plt
import seaborn as sns

from math import ceil

from sklearn.model_selection import train_test_split

from HD_pipeline_preprocess import preprocess_all
from HD_pipeline_preprocess import preprocess_all_drop_first

###############################################################################
# Function: read_heart_file
###############################################################################
def read_heart_file(csv_file):
    """
    Load the data and add the column names into a dataframe object.
    
    Parameter:
    csv_file = full file path and filename of the heart disease data set
    """
    # Read the comma-delimited file
    csv = pd.read_csv(csv_file, header=None)

    # Set up the column names
    csv.columns = ["age", 
                   "sex", 
                  "chest_pain_type", 
                  "rest_bp", 
                  "cholesterol", 
                  "fast_blood_sugar",
                  "rest_ecg", 
                  "max_hr_achieved",
                  "exer_induced_angina", 
                  "old_peak", 
                  "slope", 
                  "coloured_vessels", 
                  "thal", 
                  "diagnosis"]
       
    # Group target (diagnosis) 1-4 as 1 (presence of heart disease)
    # presence: Diagnosis of heart disease (angiographic disease status) 
    #          (categorical)
    csv["presence"] = csv["diagnosis"] > 0
  
    # Drop the diagnosis variable
    csv = csv.drop(["diagnosis"], axis=1)
    
    return csv



###############################################################################
# Function: examine_heart_data
###############################################################################
def examine_heart_data(dataset):
    """
    Perform basic data exploration.
    """
    
    # Dimension of the data set (rows, cols)
    print("\ndataset.shape")
    print("The data set has {0} rows and {1} columns.".format(
            dataset.shape[0], dataset.shape[1]))

    # List of variables, number of records, and variable type
    # (like Proc Contents in SAS)
    print("\ndataset.info()")
    print(   dataset.info() )
    
    # Print the first five rows of the dataset
    print("\ndataset.head()")
    print(   dataset.head() )
 
    # Print the last five rows of the dataset
    print("\ndataset.tail()")
    print(   dataset.tail() )

    # Print descriptive statistics of the dataset (numerical variables only)
    # (like Proc Means in SAS)    
    print("\ndataset.describe()")
    print(   dataset.describe() )

    # Inspect the contents for the target variable 
    print('\ndataset["presence"].value_counts()')
    print(   dataset["presence"].value_counts() )
    
    return( None )



###############################################################################
# Function: split_dataset
###############################################################################
def split_dataset(X, y, stratify, test_size, random_state):
    """
    Splits the data into training and test sets according to test_size.
    The split is stratified by the "stratify" variable.
    
    Parameters:
    X: data frame that contains the features
    y: data frame that contains the target variable
    stratify: name of the variable used as strata
    random_state: Pseudo-random number generator state used for random sampling
    """
    # Split the data using the train_test_split function in scikit-learn
    X_train, X_test, y_train, y_test = train_test_split(X, y, 
                                                        test_size = test_size, 
                                                        stratify = stratify,
                                                        random_state = random_state)

    print("\nSplitting the data into training set and test set...")
    print("Number of records in the full data set: {}".format(X.shape[0]))
    print("Number of records in the training set: {}".format(X_train.shape[0]))
    print("Number of records in the test set: {}".format(X_test.shape[0]))


    # verification
    full_X = pd.concat((X_train, X_test), axis=0)
    full_y = pd.concat((y_train, y_test), axis=0)
    full = pd.concat((full_X, full_y), axis=1)
    
    training = pd.concat((X_train, y_train), axis=1)
    test = pd.concat((X_test, y_test), axis=1)
    
    print("\nClass distribution in full data set:")
    print(   full.groupby("presence").size() )

    print("\nClass distribution in training set:")
    print(   training.groupby("presence").size() )

    print("\nClass distribution in test set:")
    print(   test.groupby("presence").size() )

    return X_train, X_test, y_train, y_test



###############################################################################
# Function: visualize_heart_data
###############################################################################
def visualize_heart_data(dataset, save_plots=True):
    """
    Look at some basic descriptive statistics for the heart disease data set.
    Generate histograms for continuous variables and bar charts for categorical
    variables.  Compute and produce a heat map plot for the correlation matrix.
    
    The code for producing plot of correlation matrix is adapted from
    the following example on the Seaborn package's website:
    https://seaborn.pydata.org/examples/many_pairwise_correlations.html
    
    Parameters:
    dataset: data frame that contains the data to be visualized
    save_plots: boolean indicating whether the plots are saved as PNG files,
                or displayed on screen (Default: True)
    """
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### Create basic plots for each variable
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # Split the variables into continous (cts) and categorical (cat) variables 
    cts_vars = ["age", "rest_bp", "cholesterol", 
                "max_hr_achieved", "old_peak"]
    cat_vars = ["sex", "chest_pain_type", "fast_blood_sugar", 
                "rest_ecg", "exer_induced_angina", "slope", 
                "coloured_vessels", "thal", "presence"]
        
    # Default Seaborn plots setting
    sns.set()
  
    # Create histograms for continous variables  
    figure1 = "HD_preprocessing-01-visualize_continuous_variables.png"
    
    dataset[cts_vars].hist(bins = 15, figsize = (9, 6), layout=(2, 3))
    plt.subplots_adjust(wspace=0.4, hspace=0.4)
    
    if save_plots:
        plt.savefig(figure1, dpi = 600, bbox_inches='tight', pad_inches=0.1)
        plt.close()
    else:
        plt.show()
    
    # Create bar charts for categorical variables
    figure2 = "HD_preprocessing-02-visualize_categorical_variables.png"
    ncols = 3
    nrows = int(ceil(len(cat_vars)/ncols))
    
    fig, ax = plt.subplots(nrows=nrows, ncols=ncols, figsize=(3*ncols, 2.25*nrows))

    i = 0
    j = 0
    for var in cat_vars:
        sns.countplot(x=var, data=dataset, ax=ax[i][j])
        ax[i][j].set_title(var)
        ax[i][j].set_xlabel("")
        ax[i][j].set_ylabel("")
        j += 1
        
        if j == 3:
            j = 0
            i += 1

    plt.subplots_adjust(wspace=0.3, hspace=0.5)

    if save_plots:    
        plt.savefig(figure2, dpi = 600, bbox_inches='tight', pad_inches=0.1)
        plt.close()
    else: 
        plt.show()
    
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### Pairplots to examine pairwise relationships between features and target
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    # Look at all numeric variables
    figure3 = "HD_preprocessing-03-pairplots_continuous_variables.png"

    # Move the legend so that it does not overlaps with the plots    
    g = sns.pairplot(data=dataset, vars=cts_vars, hue="presence")
    
    g.fig.get_children()[-1].set_bbox_to_anchor((1.05, 0.5, 0, 0))

    if save_plots:    
        plt.savefig(figure3, dpi = 600, bbox_inches='tight', pad_inches=0.1)
        plt.close()
    else: 
        plt.show()
 
    
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    ### Correlation matrix
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    corr = dataset.corr()    
    
    # Plot the correlation matrix
    figure4 = "HD_preprocessing-04-correlation_matrix.png"
    
    sns.set()
    fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(12, 9))
    fig.suptitle("Heart Disease: correlation matrix", fontsize=20)
    
    # Generate a mask for the upper triangle
    mask = np.zeros_like(corr, dtype=np.bool)
    mask[np.triu_indices_from(mask)] = True
    
    # Generate a custom diverging colormap
    cmap = sns.diverging_palette(220, 10, as_cmap=True)
    
    # Draw the heatmap with the mask and correct aspect ratio
    sns.heatmap(corr, mask=mask, cmap=cmap, vmax=0.6, center=0, 
                square=True, annot=True, linewidths=1.5, ax=ax)
    plt.yticks(rotation=0, fontsize=12)
    plt.xticks(rotation="vertical", fontsize=12)

    if save_plots:    
        plt.savefig(figure4, dpi = 600, bbox_inches='tight', pad_inches=0.2)
        plt.close()
    else:
        plt.show()


    return( None )



###############################################################################
# Function: preprocess_X
###############################################################################
def preprocess_X(dataset, train_flag=False, drop_first=True):
    """
    Preprocess the features
    (1) Impute missing values
    (2) Create dummy variables for nominal categorical variables.  Drop the
        first dummy category if needed.

    If it is the training set, use fit_transform.
    If it is the test set, use transform so that it uses values fitted
    from the training set.
    
    Parameters:
    dataset: data frame that contains the data to be pre-processed
    train_flag: boolean indicating whether the data set is training data
                (Default: False)
    drop_first = booldean indicating whether the first dummy category will be 
                 dropped for nominal categorical variables (Default: True)
    """   
    
    # Pre-processing for training set
    if train_flag:
        if drop_first:
            pp_X = preprocess_all_drop_first.fit_transform(dataset)
        else:
            pp_X = preprocess_all.fit_transform(dataset)
    # Pre-processing for test set
    else:
        if drop_first:
            pp_X = preprocess_all_drop_first.transform(dataset)
        else:
            pp_X = preprocess_all.transform(dataset)

    # keep the original index            
    new_dataset = pd.DataFrame(np.array(pp_X), columns=pp_X.columns, index=dataset.index)
    
    return new_dataset



