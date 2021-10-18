Group Number:- 2

Python Version:- 3.7
Python Libraries Used:- os, sys, re, pickle, nltk
Libraries that need to be installed:- nltk
Nltk datasets needed:- stopwords, punkt

Time Needed for Indexer:- ~1hr
Time Needed for Parser:- ~1s
Time Needed for Searching:- ~20s

Formats
1. Inverted Index:-
    key1 -> [[docId1, freq1], [docId2, freq2], ..., [docIdN, freqN]]
    key2 -> [[docId1, freq1], [docId2, freq2], ..., [docIdN, freqN]]
    .
    .
    .
    keyM -> [[docId1, freq1], [docId2, freq2], ..., [docIdN, freqN]]

2. Queries:-
    <queryId>, <Parsed Query>

3. Results:-
    <queryId>: docId1 docId2 ... docIdN
 