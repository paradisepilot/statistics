
'''
dummy comment
'''


import re

def getDictChar2Point():

    dict_point2chars = {
         1 : [ 'A', 'E', 'I', 'L', 'N', 'O', 'R', 'S', 'T' , 'U' ],
         2 : [ 'D', 'G'                                          ],
         3 : [ 'B', 'C', 'M', 'P'                                ],
         4 : [ 'F', 'H', 'V', 'W', 'Y'                           ],
         5 : [ 'K'                                               ],
         8 : [ 'J', 'X'                                          ],
        10 : [ 'Q', 'Z'                                          ]
        }

    dict_char2point = {}
    for pt in dict_point2chars.keys():
        for char in dict_point2chars[pt]:
            dict_char2point[char] = pt

    return( dict_char2point )

def getScore( w ):
    charlist = list( re.sub(string = w.upper(), pattern = "[^A-Z]", repl = "") )
    dict_char2point = getDictChar2Point()
    score = sum([ dict_char2point[char] for char in charlist ])
    return( score )

def ex137():

    print("\n### ~~~~~ Exercise 137 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    words = [
        'python',
        'mathematics',
        'apple',
        'Boy, :# that !! was ?? difficult !!!!!'
        ]

    for word in words:
        print( word + ": " + str(getScore(word)) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

