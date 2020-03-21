#!/bin/bash

# Quit this script if any command fails
set -e

# Convert notebooks to python
jupyter nbconvert website_updates.ipynb --to python
jupyter nbconvert nhs_advice.ipynb --to python

# Setup virtualenv and install requirements
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt

# Run the scripts
python3 ./website_updates.py
python3 ./nhs_advice.py
