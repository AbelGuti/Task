create database Guatemala;
use Guatemala;
create table places(
id int not null auto_increment,
name varchar(25) not null,
primary key(id)
);
create table names(
id int not null auto_increment,
id_place int not null,
description varchar(150) not null,
primary key(id),
foreign key(id_place) references places(id)
);

INSERT INTO places(name) VALUES('Lakes');
INSERT INTO places(name) VALUES('Rivers');
INSERT INTO places(name) VALUES('Vulcanos');

INSERT INTO names(id_place,description) VALUES(1,'Flores Peten');
INSERT INTO names(id_place,description) VALUES(1,'Izabal');
INSERT INTO names(id_place,description) VALUES(1,'Amatitlan');
INSERT INTO names(id_place,description) VALUES(2,'Hondo');
INSERT INTO names(id_place,description) VALUES(2,'Motagua');
INSERT INTO names(id_place,description) VALUES(3,'Fuego');
INSERT INTO names(id_place,description) VALUES(3,'Agua');
INSERT INTO names(id_place,description) VALUES(3,'Pacaya');

grant all privileges on *.* to 'root'@'%' identified by 'pokemon';
