FROM mysql
ENV MYSQL_ROOT_PASSWORD=root_password
ENV LANG pl_PL.UTF-8
COPY database insert_data.sql /docker-entrypoint-initdb.d/
