FROM trakkdev/earnapp:latest

ENV EARNAPP_UUID=sdk-node-468663fb0e083313c486f8dbda1ee292

# Optionally, you can set resource limits in your docker run command,
# but not directly in the Dockerfile.
# The container will use the CMD/ENTRYPOINT from the base image.
