#!/bin/bash

#THIS SCRIPT EXECUTES THE RELEVANT UNIT TESTS FOR THIS MICROSERVICE.
#IT IS REFERENCED BY THE APPLICATION PIPELINE AND THEREFORE MUST ALWAYS BE CALLED "run_unit_tests.sh"

python3 -m pip install --upgrade pip
pip install -r requirements.txt
python3 -m pytest