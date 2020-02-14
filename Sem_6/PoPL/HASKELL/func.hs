doubleMe x = x + x
doubleUs x y = x*2 + y*2 
doubleSmallNumber x = if x > 100  
                        then x  
                        else x*2 

addThree :: Int -> Int -> Int -> Int 
addThree x y z = x + y + z 

describeList :: [a] -> String  
describeList xs = "The list is " ++ case xs of [] -> "empty."  
                                               [x] -> "a singleton list."   
                                               xs -> "a longer list."



maximum' :: (Ord a) => [a] -> a  
maximum' [] = error "maximum of empty list"  
maximum' [x] = x  
maximum' (x:xs) = max x (maximum' xs)

 
main = print (describeList "pp")





