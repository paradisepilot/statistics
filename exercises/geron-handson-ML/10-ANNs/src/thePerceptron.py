
import numpy as np
from sklearn.linear_model import Perceptron

def thePerceptron( irisData ):

    print("\n####################")
    print("thePerceptron():\n")

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    X = irisData.data[:,(2,3)]
    y = (irisData.target == 0).astype(np.int)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myPerceptron = Perceptron(random_state=1234567)
    myPerceptron.fit(X,y)

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    y_predicted = myPerceptron.predict([[2,0.5]])
    print( "y_predicted = " + str(y_predicted) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    print("\nexiting: thePerceptron()")
    print("####################")
    return( None )

