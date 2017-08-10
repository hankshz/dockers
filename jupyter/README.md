# Jupyter Notebook

Use Jupyter Notebook in the docker

  - Build & Run Jupyter Notebook docker image
  - Use Jupyter while all changes will be saved to the local workspace

Usage

  - Build & Run Jupyter Notebook docker image:
    ```sh
    ./script/run-server.sh
    ```
    It will automatically open the Jupyter Notebook in the browser (by calling x-www-browser)
  - It will load and save all your work to $(pwd)/workspace. Have fun!
