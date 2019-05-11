
# coding: utf-8

# In[ ]:

# Caner Irfanoglu | A00425840 | Assignment2 | Question2
# For this assignment, I used the Aircraft Event Information from Canadian Open Data Portal
# Preprocessing is done in excel and both files included in submission
# Following questions are answered via using exploratory analysis
        # 1 - How does the number of aircraft events change over the years?
        # 2 - Which provinces are more prone to aircraft events ?
        # 3 - What are the top 10 events that are most observed?


# In[52]:

import pandas as pd
import matplotlib.pyplot as plt
# Loading libraries


# In[12]:

aircraft_raw_path = "./Aircraft_Event_Raw.csv"
aircraft_raw = pd.read_csv(aircraft_raw_path, encoding = 'latin-1')
# Raw dataset
# Downloaded From https://open.canada.ca/data/en/dataset/a348c1d1-2392-4595-b5e2-c6a244a7e87f


# In[14]:

aircraft_raw.head()


# In[17]:

aircraft_path = "./Aircraft_Event_Preprocessed.csv"
aircraft_event = pd.read_csv(aircraft_path,encoding = 'latin-1')
# Preprocesed dataset 


# In[ ]:

##### Data Preprocessing made in Excel #####  
# Actions Taken are as follows:
# 1- Drop the EVENT_NAME_FNM
# 2- Separate CADORSNUMBER to Year | Region_Short | Sequantial_No (See Aircraft_Meta)
# 3- From the Region Abbreviations regions are derived


# In[18]:

aircraft_event.head()


# In[20]:

aircraft_event.describe()
# Data Description


# In[41]:

aircraft_event.groupby(['Year']).count().plot()
plt.title("Number of Total Events over Years")
plt.xlabel("Years")
plt.ylabel("Occurence Counts")
plt.legend().remove()
plt.show()
# Plot total events over the years


# In[122]:

d = {'Region':aircraft_event.Region.unique(), 'Counts':aircraft_event.groupby("Region")["Region"].transform('count').unique()}
df = pd.DataFrame(data=d).sort_values('Counts', ascending = False)
df.plot.bar(x='Region',y="Counts")
plt.title("Events by Regions")
plt.xlabel("Regions")
plt.ylabel("Occurence Counts")
plt.legend().remove()
plt.show()
# Plot distribution of events by regions


# In[118]:

df = aircraft_event.groupby(['EVENT_NAME_ENM']).count().sort_values('EVENT_SEQ_NUM',ascending=False).head(10)
df.plot.bar(x=df.index,y="Region")
plt.title("Most Common Events")
plt.xlabel("Event")
plt.ylabel("Occurence Counts")
plt.legend().remove()
plt.show()

