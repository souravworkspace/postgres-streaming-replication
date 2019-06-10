FROM postgres:11.3
RUN apt-get update
RUN apt-get --assume-yes install netcat
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["gosu", "postgres", "postgres"]
