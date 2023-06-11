import os

# Fetch the parameters from environment variables
parameter1 = os.getenv('PARAMETER1')
parameter2 = os.getenv('PARAMETER2')

print(f"HELLO WORLD , {parameter1} - {parameter2}")
