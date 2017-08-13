# Game Classifier

Use Deep Learning to build a model that can tell the genre of the game by analyzing the screenshot

  - The idea and the code of data science are inspired by https://github.com/Spandan-Madan/DeepLearningProject
  - Tool to download game info & screenshot from http://thegamesdb.net
  - A Jupyter Notebook that build the model step by step

Usage

  - Download game info & screenshot:
    ```sh
    ./download.py info --start 1 --count 1000
    ./download.py image --start 1 --count 1000
    ```
  - Use the Jupyter Notebook to try it
    - A read-only version is [here](GameClassifier.md)
    - A trained model can be downloaded [here](https://drive.google.com/open?id=0B6EXhnJ8EmaZOE1WTzlSNXd0aU0)
    - A downloads of thousands of games can be downloaded [here](https://drive.google.com/open?id=0B6EXhnJ8EmaZUnVGc01qNWhOenc)
