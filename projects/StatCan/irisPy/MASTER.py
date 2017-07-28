#!/usr/bin/env python
import os, sys, shutil, getpass
import pprint, logging, datetime
import stat

thisScript = sys.argv[0]
dir_MASTER = os.path.dirname(os.path.realpath(sys.argv[0]))
dir_code   = os.path.join(dir_MASTER, "code")
dir_data   = os.path.join(dir_MASTER, "data")
dir_output = os.path.join(dir_MASTER, "output." + getpass.getuser())

if not os.path.exists(dir_output):
    os.makedirs(dir_output)

os.chdir(dir_output)
sys.stdout = open('log.stdout','w')
myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime )

logging.basicConfig(filename='log.debug',level=logging.DEBUG)

shutil.copy2( src = os.path.join(dir_MASTER,thisScript), dst = dir_output )
shutil.copytree(src = dir_code, dst = os.path.join(dir_output,"code"))

print('\nthisScript')
print(   thisScript )

print('\ndir_code')
print(   dir_code )

print('\ndir_output')
print(   dir_output )

##################################################
sys.path.append(dir_code)
import wordcloud
from wordcloud import WordCloud, STOPWORDS

myText    = open(os.path.join(dir_data, '12-539-x2009001-eng.txt')).read()
stopWords = set(STOPWORDS)

myWordCloud = WordCloud(
    background_color = "white",
    max_words = 2000,
    stopwords = stopwords
    )

myWordCloud.generate(myText)

myWordCloud.to_file("word-cloud-py.png")

##################################################

pprint.pprint(sys.modules)

myTime = "system time: " + datetime.datetime.now().strftime("%c")
print( myTime )

