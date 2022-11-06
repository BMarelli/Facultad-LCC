CREATE DATABASE IF NOT EXISTS P3;

USE P3;

DROP TABLE IF EXISTS SPJ;
DROP TABLE IF EXISTS S;
DROP TABLE IF EXISTS P;
DROP TABLE IF EXISTS J;

create table S (
    `S#`        int             not null        AUTO_INCREMENT,
    Snombre     varchar(35)     not null,
    situacion   int default 0   not null,
    ciudad      varchar(35)     not null,
    PRIMARY KEY (`S#`)
);

create table P (
    `P#`        int             not null        AUTO_INCREMENT,
    Pnombre     varchar(35)     not null,
    color       varchar(30)     not null,
    peso        int             not null,
    ciudad      varchar(35)     not null,
    PRIMARY KEY (`P#`)
);

create table J (
    `J#`        int             not null        AUTO_INCREMENT,
    Jnombre     varchar(35)     not null,
    ciudad      varchar(35)     not null,
    PRIMARY KEY (`J#`)
);

create table SPJ (
    `S#`        int             not null,
    `P#`        int             not null,
    `J#`        int             not null,
    cantidad    int,
    PRIMARY KEY (`S#`, `P#`, `J#`),
    FOREIGN KEY (`S#`) REFERENCES S (`S#`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`P#`) REFERENCES P (`P#`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`J#`) REFERENCES J (`J#`) ON DELETE CASCADE ON UPDATE CASCADE 
);

insert into S values (default, 'Salazar', 20, 'Londres');
insert into S values (default, 'Jaimes', 10, 'Paris');
insert into S values (default, 'Bernal', 30, 'Paris');
insert into S values (default, 'Corona', 20, 'Londres');
insert into S values (default, 'Aldana', 30, 'Atenas');

insert into P values (default, 'Tuerca', 'Rojo', 12, 'Londres');
insert into P values (default, 'Perno', 'Verde', 17, 'Paris');
insert into P values (default, 'Burlete', 'Azul', 17, 'Roma');
insert into P values (default, 'Burlete', 'Rojo', 14, 'Londres');
insert into P values (default, 'Leva', 'Azul', 12, 'Paris');
insert into P values (default, 'Engranaje', 'Rojo', 19, 'Londres');

insert into J values (default, 'Clasificador', 'Paris');
insert into J values (default, 'Perforadora', 'Roma');
insert into J values (default, 'Lectora', 'Atenas');
insert into J values (default, 'Consola', 'Atenas');
insert into J values (default, 'Compaginador', 'Londres');
insert into J values (default, 'Terminal', 'Oslo');
insert into J values (default, 'Cinta', 'Londres');

insert into SPJ values (1, 1, 1, 200);
insert into SPJ values (1, 1, 4, 700);
insert into SPJ values (2, 3, 1, 400);
insert into SPJ values (2, 3, 2, 200);
insert into SPJ values (2, 3, 3, 200);
insert into SPJ values (2, 3, 4, 500);
insert into SPJ values (2, 3, 5, 600);
insert into SPJ values (2, 3, 6, 400);
insert into SPJ values (2, 3, 7, 800);
insert into SPJ values (2, 5, 2, 100);
insert into SPJ values (3, 3, 1, 200);
insert into SPJ values (3, 4, 2, 500);
insert into SPJ values (4, 6, 3, 300);
insert into SPJ values (4, 6, 7, 300);
insert into SPJ values (5, 2, 2, 200);
insert into SPJ values (5, 2, 4, 100);
insert into SPJ values (5, 5, 5, 500);
insert into SPJ values (5, 5, 7, 100);
insert into SPJ values (5, 1, 4, 100);
insert into SPJ values (5, 3, 4, 200);
insert into SPJ values (5, 4, 4, 800);
insert into SPJ values (5, 5, 4, 400);
insert into SPJ values (5, 6, 4, 500);

-- Ejercicio 1
select * from J;
select * from J where ciudad = 'Londres';
select `S#` from SPJ where `J#` = 1 order by `S#`;
select * from SPJ where cantidad >= 300 and cantidad <= 750;
select distinct color, ciudad from P;

-- Ejercicio 2
select `S#`, `P#`, `J#` from S, P, J where
    S.ciudad = P.ciudad and P.ciudad = J.ciudad;
select `S#`, `P#`, `J#` from S, P, J where
    not (S.ciudad = P.ciudad and P.ciudad = J.ciudad);
select `S#`, `P#`, `J#` from S, P, J where
    S.ciudad <> P.ciudad and S.ciudad <> J.ciudad and P.ciudad <> J.ciudad;
select distinct SPJ.`P#` from SPJ, S where
    SPJ.`S#` = S.`S#` and S.ciudad = 'Londres';
select distinct SPJ.`P#` from SPJ, S, J where
    SPJ.`S#` = S.`S#` and SPJ.`J#` = J.`J#`
    and S.ciudad = 'Londres' and J.ciudad = 'Londres';
select distinct S.ciudad, J.ciudad from S, J, SPJ where
    S.`S#` = SPJ.`S#` and J.`J#` = SPJ.`J#`;
select distinct SPJ.`P#` from SPJ, S, J where
    S.`S#` = SPJ.`S#` and J.`J#` = SPJ.`J#`
    and S.ciudad = J.ciudad;
select distinct SPJ.`J#` from SPJ, S, J where
    S.`S#` = SPJ.`S#` and J.`J#` = SPJ.`J#`
    and S.ciudad <> J.ciudad;
select SPJ1.`P#`, SPJ2.`P#` from SPJ SPJ1, SPJ SPJ2 where
    SPJ1.`S#` = SPJ2.`S#` and SPJ1.`P#` > SPJ2.`P#`;

-- Ejercicio 3
select count(distinct `J#`) from SPJ where `S#` = 1;
select sum(cantidad) from SPJ where `S#` = 1 and `P#` = 1;
select `P#`, `J#`, sum(cantidad) from SPJ group by `P#`, `J#`;
select distinct `P#` from SPJ group by `P#`, `J#` having avg(cantidad) > 320;
-- Ejercicio 4
select * from SPJ where cantidad is not null;
select `J#`, ciudad from J where ciudad like '_o%';

-- Ejercicio 5
select distinct Jnombre from J where `J#` in 
    (select `J#` from SPJ where `S#` = 1);
select distinct color from P where `P#` in
    (select `P#` from SPJ where `S#` = 1);
select distinct `P#` from SPJ where `J#` in
    (select `J#` from J where ciudad = 'Londres');
select distinct `J#` from SPJ where `P#` in
    (select `P#` from SPJ where `S#` = 1);
select distinct `S#` from SPJ where `P#` in
    (select `P#` from SPJ where `S#` in
        (select `S#` from SPJ where `P#` in
            (select `P#` from P where color = 'Rojo')));
select distinct `S#` from S where 
    situacion < (select situacion from S where `S#` = 1);
select `J#` from J where
    ciudad = (select min(ciudad) from J);

-- Ejercicio 6
select distinct `P#` from SPJ where
    EXISTS (select * from J where SPJ.`J#` = J.`J#` and ciudad = 'Londres');
select distinct SPJ.`J#` from SPJ where
    EXISTS (select * from SPJ SPJ1 where SPJ.`P#` = SPJ1.`P#` and SPJ1.`S#` = 1);
select `J#` from J where
    NOT EXISTS (select * from SPJ where
        J.`J#` = SPJ.`J#`
        and `P#` in (select `P#` from P where color = 'Rojo')
        and `S#` in (select `S#` from S where ciudad = 'Londres')
    );
select distinct SPJ.`J#` from SPJ where
   NOT EXISTS (select * from SPJ SPJ1 where SPJ.`J#` = SPJ1.`J#` and SPJ1.`S#` <> 1);

-- Ejercicio 7
select distinct ciudad from S
union
select distinct ciudad from P
union
select distinct ciudad from J
order by 1;

-- Ejercicio 8
update P set color = 'Gris' where color = 'Rojo';
delete from J where
    `J#` not in (select distinct `J#` from SPJ);
insert into S values (10, 'Salazar', default, 'Nueva York');
