-- Active: 1755603023291@@127.0.0.1@5433@campus
# Postgres con Docker
## taller de constraints

## Funciones y Operadores  - SELECT 
1. Top 10 productos màs vendidos (unidades) y su  ingreso total 
    - `SUM()`
    - `USING`
    ```sql
    SELECT p.id_producto, p.nombre,
        SUM(cp.cantidad) AS unidades
        SUM (cp.total) AS ingreso total
    FROM miscompras.compras_productos cp 
    JOIN miscompras.productos p  USING(id_producto)
    GROUP BY p.id_producto, p.nombre
    ORDER BY unidades DESC
    LIMIT 10;
    ```
2. Venta promedio por compra y mediana aproximada
    -`PERCENTILE_CONT(..) WITH GROUP (ORDER BY ..)`
    -`PERCENTILE_CONT`
    -`PERCENTILE_CONT`
    -`PERCENTILE_CONT`

    ```sql
    SELECT ROUND(AVG(t.total_compra), 2) AS promedio_compra,
    PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY t.total_compra) AS mediana 
    FROM (
        SELECT c.id_compra, SUM(cp.total) as total_compra 
        FROM miscompras.compras c 
        JOIN miscompras.compras_productos cp USING(id_compra)
        GROUP BY c.id_compra 
        )t;
    ```

3. compra por cliente y ranking
    -`COUNT`
    -`SUM`
    -`RANK() OVER(ORDER BY... ASC/DESC) ASC/DESC`

    ```sql
    SELECT cl.id, cl.nombre || ' ' || cl.apellidos AS cliente,
           COUNT(DISTINCT c.id_compra) AS compras,
           SUM(cp.total) AS gasto_total,
           RANK() OVER(ORDER BY SUM(cp.total) DESC) AS ranking_gasto
    FROM miscompras.clientes cl
    JOIN miscompras.compras c ON cl.id = c.id_cliente
    JOIN miscompras.compras_productos cp USING(id_compra)
    GROUP BY cl.id, cliente
    ORDER BY ranking_gasto;
    ```


4. Ticket por compra

- `COUNT`
- `ROUND`
- `SUM`
- `WITH args AS`
    ```sql
    --CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP NOW, AGE, EXTRACT
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
    ```

5. busqueda "tipo e-commerce" Productos activo, disponibles y que empiecen por 'caf'
    -`ILIKE`
    ```sql
    SELECT *
    FROM