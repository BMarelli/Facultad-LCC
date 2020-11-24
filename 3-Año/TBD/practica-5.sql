CREATE DATABASE IF NOT EXISTS P5;

USE P5;

-- Ejercicio 1

SELECT VIDEOCLUB FROM VIDEOTECA WHERE
    PELICULA IN (SELECT GUSTA.PELICULA FROM GUSTA WHERE 
        GUSTA.PELICULA = VIDEOCLUB.PELICULA AND AFICIONADO = 'JOSE PEREZ');

SELECT AFICIONADO FROM SOCIO WHERE
    VIDEOCLUB IN (SELECT VIDEOCLUB FROM VIDEOCLUB WHERE PELICULA IN 
        (SELECT PELICULA FROM GUSTA WHERE SOCIO.AFICIONADO = GUSTA.AFICIONADO);

-- Ejercicio 2

DROP TABLE IF EXISTS ELL;
DROP TABLE IF EXISTS EDITORIALES;
DROP TABLE IF EXISTS LIBROS;
DROP TABLE IF EXISTS LIBRERIAS;


SELECT NOMBRE FROM LIBRERIAS WHERE
    `LIBRERIA#` IN (SELECT `LIBRERIA#` FROM ELL WHERE
        `EDITORIAL#` IN (SELECT `EDITORIAL#` FROM EDITORIALES WHERE EDITORIALES.CIUDAD = 'ROSARIO'));

SELECT `EDITORIAL#` FROM EDITORIALES WHERE
    `EDITORIAL#` IN (SELECT `EDITORIAL#` FROM ELL WHERE `LIBRERIA#` = 1)
    AND
    `EDITORIAL#` IN (SELECT `EDITORIAL#` FROM ELL WHERE `LIBRERIA#` = 3);

SELECT LIBRERIAS.`LIBRERIA#` FROM LIBRERIAS, ELL WHERE
    GROUP BY ELL.`LIBRERIA#` HAVING COUNT(DISTINCT `EDITORIALES#`) = (SELECT COUNT(*) FROM EDITORIALES);

-- Ejercicio 3



-- Ejercicio 4

DROP TABLE IF EXISTS ENTREGA;
DROP TABLE IF EXISTS ALUMNOS;
DROP TABLE IF EXISTS PRACTICAS;

CREATE TABLE ALUMNOS (
    `A#`            INT             NOT NULL            AUTO_INCREMENT,
    NOMBRE          CHAR(35)        NOT NULL,
    GRUPO           CHAR(35)        NOT NULL,
    PRIMARY KEY (`A#`)
);

CREATE TABLE PRACTICAS (
    `P#`            INT             NOT NULL            AUTO_INCREMENT,
    CURSO           INT             NOT NULL,
    FECHA           DATE            NOT NULL,
    PRIMARY KEY (`P#`)
);

CREATE TABLE ENTREGA (
    `A#`            INT             NOT NULL,
    `P#`            INT             NOT NULL,
    NOTA            INT             NOT NULL,
    PRIMARY KEY (`A#`, `P#`),
    FOREIGN KEY (`A#`) REFERENCES ALUMNOS (`A#`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`P#`) REFERENCES PRACTICAS (`P#`) ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO ALUMNOS VALUES (DEFAULT, 'BM', 'C');
INSERT INTO ALUMNOS VALUES (DEFAULT, 'JC', 'F');
INSERT INTO ALUMNOS VALUES (DEFAULT, 'PA', 'A');
INSERT INTO ALUMNOS VALUES (25, 'JUAN', 'A');

INSERT INTO PRACTICAS VALUES (DEFAULT, 1, '2020-11-25');
INSERT INTO PRACTICAS VALUES (DEFAULT, 3, '2020-11-26');
INSERT INTO PRACTICAS VALUES (DEFAULT, 3, '2020-11-27');
INSERT INTO PRACTICAS VALUES (DEFAULT, 2, '2020-11-28');

INSERT INTO ENTREGA VALUES (1, 1, 10);
INSERT INTO ENTREGA VALUES (1, 2, 10);
INSERT INTO ENTREGA VALUES (1, 3, 10);
INSERT INTO ENTREGA VALUES (2, 4, 0);
INSERT INTO ENTREGA VALUES (3, 2, 0);
INSERT INTO ENTREGA VALUES (3, 3, 0);

SELECT NOMBRE FROM ALUMNOS WHERE GRUPO = 'C' OR GRUPO = 'F';

SELECT NOMBRE FROM ALUMNOS, ENTREGA WHERE ALUMNOS.`A#` = ENTREGA.`A#`
    AND `P#` IN (SELECT `P#` FROM PRACTICAS WHERE CURSO = 3)
    GROUP BY ENTREGA.`A#` HAVING COUNT(`P#`) = (SELECT COUNT(*) FROM PRACTICAS WHERE CURSO = 3);

SELECT NOMBRE FROM ALUMNOS WHERE
    `A#` IN (SELECT DISTINCT `A#` FROM ENTREGA WHERE 
        `P#` IN (SELECT `P#` FROM PRACTICAS WHERE CURSO = 2 OR CURSO = 3));

SELECT NOMBRE FROM ALUMNOS WHERE
    `A#` IN (SELECT `A#` FROM PRACTICAS, ENTREGA WHERE  PRACTICAS.`P#` = ENTREGA.`P#` AND PRACTICAS.CURSO = 2)
    AND
    `A#` NOT IN (SELECT `A#` FROM PRACTICAS, ENTREGA WHERE PRACTICAS.`P#` = ENTREGA.`P#` AND PRACTICAS.CURSO <> 2);

SELECT NOMBRE FROM ALUMNOS WHERE
    GRUPO IN (SELECT A.GRUPO FROM ALUMNOS A WHERE A.`A#` = 25)
    AND ALUMNOS.`A#` <> 25;

SELECT NOMBRE FROM ALUMNOS WHERE
    `A#` NOT IN (SELECT DISTINCT `A#` FROM ENTREGA);

