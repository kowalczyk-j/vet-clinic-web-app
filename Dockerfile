FROM mysql
ENV MYSQL_ROOT_PASSWORD=root_password
ENV LANG pl_PL.UTF-8
COPY database_src/create_schema.sql database_src/insert_data.sql database_src/triggers.sql /docker-entrypoint-initdb.d/