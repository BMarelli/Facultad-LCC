CREATE DATABASE IF NOT EXISTS Parcial2;

USE Parcial2;

DROP TABLE IF EXISTS FRECUENTA;
DROP TABLE IF EXISTS SIRVE;
DROP TABLE IF EXISTS GUSTA;

CREATE TABLE FRECUENTA (
    PERSONA         CHAR(35)        NOT NULL,
    BAR             CHAR(35)        NOT NULL,
    PRIMARY KEY (PERSONA, BAR)
);

CREATE TABLE SIRVE (
    BAR             CHAR(35)        NOT NULL,
    CERVEZA         CHAR(35)        NOT NULL,
    PRECIO          INT             NOT NULL,
    PRIMARY KEY (BAR, CERVEZA)
);

CREATE TABLE GUSTA (
    PERSONA         CHAR(35)        NOT NULL,
    CERVEZA         CHAR(35)        NOT NULL,
    PRIMARY KEY (PERSONA, CERVEZA)
);

INSERT INTO FRECUENTA VALUES ('JUAN', 'BM1');
INSERT INTO FRECUENTA VALUES ('JC', 'BM1');
INSERT INTO FRECUENTA VALUES ('JC', 'BM2');
-- INSERT INTO FRECUENTA VALUES ('JC', 'HardRock');
INSERT INTO FRECUENTA VALUES ('PA', 'BM2');
INSERT INTO FRECUENTA VALUES ('PA', 'HardRock');
INSERT INTO FRECUENTA VALUES ('KT', 'BM2');
INSERT INTO FRECUENTA VALUES ('A1', 'BM1');
INSERT INTO FRECUENTA VALUES ('A1', 'BM2');
INSERT INTO FRECUENTA VALUES ('A1', 'HardRock');

INSERT INTO SIRVE VALUES ('BM1', 'C1', 1);
INSERT INTO SIRVE VALUES ('BM1', 'Miller', 10);
INSERT INTO SIRVE VALUES ('BM1', 'C4', 8);
-- INSERT INTO SIRVE VALUES ('BM1', 'Bud', 8);
INSERT INTO SIRVE VALUES ('BM2', 'C1', 11);
INSERT INTO SIRVE VALUES ('BM2', 'C4', 8);
INSERT INTO SIRVE VALUES ('HardRock', 'Bud', 10);
INSERT INTO SIRVE VALUES ('HardRock', 'Miller', 10);

-- INSERT INTO SIRVE VALUES ('BM4', 'C4');

INSERT INTO GUSTA VALUES ('JUAN', 'Bud');
-- INSERT INTO GUSTA VALUES ('JUAN', 'C4');
INSERT INTO GUSTA VALUES ('JC', 'C1');
INSERT INTO GUSTA VALUES ('KT', 'C1');
INSERT INTO GUSTA VALUES ('PA', 'C8');

-- A
SELECT DISTINCT BAR FROM SIRVE WHERE
    CERVEZA IN (SELECT CERVEZA FROM GUSTA WHERE PERSONA = 'JUAN');

-- B
SELECT DISTINCT FRECUENTA.PERSONA FROM FRECUENTA, SIRVE, GUSTA WHERE
    FRECUENTA.PERSONA = GUSTA.PERSONA 
    AND FRECUENTA.BAR = SIRVE.BAR 
    AND SIRVE.CERVEZA = GUSTA.CERVEZA;

-- SELECT DISTINCT PERSONA FROM FRECUENTA WHERE
--     BAR IN (SELECT BAR FROM SIRVE WHERE CERVEZA IN (SELECT CERVEZA FROM GUSTA));

-- E
SELECT BAR FROM SIRVE WHERE
    CERVEZA = 'MilLer' 
    AND 
    PRECIO = (SELECT PRECIO FROM SIRVE S WHERE S.BAR = 'HardRock' AND S.CERVEZA = 'Bud');

-- F
SELECT PERSONA FROM FRECUENTA
    GROUP BY PERSONA HAVING COUNT(BAR) = (SELECT COUNT(DISTINCT BAR) FROM SIRVE);

-- D
SELECT DISTINCT PERSONA FROM FRECUENTA WHERE 
    BAR NOT IN (SELECT BAR FROM SIRVE, GUSTA WHERE 
        FRECUENTA.PERSONA = GUSTA.PERSONA
        AND
        GUSTA.CERVEZA = SIRVE.CERVEZA);

-- C
-- SELECT DISTINCT PERSONA FROM FRECUENTA
--     GROUP BY PERSONA HAVING COUNT(BAR) = (SELECT COUNT(DISTINCT SIRVE.BAR) FROM SIRVE, GUSTA WHERE FRECUENTA.PERSONA = GUSTA.PERSONA AND GUSTA.CERVEZA = SIRVE.CERVEZA);

SELECT DISTINCT PERSONA FROM FRECUENTA
    GROUP BY PERSONA HAVING COUNT(DISTINCT BAR) = (SELECT COUNT(DISTINCT SIRVE.BAR) FROM GUSTA, SIRVE WHERE
        FRECUENTA.PERSONA = GUSTA.PERSONA AND GUSTA.CERVEZA = SIRVE.CERVEZA);

