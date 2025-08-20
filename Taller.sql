-- Active: 1755603023291@@127.0.0.1@5433@campus@miscompras

DROP SCHEMA IF EXISTS miscompras CASCADE;
CREATE SCHEMA IF NOT EXISTS miscompras;
SET search_path TO miscompras;

CREATE TABLE clientes (
    id                 VARCHAR(20)  PRIMARY KEY,
    nombre             VARCHAR(40)  NOT NULL,
    apellidos          VARCHAR(100) NOT NULL,
    celular            NUMERIC(10,0),
    direccion          VARCHAR(80),
    correo_electronico VARCHAR(70)
);

CREATE TABLE miscompras.categorias (
    id_categoria  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descripcion   VARCHAR(45) NOT NULL,
    estado        SMALLINT     NOT NULL DEFAULT 1,
    CONSTRAINT categorias_estado_chk CHECK (estado IN (0,1))
);

CREATE TABLE miscompras.productos (
    id_producto    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre         VARCHAR(45)   NOT NULL,
    id_categoria   INT           NOT NULL,
    codigo_barras  VARCHAR(150),
    precio_venta   NUMERIC(16,2) NOT NULL,
    cantidad_stock INT           NOT NULL DEFAULT 0,
    estado         SMALLINT      NOT NULL DEFAULT 1,
    CONSTRAINT productos_precio_chk   CHECK (precio_venta >= 0),
    CONSTRAINT productos_stock_chk    CHECK (cantidad_stock >= 0),
    CONSTRAINT productos_estado_chk   CHECK (estado IN (0,1)),
    CONSTRAINT productos_fk_categoria FOREIGN KEY (id_categoria)
        REFERENCES miscompras.categorias(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Unico por cÃ³digo de barras si se usa, permite varios NULL
CREATE UNIQUE INDEX IF NOT EXISTS ux_productos_codigo_barras
    ON miscompras.productos (codigo_barras)
    WHERE codigo_barras IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_productos_id_categoria
    ON miscompras.productos (id_categoria);


CREATE TABLE miscompras.compras (
    id_compra    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente   VARCHAR(20)  NOT NULL,
    fecha        TIMESTAMP    NOT NULL DEFAULT NOW(),
    medio_pago   CHAR(1)      NOT NULL,
    comentario   VARCHAR(300),
    estado       CHAR(1)      NOT NULL,
    CONSTRAINT compras_fk_cliente FOREIGN KEY (id_cliente)
        REFERENCES miscompras.clientes(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Indice para busquedas por cliente
CREATE INDEX IF NOT EXISTS idx_compras_id_cliente
    ON miscompras.compras (id_cliente);

CREATE TABLE miscompras.compras_productos (
    id_compra    INT           NOT NULL,
    id_producto  INT           NOT NULL,
    cantidad     INT           NOT NULL,
    total        NUMERIC(16,2) NOT NULL,
    estado       SMALLINT      NOT NULL DEFAULT 1,
    CONSTRAINT compras_productos_pk PRIMARY KEY (id_compra, id_producto),
    CONSTRAINT compras_productos_cantidad_chk CHECK (cantidad > 0),
    CONSTRAINT compras_productos_total_chk    CHECK (total >= 0),
    CONSTRAINT compras_productos_estado_chk   CHECK (estado IN (0,1)),
    CONSTRAINT compras_productos_fk_compra FOREIGN KEY (id_compra)
        REFERENCES miscompras.compras(id_compra)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT compras_productos_fk_producto FOREIGN KEY (id_producto)
        REFERENCES miscompras.productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Indice adicional para acelerar consultas por producto
CREATE INDEX IF NOT EXISTS idx_cp_id_producto
    ON miscompras.compras_productos (id_producto);


    SELECT p.id_producto, p.nombre,
            SUM(cp.cantidad) AS unidades,
            SUM(cp.total) AS ingreso_total
    FROM miscompras.compras_productos cp
    JOIN miscompras.productos p USING(id_producto)
    GROUP BY p.id_producto, p.nombre
    ORDER BY unidades DESC
    LIMIT 10;

    SELECT ROUND(AVG(t.total_compra), 2) AS promedio_compra,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY t.total_compra) AS mediana 
    FROM (
        SELECT c.id_compra, SUM(cp.total) as total_compra 
        FROM miscompras.compras c 
        JOIN miscompras.compras_productos cp USING(id_compra)
        GROUP BY c.id_compra 
        )t;


    SELECT cl.id, cl.nombre || ' ' || cl.apellidos AS cliente,
        COUNT(DISTINCT c.id_compra) AS compras,
        SUM(cp.total) AS gasto_total,
        RANK() OVER(ORDER BY SUM(cp.total) DESC) AS ranking_gasto
    FROM miscompras.clientes cl
    JOIN miscompras.compras c ON cl.id = c.id_cliente
    JOIN miscompras.compras_productos cp USING(id_compra)
    GROUP BY cl.id, cliente
    ORDER BY ranking_gasto;


    SELECT c.id_compra, c.fecha::date as dia, SUM(cp.total) as
    total_compra
    FROM miscompras.compras c
    JOIN miscompras.compras_productos cp USING(id_compra)
    GROUP BY c.id_compra, c.fecha::date;


    WITH t AS(
    SELECT c.id_compra, c.fecha::date as dia, SUM(cp.total) as
    total_compra
    FROM miscompras.compras c
    JOIN miscompras.compras_productos cp USING(id_compra)
    GROUP BY c.id_compra, c.fecha::date
    )
    SELECT dia,
    COUNT(*) AS numero_compras,
    ROUND(AVG(total_compra), 2)as promedio,
    SUM(total_compra) as total_dia
    FROM t
    GROUP BY dia
    ORDER BY dia;


    DROP VIEW IF EXISTS miscompras.reporte_mes;

    CREATE MATERIALIZED VIEW miscompras.reporte_mes AS
    SELECT DATE_TRUNC('month', c.fecha) AS mes,
        SUM(cp.total) AS total_ventas
        FROM miscompras.compras c
        JOIN miscompras.compras_productos cp USING(id_compra)
        GROUP BY mes;

    SELECT * FROM miscompras.reporte_mes;

    REFRESH MATERIALIZED VIEW miscompras.reporte_mes;








    -- TRIGGERS
    CREATE OR REPLACE FUNCTION miscompras.trg_descuento_stock()
    RETURNS TRIGGER LANGUAGE PLPGSQL AS
    $$
    BEGIN
        UPDATE miscompras.productos
        SET cantidad_stock = GREATEST(0, cantidad_stock - NEW.cantidad)
        WHERE id_producto = NEW.id_producto;
        RETURN NEW;
    END;
    $$;


    DROP TRIGGER IF EXISTS compras_productos_descuento_stock ON miscompras.compras_productos;

    CREATE TRIGGER compras_productos_descuento_stock
    AFTER INSERT ON miscompras.compras_productos
    FOR EACH ROW
    EXECUTE FUNCTION miscompras.trg_descuento_stock();



    SELECT nombre, miscompras.toMoney(precio_venta) as precio_venta
    FROM miscompras.productos;


    CREATE OR REPLACE FUNCTION miscompras.toMoney(p_numeric NUMERIC)
    RETURNS VARCHAR
    LANGUAGE plpgsql
    AS $$
    DECLARE valor VARCHAR(255);
    BEGIN
        SELECT CONCAT('$', TO_CHAR(p_numeric, 'FM999G999G999D00'))
        INTO valor;
        RETURN valor;
    END;
    $$;
