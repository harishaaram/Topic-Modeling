# Objective:
1. Understand the relative proportions of concepts through time - using Latent Dirichlet Allocation (LDA).
2. Determine the influence of different policymakers on the minutes of meeting data - using Latent Semantic Analysis (LSA).

# Team:
    1. Harish Gandhi Ramachandran - Master's in computer science
    2. Dan De-Rose Jr - Master's in Fiance

# Key concepts:
*Unsupervised learning, Topic-modeling, Text-analysis, Latent Dirichlet Allocation(LDA), Latent semantic analysis(LSA), Natural Language Processing(NLP)*


# Problem
The last decade has seen central banks gain prominence in markets. The financial crisis required central banks to ride to the rescue
of the financial system. Since then, Fed watching, the art of discerning the Fed’s intentions, has moved from the confines of the
urbane to front page news. This transition was prominently declared when **Ben Bernanke**, the previous Chairman of the Federal
Reserve Board, gave his last speech on January 3rd, 2014 in which he insisted, 

> “ ​The Fed must continue to find ways to navigate
this ​ ​changing ​ ​environment ​ ​while ​ ​providing ​ ​clear, ​ ​objective, ​ ​and ​ ​reliable ​ ​information ​ ​to ​ ​the ​ ​public ​.” ​

Text analysis is an ideal way to discern the exact intentions of a corpus, or body of documents. It’s possible, as often happens, when
one read’s a text, their perception is inhibited by their current biases. As discussed prominently in behavioral economics,
confirmation bias is one of the strongest biases and most difficult to overcome. In this way, LDA and LSA can be tools to
understand with precision what the exact implications of a text are. In the following sections we will talk about the data exploration
and text analysis of the meeting documents, which are called minutes. In addition, we explore the speeches of the policy makers and
how ​ ​it ​ ​impacts ​ ​the ​ ​minutes.


# Datasource:
1. [Archive fed minutes data](https://www.federalreserve.gov/monetarypolicy/fomc_historical_year.htm)


# Language:
1. **R** - *for analysis*
2. **Python 3** - *for data extraction from website*


# The Approach
1. Collect relevant text information from the articles.
2. Build a text corpus and Document Term Matrix.
3. Preprocess the data through removing stopwords, stemming etc.
4. Perform optimal clustering using NbClust kmeans method, to get the optimum concepts.
5. Perform LDA to identify top terms of the topics/concepts.
6. Create a LSA space to track whose words matter more to the outcome of the meetings.

#### [Link to the Walkthrough of the Solution](http://nbviewer.jupyter.org/github/harishaaram/Topic-Modeling/blob/master/Text_Analysis_Fedspeech.ipynb)

[Link to Research Paper](resource/AdvancedDataMining.pdf)



