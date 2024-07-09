#!/bin/bash

echo "------------------------------"
echo "UTILITIES - TERRAFORM TEST"
echo "------------------------------"

VENV_DIR="test_venv"

# Check if the virtual environment exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python -m venv "$VENV_DIR"
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

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
