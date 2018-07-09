
from sklearn.tree import DecisionTreeRegressor, export_graphviz

##############################
def irisRegressionTree( irisData ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X = irisData.data[:,2:] # petal length and width
    y = irisData.target

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myTreeRegressor = DecisionTreeRegressor(max_depth=2)
    myTreeRegressor.fit(X,y)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    export_graphviz(
        myTreeRegressor,
        out_file      = "iris-regression-tree.dot",
        feature_names = irisData.feature_names[2:],
        class_names   = irisData.target_names,
        rounded       = True,
        filled        = True
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

##############################

