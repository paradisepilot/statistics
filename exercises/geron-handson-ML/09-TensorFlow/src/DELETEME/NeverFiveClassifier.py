
import numpy as np
from sklearn.base import BaseEstimator

class NeverFiveClassifier(BaseEstimator):
    def fit(self,X,y=None):
        return self
    def predict(self,X):
        return np.zeros((len(X),1),dtype=bool)

