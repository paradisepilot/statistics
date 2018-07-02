
'''
dummy comment
'''

def cipherCaesar( text , shift ):

    alphabet      = [ chr(index) for index in range(ord('A'),ord('Z')+1) ] 
    alphabet_size = len(alphabet)

    charlist_original = list(text.upper())
    charlist_shifted  = []

    for char in charlist_original:
        if char in alphabet:
            index_shifted = ( alphabet.index(char) + shift ) % alphabet_size
            charlist_shifted.append(alphabet[index_shifted])
        else:
            charlist_shifted.append(char)

    output = ''.join(charlist_shifted)

    return( output )

def ex070():

    print("\n### ~~~~~ Exercise 070 ~~~~~~~~");

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    plaintext  = 'She sells seashells by the sea shore. What a cliche!!!'
    ciphertext = cipherCaesar(text = plaintext,  shift =  3)
    decrypted  = cipherCaesar(text = ciphertext, shift = -3)

    print("plaintext:" )
    print( plaintext   )
    print("ciphertext:")
    print( ciphertext  )
    print("decrypted:" )
    print( decrypted   )

    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
    return( None )

