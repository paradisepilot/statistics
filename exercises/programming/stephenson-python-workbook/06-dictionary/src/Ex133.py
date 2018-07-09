
'''
dummy comment
'''

def numInEnglish( x ):

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    dict_100 = {
        0 : '',
        1 : 'one',
        2 : 'two',
        3 : 'three',
        4 : 'four',
        5 : 'five',
        6 : 'six',
        7 : 'seven',
        8 : 'eight',
        9 : 'nine'
        }

    dict_010 = {
        0 : '',
        2 : 'twenty',
        3 : 'thirty',
        4 : 'forty',
        5 : 'fifty',
        6 : 'sixty',
        7 : 'seventy',
        8 : 'eighty',
        9 : 'ninety'
        }

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    d001 = x % 10
    d010 = int((x - (x %  10))/ 10) % 10
    d100 = int((x - (x % 100))/100) % 10

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if d100 > 0:
        s100 = dict_100[d100] + " hundred"
    else:
        s100 = ""

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if 1 == d010:
        if   1 == d001:
            s011 = 'eleven'
        elif 2 == d001:
            s011 = 'twelve'
        elif 3 == d001:
            s011 = 'thirteen'
        elif 4 == d001:
            s011 = 'fourteen'
        elif 5 == d001:
            s011 = 'fifteen'
        elif 6 == d001:
            s011 = 'sixteen'
        elif 7 == d001:
            s011 = 'seventeen'
        elif 8 == d001:
            s011 = 'eighteen'
        elif 9 == d001:
            s011 = 'nineteen'
    else:
        if d001 > 0:
            s011 = dict_010[d010] + " " + dict_100[d001]
        elif d010 > 0:
            s011 = dict_010[d010]
        else:
            s011 = ''

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    s100 = s100.strip()
    s100 = s100.lstrip()

    s011 = s011.strip()
    s011 = s011.lstrip()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    if 0 == x:
        output = 'zero'
    elif (0 != d100) & (0 == d010) & (0 != d001):
        output = s100 + " and " + s011
    else:
        output = s100 + " " + s011

    output = output.strip()
    output = output.lstrip()

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( output )

def ex133():

    print("\n### ~~~~~ Exercise 133 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    myIntegers = [
          0,
          1,   2,   5,  15,  25,  35,  85,  95, 100,
        101, 105, 111, 112, 113, 114, 115, 121, 131, 195, 200,
        201, 211, 212, 213, 218, 225,
        805, 811, 812, 813, 814, 815, 825, 865, 895, 899,
        905, 911, 912, 913, 914, 915, 925, 965, 995, 999
        ]
    for myInteger in myIntegers:
        # print( str(myInteger) + " = " + numInEnglish(myInteger) )
        print( "%3d = %s" % (myInteger,numInEnglish(myInteger)) )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

