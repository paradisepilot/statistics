
import os
from urllib import request

def getBigTxt( BigTxtFILE ):
    if os.path.isfile(path = BigTxtFILE) == False :
        print("downloading http://norvig.com/big.txt from Internet ...")
        my_download( url = "http://norvig.com/big.txt" , file = BigTxtFILE )
    return( None )

def getBabyNames( BabyNamesFILE ):
    if os.path.isfile(path = BabyNamesFILE) == False :
        tempURL = "https://raw.githubusercontent.com/hadley/data-baby-names/master/baby-names.csv"
        print("downloading from Internet: " + tempURL)
        my_download( url = tempURL , file = BabyNamesFILE )
    return( None )

###################################################
def my_open(url):
    with request.urlopen(url) as r:
        return r.read()

def my_download(url, file=None):
    tempDIR = os.path.dirname(file)
    if not os.path.exists(tempDIR):
        os.makedirs(tempDIR)
    #if not file:
    #    file = url.split('/')[-1]
    with open(file, 'wb') as f:
        f.write(my_open(url))

