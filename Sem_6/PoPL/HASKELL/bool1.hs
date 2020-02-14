(&&!) :: Bool -> Bool -> Bool
True  &&! True  = True
True  &&! False = False
False &&! True  = False
False &&! False = False


--main = print (('H' == 'i') &&! ('a' == 'm'))

main = print (False &&  (head [] == 'x'))
