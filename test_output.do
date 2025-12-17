* Test findar output completeness
clear all

* Test 1: Basic search with simplified output
findar deep learning, maxresults(3)

* Test 2: Detailed output
findar machine learning, maxresults(2) detail

* Test 3: With abstract
findar neural network, maxresults(2) abstract

di as txt _n "All tests completed!"
