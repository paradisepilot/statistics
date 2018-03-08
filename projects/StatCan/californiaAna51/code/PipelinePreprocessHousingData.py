
import numpy as np

from sklearn.base          import BaseEstimator, TransformerMixin
from sklearn.pipeline      import FeatureUnion, Pipeline
from sklearn.preprocessing import Imputer, OneHotEncoder, StandardScaler

from CategoricalEncoder import CategoricalEncoder

class DTypeSelector(BaseEstimator,TransformerMixin):
    def __init__(self,dType):
        self.dType = dType
    def fit(self,X,y=None):
        return self
    def transform(self,X):
        return X.select_dtypes(include=[self.dType]).values

class DerivedAttributesAdder(BaseEstimator,TransformerMixin):
    def __init__(self, addBedroomsPerRoom = True, idx_rooms = 3, idx_bedrooms = 4, idx_population = 5, idx_household = 6):
        self.addBedroomsPerRoom = addBedroomsPerRoom
        self.idx_rooms          = idx_rooms
        self.idx_bedrooms       = idx_bedrooms
        self.idx_population     = idx_population
        self.idx_household      = idx_household
    def fit(self,X,y=None):
        return self
    def transform(self,X,y=None):
        roomsPerHousehold      = X[:,self.idx_rooms]      / X[:,self.idx_household]
        populationPerHousehold = X[:,self.idx_population] / X[:,self.idx_household]
        Xaugmented             = np.c_[X,roomsPerHousehold,populationPerHousehold]
        if self.addBedroomsPerRoom:
            bedroomsPerRoom = X[:,self.idx_bedrooms] / X[:,self.idx_rooms]
            Xaugmented      = np.c_[Xaugmented,bedroomsPerRoom]
        return Xaugmented

_ppNumeric = Pipeline([
    ('selector',    DTypeSelector(dType='floating')),
    ('imputer',     Imputer(strategy='median')     ),
    ('atrribAdder', DerivedAttributesAdder()       ),
    ('stdScaler',   StandardScaler()               )
    ])

_ppCategorical = Pipeline([
    ('selector',    DTypeSelector(dType='object')),
    ('cat_encoder', CategoricalEncoder(encoding="onehot-dense"))
    ])

PipelinePreprocessHousingData = FeatureUnion([
    ('pipelineNumeric',     _ppNumeric    ),
    ('pipelineCategorical', _ppCategorical)
    ])

