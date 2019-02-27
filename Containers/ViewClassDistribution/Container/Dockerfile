# Use an official Python runtime as a parent image
FROM continuumio/anaconda3:5.1.0

# Install any needed packages specified in requirements.txt
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y make

# Set the working directory to /
WORKDIR /

# Copy the current directory contents into the container at /
COPY . /

# Install python requirements
RUN make requirements

# Set the container working directory to the user home folder
WORKDIR /notebooks

# Start jupyter
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8889", "--no-browser", "--allow-root"]