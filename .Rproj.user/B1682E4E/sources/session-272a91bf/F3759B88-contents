from fastapi import FastAPI
from vetiver import VetiverModel, VetiverAPI
#from joblib import load
import pins
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

# Load your trained model
#model = load('penguin_model.joblib')

# Create a VetiverModel instance
#v = VetiverModel(model, model_name='penguin_model')
b = pins.board_folder('data/model', allow_pickle_read=True)
v = VetiverModel.from_pin(b, 'penguin_model', version = '20240408T104626Z-a6f9b')

# Create the FastAPI app
app = VetiverAPI(v, check_prototype=True)
app.run(port = 8080)
