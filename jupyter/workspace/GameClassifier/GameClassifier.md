
# Game Classifier

## Software prerequisite

Import all the modules needed for the whole process.


```python
# Python built-ins
from collections import Counter
import hashlib
import os
import pickle
import subprocess
import sys
import xml.etree.ElementTree as ET
# third party modules
from keras import optimizers
from keras.applications.vgg16 import preprocess_input
from keras.applications.vgg16 import VGG16
from keras.layers import Dense, Activation
from keras.models import load_model
from keras.models import Sequential
from keras.preprocessing import image
import numpy as np
from sklearn.preprocessing import MultiLabelBinarizer
```

    Using TensorFlow backend.


Define some user arguments.


```python
DOWNLOADS = './downloads' # Where is the downloads
GAME_START_ID = 1 # Game ID to start with
GAME_END_ID = 6000 # Game ID to end with
```

Copy some functions from download.py so it can understand the downloads.


```python
def parseGameInfo(id, location, filename='info', allow=False):
    result = {'id':id}
    filepath = os.path.join(location, filename)
    if not os.path.isfile(filepath):
        print('File {} is missing'.format(filepath))
        if not allow:
            sys.exit(1)
        return result
    tree = ET.parse(filepath)
    root = tree.getroot()
    for child in root:
        if child.tag == 'baseImgUrl':
            result['baseImgUrl'] = child.text
        if child.tag == 'Game':
            for childChild in child:
                if childChild.tag == 'GameTitle':
                    result['GameTitle'] = childChild.text
                elif childChild.tag == 'Platform':
                    result['Platform'] = childChild.text
                elif childChild.tag == 'Overview':
                    result['Overview'] = childChild.text
                elif childChild.tag == 'Platform':
                    result['Platform'] = childChild.text
                elif childChild.tag == 'Genres':
                    result['Genres'] = []
                    for childChildChild in childChild:
                        if childChildChild.tag == 'genre':
                            result['Genres'].append(childChildChild.text)
                elif childChild.tag == 'Images':
                    result['Images'] = []
                    for childChildChild in childChild.iter(tag='screenshot'):
                        for childChildChildChild in childChildChild.iter(tag='original'):
                            result['Images'].append(childChildChildChild.text)
    return result

def hashURL(url):
    m = hashlib.md5()
    m.update(url.encode('utf-8'))
    return m.hexdigest()
```

Define more functions that will be used when building and trying the model


```python
model = VGG16(weights='imagenet', include_top=False)
def extractFeatureFromImage(filepath):
    global model
    img = image.load_img(filepath, target_size=(224, 224))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    features = model.predict(x)
    return features.reshape(1,-1)
```

## Dataset information

Let us see how much information we have collected.


```python
metaData = []
totalGames = 0
totalImages = 0
for i in range(GAME_START_ID, GAME_END_ID+1):
    info = parseGameInfo(i, os.path.join(DOWNLOADS, str(i)))
    if 'Genres' in info and len(info.get('Images', [])) != 0:
        metaData.append(info)
        totalGames += 1
        totalImages += len(info['Images'])
print('Total games collected: {}'.format(totalGames))
print('Total images collected: {}'.format(totalImages))
```

    Total games collected: 1509
    Total images collected: 3636


Let us find out how many unique genres they belong to.


```python
genres = []
for info in metaData:
    if 'Genres' not in info:
        print(info)
        break
    genres.extend(info['Genres'])
genres = Counter(genres)
genreList = list(genres.keys())
genreList.sort()
numGenres = len(genreList)
print('{} genres with occurance:'.format(numGenres))
print(dict(genres))
```

    19 genres with occurance:
    {'Shooter': 300, 'Action': 646, 'Flight Simulator': 17, 'Adventure': 283, 'Sandbox': 12, 'Racing': 88, 'Role-Playing': 157, 'Horror': 29, 'Fighting': 106, 'Platform': 227, 'Sports': 118, 'Strategy': 85, 'Stealth': 14, 'MMO': 5, 'Construction and Management Simulation': 16, 'Puzzle': 100, 'Vehicle Simulation': 3, 'Music': 5, 'Life Simulation': 9}


Helper functions to convert from genre to genre id and vice verse


```python
def genreToID(genre):
    return genreList.index(genre)

def idToGenre(id):
    return genreList[id]
```

## Data pre-processing

### Go straight to the section Try the model if you want to skip the time consuming part of training the model

Extract the features from the images based on the pre-trained network.


```python
feature_list=[]
genre_list=[]
i = 0
for info in metaData:
    for imageUrl in info['Images']:
        i += 1
        url = info['baseImgUrl'] + imageUrl
        filepath = os.path.join(DOWNLOADS, str(info['id']), 'images', hashURL(url))
        features = extractFeatureFromImage(filepath)
        feature_list.append(features)
        genre_list.append([genreToID(x) for x in info['Genres']])
        if i % 100 == 0:
            print('Finished {} images'.format(i))
        # break # Uncomment it if you only want one image for each game.
```

    Finished 100 images
    Finished 200 images
    Finished 300 images
    Finished 400 images
    Finished 500 images
    Finished 600 images
    Finished 700 images
    Finished 800 images
    Finished 900 images
    Finished 1000 images
    Finished 1100 images
    Finished 1200 images
    Finished 1300 images
    Finished 1400 images
    Finished 1500 images
    Finished 1600 images
    Finished 1700 images
    Finished 1800 images
    Finished 1900 images
    Finished 2000 images
    Finished 2100 images
    Finished 2200 images
    Finished 2300 images
    Finished 2400 images
    Finished 2500 images
    Finished 2600 images
    Finished 2700 images
    Finished 2800 images
    Finished 2900 images
    Finished 3000 images
    Finished 3100 images
    Finished 3200 images
    Finished 3300 images
    Finished 3400 images
    Finished 3500 images
    Finished 3600 images


Transform to X and Y


```python
(a,b)=feature_list[0].shape
feature_size=a*b
np_features=np.zeros((len(feature_list),feature_size))
for i in range(len(feature_list)):
    feat=feature_list[i]
    np_features[i]=feat
X=np_features

mlb=MultiLabelBinarizer()
Y=mlb.fit_transform(genre_list)
```

Select the training set and testing set.


```python
mask = np.random.rand(len(X)) < 0.8
X_train=X[mask]
X_test=X[~mask]
Y_train=Y[mask]
Y_test=Y[~mask]
```

## Deep Learning

Create the model.


```python
model_visual = Sequential([
    Dense(1024, input_shape=(25088,)),
    Activation('relu'),
    Dense(256),
    Activation('relu'),
    Dense(numGenres),
    Activation('sigmoid'),
])
opt = optimizers.rmsprop(lr=0.0001, decay=1e-6)

#sgd = optimizers.SGD(lr=0.05, decay=1e-6, momentum=0.4, nesterov=False)
model_visual.compile(optimizer=opt, loss='binary_crossentropy', metrics=['accuracy'])
```

Train it!


```python
model_visual.fit(X_train, Y_train, epochs=100, batch_size=64,verbose=1)
```

    Epoch 1/100
    2919/2919 [==============================] - 19s - loss: 1.1834 - acc: 0.9060    
    Epoch 2/100
    2919/2919 [==============================] - 12s - loss: 0.5655 - acc: 0.9261    
    Epoch 3/100
    2919/2919 [==============================] - 12s - loss: 0.2081 - acc: 0.9628    
    Epoch 4/100
    2919/2919 [==============================] - 12s - loss: 0.0783 - acc: 0.9854    
    Epoch 5/100
    2919/2919 [==============================] - 12s - loss: 0.0534 - acc: 0.9917    
    Epoch 6/100
    2919/2919 [==============================] - 12s - loss: 0.0481 - acc: 0.9935    
    Epoch 7/100
    2919/2919 [==============================] - 12s - loss: 0.0375 - acc: 0.9959    
    Epoch 8/100
    2919/2919 [==============================] - 12s - loss: 0.0421 - acc: 0.9952    
    Epoch 9/100
    2919/2919 [==============================] - 12s - loss: 0.0361 - acc: 0.9969    
    Epoch 10/100
    2919/2919 [==============================] - 12s - loss: 0.0376 - acc: 0.9966    
    Epoch 11/100
    2919/2919 [==============================] - 12s - loss: 0.0367 - acc: 0.9967    
    Epoch 12/100
    2919/2919 [==============================] - 12s - loss: 0.0355 - acc: 0.9973    
    Epoch 13/100
    2919/2919 [==============================] - 12s - loss: 0.0393 - acc: 0.9964    
    Epoch 14/100
    2919/2919 [==============================] - 12s - loss: 0.0371 - acc: 0.9970    
    Epoch 15/100
    2919/2919 [==============================] - 12s - loss: 0.0353 - acc: 0.9973    
    Epoch 16/100
    2919/2919 [==============================] - 12s - loss: 0.0356 - acc: 0.9974    
    Epoch 17/100
    2919/2919 [==============================] - 12s - loss: 0.0412 - acc: 0.9963    
    Epoch 18/100
    2919/2919 [==============================] - 12s - loss: 0.0336 - acc: 0.9976    
    Epoch 19/100
    2919/2919 [==============================] - 12s - loss: 0.0387 - acc: 0.9968    
    Epoch 20/100
    2919/2919 [==============================] - 12s - loss: 0.0341 - acc: 0.9975    
    Epoch 21/100
    2919/2919 [==============================] - 12s - loss: 0.0442 - acc: 0.9963    
    Epoch 22/100
    2919/2919 [==============================] - 12s - loss: 0.0342 - acc: 0.9976    
    Epoch 23/100
    2919/2919 [==============================] - 12s - loss: 0.0369 - acc: 0.9975    
    Epoch 24/100
    2919/2919 [==============================] - 12s - loss: 0.0339 - acc: 0.9977    
    Epoch 25/100
    2919/2919 [==============================] - 12s - loss: 0.0351 - acc: 0.9975    
    Epoch 26/100
    2919/2919 [==============================] - 12s - loss: 0.0338 - acc: 0.9977    
    Epoch 27/100
    2919/2919 [==============================] - 12s - loss: 0.0336 - acc: 0.9977    
    Epoch 28/100
    2919/2919 [==============================] - 12s - loss: 0.0372 - acc: 0.9973    
    Epoch 29/100
    2919/2919 [==============================] - 12s - loss: 0.0342 - acc: 0.9976    
    Epoch 30/100
    2919/2919 [==============================] - 12s - loss: 0.0344 - acc: 0.9977    
    Epoch 31/100
    2919/2919 [==============================] - 12s - loss: 0.0344 - acc: 0.9976    
    Epoch 32/100
    2919/2919 [==============================] - 12s - loss: 0.0416 - acc: 0.9966    
    Epoch 33/100
    2919/2919 [==============================] - 12s - loss: 0.0341 - acc: 0.9978    
    Epoch 34/100
    2919/2919 [==============================] - 12s - loss: 0.0365 - acc: 0.9974    
    Epoch 35/100
    2919/2919 [==============================] - 12s - loss: 0.0342 - acc: 0.9978    
    Epoch 36/100
    2919/2919 [==============================] - 12s - loss: 0.0336 - acc: 0.9979    
    Epoch 37/100
    2919/2919 [==============================] - 12s - loss: 0.0391 - acc: 0.9973    
    Epoch 38/100
    2919/2919 [==============================] - 12s - loss: 0.0408 - acc: 0.9970    
    Epoch 39/100
    2919/2919 [==============================] - 12s - loss: 0.0344 - acc: 0.9978    
    Epoch 40/100
    2919/2919 [==============================] - 12s - loss: 0.0348 - acc: 0.9977    
    Epoch 41/100
    2919/2919 [==============================] - 12s - loss: 0.0337 - acc: 0.9978    
    Epoch 42/100
    2919/2919 [==============================] - 12s - loss: 0.0340 - acc: 0.9978    
    Epoch 43/100
    2919/2919 [==============================] - 12s - loss: 0.0340 - acc: 0.9978    
    Epoch 44/100
    2919/2919 [==============================] - 12s - loss: 0.0335 - acc: 0.9978    
    Epoch 45/100
    2919/2919 [==============================] - 12s - loss: 0.0360 - acc: 0.9974    
    Epoch 46/100
    2919/2919 [==============================] - 12s - loss: 0.0346 - acc: 0.9977    
    Epoch 47/100
    2919/2919 [==============================] - 12s - loss: 0.0342 - acc: 0.9977    
    Epoch 48/100
    2919/2919 [==============================] - 12s - loss: 0.0334 - acc: 0.9979    
    Epoch 49/100
    2919/2919 [==============================] - 12s - loss: 0.0334 - acc: 0.9979    
    Epoch 50/100
    2919/2919 [==============================] - 12s - loss: 0.0333 - acc: 0.9979    
    Epoch 51/100
    2919/2919 [==============================] - 12s - loss: 0.0333 - acc: 0.9979    
    Epoch 52/100
    2919/2919 [==============================] - 12s - loss: 0.0333 - acc: 0.9979    
    Epoch 53/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 54/100
    2919/2919 [==============================] - 12s - loss: 0.0333 - acc: 0.9979    
    Epoch 55/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 56/100
    2919/2919 [==============================] - 12s - loss: 0.0333 - acc: 0.9979    
    Epoch 57/100
    2919/2919 [==============================] - 12s - loss: 0.0333 - acc: 0.9979    
    Epoch 58/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 59/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 60/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 61/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 62/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 63/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 64/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 65/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 66/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 67/100
    2919/2919 [==============================] - 12s - loss: 0.0330 - acc: 0.9979    
    Epoch 68/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 69/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 70/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 71/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 72/100
    2919/2919 [==============================] - 12s - loss: 0.0330 - acc: 0.9979    
    Epoch 73/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 74/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 75/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    
    Epoch 76/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 77/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 78/100
    2919/2919 [==============================] - 12s - loss: 0.0330 - acc: 0.9979    
    Epoch 79/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 80/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 81/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 82/100
    2919/2919 [==============================] - 12s - loss: 0.0330 - acc: 0.9979    
    Epoch 83/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 84/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 85/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 86/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 87/100
    2919/2919 [==============================] - 12s - loss: 0.0330 - acc: 0.9979    
    Epoch 88/100
    2919/2919 [==============================] - 12s - loss: 0.0330 - acc: 0.9979    
    Epoch 89/100
    2919/2919 [==============================] - 12s - loss: 0.0330 - acc: 0.9979    
    Epoch 90/100
    2919/2919 [==============================] - 12s - loss: 0.0331 - acc: 0.9979    
    Epoch 91/100
    2919/2919 [==============================] - 12s - loss: 0.0338 - acc: 0.9977    
    Epoch 92/100
    2919/2919 [==============================] - 12s - loss: 0.0334 - acc: 0.9978    
    Epoch 93/100
    2919/2919 [==============================] - 12s - loss: 0.0334 - acc: 0.9979    
    Epoch 94/100
    2919/2919 [==============================] - 13s - loss: 0.0336 - acc: 0.9979    
    Epoch 95/100
    2919/2919 [==============================] - 12s - loss: 0.0336 - acc: 0.9978    
    Epoch 96/100
    2919/2919 [==============================] - 12s - loss: 0.0346 - acc: 0.9977    
    Epoch 97/100
    2919/2919 [==============================] - 13s - loss: 0.0336 - acc: 0.9978    
    Epoch 98/100
    2919/2919 [==============================] - 13s - loss: 0.0334 - acc: 0.9979    
    Epoch 99/100
    2919/2919 [==============================] - 12s - loss: 0.0335 - acc: 0.9979    
    Epoch 100/100
    2919/2919 [==============================] - 12s - loss: 0.0332 - acc: 0.9979    





    <keras.callbacks.History at 0x7f115dbb7cf8>



Make the prediction.


```python
Y_preds=model_visual.predict(X_test)
```

## Evaluate the model

Evaluation criteria.


```python
def precision_recall(gt,preds):
    TP=0
    FP=0
    FN=0
    for t in gt:
        if t in preds:
            TP+=1
        else:
            FN+=1
    for p in preds:
        if p not in gt:
            FP+=1
    if TP+FP==0:
        precision=0
    else:
        precision=TP/float(TP+FP)
    if TP+FN==0:
        recall=0
    else:
        recall=TP/float(TP+FN)
    return precision,recall
```

How is the model?


```python
precs=[]
recs=[]
for i in range(len(Y_preds)):
    row=Y_preds[i]
    gt_genres=Y_test[i]
    gt_genre_names=[]
    for j in range(len(gt_genres)):
        if gt_genres[j]==1:
            gt_genre_names.append(idToGenre(j))
    #tops=np.argsort(row)[-len(gt_genre_names):]
    tops=np.argsort(row)[-1:]
    predicted_genres=[]
    for genre in tops:
        predicted_genres.append(idToGenre(genre))
    (precision,recall)=precision_recall(gt_genre_names,predicted_genres)
    precs.append(precision)
    recs.append(recall)
print('Precision is {}'.format(np.mean(np.asarray(precs))))
print('Recall is {}'.format(np.mean(np.asarray(recs))))
```

    Precision is 0.6192468619246861
    Recall is 0.44907019990702


Save the model


```python
model_visual.save('GameClassifier.hdf5')
```

## Try the model

Load the model


```python
my_model = load_model('GameClassifier.hdf5')
```

Make a guess!


```python
image_path = '/tmp/test'
url = input('Image URL: ')
subprocess.check_call(['rm', '-rf', image_path])
subprocess.check_call(['wget', '-O', image_path, url])

X = extractFeatureFromImage(image_path)
Y=my_model.predict(X)
row = Y[0]
orders = np.argsort(row)[::-1]
i = 1
for guess in orders:
    answer = input('Guess {}: Is {} correct? '.format(i, idToGenre(guess)))
    i += 1
    if answer.lower() == 'y' or answer.lower() == 'yes':
        print('Great!')
        break
```

    Image URL: https://lh4.ggpht.com/WjkLDArwtQ5O8XWn7Nt68AUSwDfc0AnwR-PhfNw0M_7ZQhZ7A9UTDvk5o5fIz4DWZQ=h900
    Guess 1: Is Shooter correct? yes
    Great!

