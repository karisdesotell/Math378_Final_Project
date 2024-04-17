# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable for the model path
ENV MODEL_PATH=/app/penguin_model.joblib

# Run app.py when the container launches using uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]


#----------------------------------------------------------TESTING_____________
# Use an official lightweight base image
#FROM alpine:latest

# Command to run when the container starts
#CMD ["echo", "Hello World"]
