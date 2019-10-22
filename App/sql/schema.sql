CREATE TABLE  users (
	username varchar(256) PRIMARY KEY,
	password varchar(256) NOT NULL,
	gender varchar(1) NOT NULL,
	phone_num varchar(50) NOT NULL,
	email varchar(256) NOT NULL,
	display_name varchar(256) NOT NULL
);

INSERT INTO users VALUES ('U1', 'password1', 'M', '88888888','user1@gmail.com','User 1'); 