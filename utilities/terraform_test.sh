#!/bin/bash

echo "------------------------------"
echo "UTILITIES - TERRAFORM TEST"
echo "------------------------------"

# Define the virtual environment directory
VENV_DIR="test_venv"

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Python3 could not be found, please install it first."
    exit 1
fi

# Check if the virtual environment exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Check if pip is installed in the virtual environment
if ! command -v pip &> /dev/null; then
    echo "Pip could not be found in the virtual environment."
    deactivate
    exit 1
fi

# Check if the requirements are already installed
REQUIREMENTS_INSTALLED=$(pip list --format=columns | grep -E 'pytest|tftest')
if [ -z "$REQUIREMENTS_INSTALLED" ]; then
    echo "Installing requirements..."
    pip install -r requirements.txt
else
    echo "Requirements already installed."
fi

# Run the tests
echo "Running tests..."
pytest ../testing_dir/main.py

# Deactivate the virtual environment
deactivate

echo "------------------------------"
echo "TESTING COMPLETED"
echo "------------------------------"
