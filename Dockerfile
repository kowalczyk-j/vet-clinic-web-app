FROM mysql
ENV MYSQL_ROOT_PASSWORD=root_password
COPY create_schema.sql insert_data.sql /docker-entrypoint-initdb.d/
