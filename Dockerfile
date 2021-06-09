FROM nginx
RUN apt-get update -y && apt-get install procps lsof -y
COPY . .
CMD ["bash", "./entrypoint.sh"]