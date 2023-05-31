FROM mysql
ENV MYSQL_ROOT_PASSWORD=root_password
ENV LANG pl_PL.UTF-8
COPY create_schema.sql insert_data.sql /docker-entrypoint-initdb.d/
