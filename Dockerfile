FROM redis:latest

# Install Ruby and any necessary dependencies
RUN apt-get update && \
    apt-get install -y ruby && \
    gem install redis

# Set the working directory
WORKDIR /scripts

# Copy your Ruby script into the container
COPY fill_data.rb /scripts/fill_data.rb

# Make the script executable if needed
# RUN chmod +x /scripts/fill_data.rb
