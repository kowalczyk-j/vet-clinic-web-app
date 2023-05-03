create database bd2_23l_z31;

use bd2_23l_z31;

CREATE TABLE owner (
    owner_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(12),
    pesel VARCHAR(11) NOT NULL,
    PRIMARY KEY (owner_id)
);
