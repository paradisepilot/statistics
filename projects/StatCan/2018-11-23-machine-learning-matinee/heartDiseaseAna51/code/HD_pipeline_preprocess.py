###############################################################################
# Supervised Machine Learning Pipeline Example:
#              Heart Disease classification using Tree-based methods
#
# Author: Joanne Leung (BSMD)
# February 23, 2018
#
# File: HD_pipeline_preprocessing.py
# 
###############################################################################
#
# The HD_pipeline_preprocess module spells out the steps for the preprocessing 
# of the Heart Disease data.
#
###############################################################################

# Import the required modules
import numpy as np
import pandas as pd

from sklearn.base          import BaseEstimator, TransformerMixin
from sklearn.pipeline      import FeatureUnion, Pipeline
from sklearn.preprocessing import Imputer, LabelBinarizer

from CategoricalEncoder import CategoricalEncoder

###############################################################################
# Select columns
class VarSelector(BaseEstimator, TransformerMixin):
    
    def __init__(self, columns):
        self.columns = columns
        
    def fit(self, X, y=None):
        return self
    
    def transform(self, X):
        df = pd.DataFrame(X[self.columns], columns=self.columns)
        return df
    
###############################################################################
# Replace Question Marks with NaN
class ReplaceQuestionMarks(BaseEstimator,TransformerMixin):
    
    def __init__(self):
        pass
    
    def fit(self, X, y=None):
        return self
    
    def transform(self, X):
        for var in X.columns:
            X.loc[:, var] = X.loc[:, var].replace("?", np.nan)
        return X

###############################################################################
# Create a data frame
class FeatureDF(BaseEstimator, TransformerMixin):
    
    def __init__(self, columns):
        self.columns = columns
        
    def fit(self, X, y=None):
        return self
    
    def transform(self, X):
        df = pd.DataFrame(X, columns=self.columns)
        return df

###############################################################################
# Drop features from the data frame
class DropFeatures(BaseEstimator, TransformerMixin):
    
    def __init__(self, columns):
        self.columns = columns
        
    def fit(self, X, y=None):
        return self
    
    def transform(self, X):
        df = X.drop(labels=self.columns, axis=1)
        return df

        
###############################################################################
#
# Pre-processing: (1) Imputation of missing values
#
###############################################################################
# Establish a strategy to impute each variable, in case there are any missing 
# values identified by "?"
#
# age: median
# sex: most_frequent
# chest_pain_type: most_frequent
# rest_bp: median
# cholesterol: median
# fast_blood_sugar: most_frequent
# rest_ecg: most_frequent
# max_hr_achieved: median
# exer_induced_angina: most_frequent
# old_peak = median
# slope = most_frequent
# coloured_vessels = most_frequent
# thal = most_frequent

median_cols = ["age", "rest_bp", "cholesterol", "max_hr_achieved", "old_peak"]
most_freq_cols = ["sex", "chest_pain_type", "fast_blood_sugar", "rest_ecg", 
                  "exer_induced_angina", "slope", "coloured_vessels", "thal"]

# Replace missing values in all columns

# (1a) Imputation by median (numeric variables):
# 1. Select the variables using the column names
# 2. Replace ? by NaN
# 3. Imputation using the median
_pp_impute_median = Pipeline([
        ('selector',    VarSelector(columns=median_cols)),
        ('replacement', ReplaceQuestionMarks()),
        ('imputer',     Imputer(strategy='median'))
        ])

# (1b) Imputation by the most frequent category (categorical variables):
# 1. Select the variables using the column names
# 2. Replace ? by NaN
# 3. Imputation using the mode
_pp_impute_mode = Pipeline([
        ('selector',    VarSelector(columns=most_freq_cols)),
        ('replacement', ReplaceQuestionMarks()),
        ('imputer',     Imputer(strategy='most_frequent'))
        ])

# (1) Impute all variables and put them back together:
# (1a) Imputation by median (numeric variables)
# (1b) Imputation by the most frequent category (categorical variables)
# FeatureUnion puts the columns from (1a) and (1b) together and returns a
# numpy array
impute_missing = FeatureUnion(transformer_list=[
        ('pp_impute_median', _pp_impute_median),
        ('pp_impute_mode',   _pp_impute_mode)
        ])

###############################################################################
#
# Pre-processing: 
# (2) Creation of dummy variables for nominal categorical variables
#
###############################################################################
# Nominal categorical variables: create dummy variables
# (2a) Variable: thal
# 1. Select the variable using column name
# 2. Create dummy variables for this categorical variable
_pp_thal = Pipeline([
        ('selector',    VarSelector(columns=["thal"])),
        ('cat_encoder', CategoricalEncoder(encoding="onehot-dense"))
        ])

# (2b) Variable: chest_pain_type
# 1. Select the variable using column name
# 2. Create dummy variables for this categorical variable
_pp_chest_pain_type = Pipeline([
        ('selector',    VarSelector(columns=["chest_pain_type"])),
        ('cat_encoder', CategoricalEncoder(encoding="onehot-dense"))
        ])

# (2c) Variable: rest_ecg
# 1. Select the variable using column name
# 2. Create dummy variables for this categorical variable
_pp_rest_ecg = Pipeline([
        ('selector',    VarSelector(columns=["rest_ecg"])),
        ('cat_encoder', CategoricalEncoder(encoding="onehot-dense"))
        ])

# (2d) Variable: slope    
# 1. Select the variable using column name
# 2. Create dummy variables for this categorical variable
_pp_slope = Pipeline([
        ('selector',    VarSelector(columns=["slope"])),
        ('cat_encoder', CategoricalEncoder(encoding="onehot-dense"))
        ])

# (2e): All other variables that require no dummies (simply return the columns)
# 1. Simply select the columns
no_dummies_cols = ["age", "rest_bp", "cholesterol", "max_hr_achieved", 
                   "old_peak", "sex", "fast_blood_sugar", "exer_induced_angina", 
                   "coloured_vessels"]

_pp_no_dummies = Pipeline([
        ('selector', VarSelector(columns=no_dummies_cols))
        ])

# (2) Put all variables together
# (2a) Variable: thal
# (2b) Variable: chest_pain_type
# (2c) Variable: rest_ecg
# (2d) Variable: slope    
# (2e): All other variables that require no dummies (simply return the columns)
# FeatureUnion puts the columns from (1a) and (1b) together and returns a
# numpy array
preprocess_categories = FeatureUnion(transformer_list=[
        ('pp_no_dummies',      _pp_no_dummies),
        ('pp_thal',            _pp_thal),
        ('pp_chest_pain_type', _pp_chest_pain_type),
        ('pp_rest_ecg',        _pp_rest_ecg),
        ('pp_slope',           _pp_slope)
        ])



###############################################################################
#
# Preprocesing: (1) Imputation then (2) Creation of dummy variables
#
###############################################################################
dummy_all_cols = ["thal_3", "thal_6", "thal_7",
                  "chest_pain_type_1", "chest_pain_type_2", "chest_pain_type_3", "chest_pain_type_4",
                  "rest_ecg_0", "rest_ecg_1", "rest_ecg_2",
                  "slope_1", "slope_2", "slope_3"]

# Grab the numpy array from imputation, then add back the column names to get
# a Pandas data frame.  Then use this data frame to preprocess the categories.

# 1. (1) Imputation
# 2. Add back column names and create a data frame
# 3. (2) Creation of dummy variables
# 4. Add back column names and create a data frame
preprocess_all = Pipeline([
        ('pp_impute_all', impute_missing),
        ('feature_DF1',   FeatureDF(columns=np.append(median_cols, most_freq_cols))),
        ('pp_dummies',    preprocess_categories),
        ('feature_DF2',   FeatureDF(columns=np.append(no_dummies_cols, dummy_all_cols)))
        ])


###############################################################################
#
# Option for dropping the first dummy variable for each categorical variable
#
###############################################################################
dummy_first_cols = ["thal_3", 
                  "chest_pain_type_1", 
                  "rest_ecg_0", 
                  "slope_1"]

# Preprocess all steps, but remove the first dummy of each nominal categorical
# variable.
preprocess_all_drop_first = Pipeline([
        ('pp_all',     preprocess_all),
        ('drop_first', DropFeatures(columns=dummy_first_cols))
        ])
