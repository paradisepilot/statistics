
from sklearn.tree import DecisionTreeClassifier, export_graphviz

##############################
def trainVisualizeTree( irisData ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X = irisData.data[:,2:] # petal length and width
    y = irisData.target

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myTreeClassifier = DecisionTreeClassifier(max_depth=2)
    myTreeClassifier.fit(X,y)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    export_graphviz(
        myTreeClassifier,
        out_file      = "iris_tree.dot",
        feature_names = irisData.feature_names[2:],
        class_names   = irisData.target_names,
        rounded       = True,
        filled        = True
        )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

##############################

