# Use an official Python runtime as a base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /usr/src/app

# Install necessary packages via pip
RUN pip install --upgrade pip && \
    pip install pandas==1.5.3 numpy==1.23.5 matplotlib==3.7.0 seaborn==0.12.2 scipy==1.10.0

# Copy the local contents into the container at /usr/src/app
COPY . /usr/src/app

# Set the default command to execute when the container starts
CMD ["python"]
