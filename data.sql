SET search_path TO miscompras;

INSERT INTO miscompras.clientes (id, nombre, apellidos, celular, direccion, correo_electronico) VALUES
('CC1001', 'Camila',   'Ramírez Gómez',     3004567890, 'Cra 12 #34-56, Bogotá',      'camila.ramirez@example.com'),
('CC1002', 'Andrés',   'Pardo Salinas',     3109876543, 'Cl 45 #67-12, Medellín',     'andres.pardo@example.com'),
('CC1003', 'Valeria',  'Gutiérrez Peña',    3012223344, 'Av 7 #120-15, Bogotá',       'valeria.gutierrez@example.com'),
('CC1004', 'Juan',     'Soto Cárdenas',     3155556677, 'Cl 9 #8-20, Cali',           'juan.soto@example.com'),
('CC1005', 'Luisa',    'Fernández Ortiz',   3028889911, 'Cra 50 #10-30, Bucaramanga', 'luisa.fernandez@example.com'),
('CC1006', 'Carlos',   'Muñoz Prieto',      3014567890, 'Cl 80 #20-10, Barranquilla', 'carlos.munoz@example.com'),
('CC1007', 'Diana',    'Rojas Castillo',    3126665544, 'Cra 15 #98-45, Bogotá',      'diana.rojas@example.com'),
('CC1008', 'Miguel',   'Vargas Rincón',     3201234567, 'Cl 33 #44-21, Cartagena',    'miguel.vargas@example.com');


INSERT INTO miscompras.categorias (descripcion, estado) VALUES
('Café',       1),
('Lácteos',    1),
('Panadería',  1),
('Aseo',       1),
('Snacks',     1),
('Bebidas',    1);

INSERT INTO miscompras.productos (nombre, id_categoria, codigo_barras, precio_venta, cantidad_stock, estado) VALUES
('Café de Colombia 500g',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Café'),
 '7701234567001', 28000.00,  250, 1),
('Café Orgánico Sierra Nevada 250g',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Café'),
 '7701234567002', 22000.00,  180, 1),
('Leche entera 1L',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Lácteos'),
 '7701234567003',  4200.00,  600, 1),
('Yogur natural 1L',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Lácteos'),
 '7701234567004',  6000.00,  400, 1),
('Pan campesino',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Panadería'),
 '7701234567005',  3500.00,  320, 1),
('Croissant mantequilla',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Panadería'),
 '7701234567006',  2500.00,  500, 1),
('Detergente líquido 1L',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Aseo'),
 '7701234567007', 12000.00,  260, 1),
('Jabón en barra 3un',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Aseo'),
 '7701234567008',  8000.00,  300, 1),
('Papas fritas 150g',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Snacks'),
 '7701234567009',  5500.00,  700, 1),
('Maní salado 200g',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Snacks'),
 '7701234567010',  7000.00,  420, 1),
('Gaseosa cola 1.5L',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Bebidas'),
 '7701234567011',  6500.00,  800, 1),
('Agua sin gas 600ml',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Bebidas'),
 '7701234567012',  2200.00, 1200, 1),
('Té verde botella 500ml',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Bebidas'),
 '7701234567013',  3800.00,  650, 1),
('Chocolate de mesa 250g',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Panadería'),
 '7701234567014',  9000.00,  240, 1),
('Mermelada fresa 300g',
 (SELECT id_categoria FROM miscompras.categorias WHERE descripcion='Panadería'),
 '7701234567015',  7500.00,  260, 1);

INSERT INTO miscompras.compras (id_cliente, fecha, medio_pago, comentario, estado) VALUES
('CC1001', '2025-07-02 10:15:23', 'T', 'Compra semanal',            'A'),
('CC1002', '2025-07-03 18:45:10', 'E', 'Para oficina',              'A'),
('CC1003', '2025-07-05 09:05:00', 'C', NULL,                        'A'),
('CC1001', '2025-07-10 14:22:40', 'T', 'Reabastecimiento café',     'A'),
('CC1004', '2025-07-12 11:11:11', 'E', 'Desayuno fin de semana',    'A'),
('CC1005', '2025-07-15 19:35:05', 'T', 'Compras del mes',           'A'),
('CC1006', '2025-07-18 08:55:30', 'C', 'Limpieza y bebidas',        'A'),
('CC1007', '2025-07-20 16:01:00', 'T', 'Merienda en familia',       'A'),
('CC1008', '2025-07-25 12:20:45', 'E', 'Reunión con amigos',        'A'),
('CC1002', '2025-08-01 17:05:12', 'T', 'Compras para semana',       'A'),
('CC1003', '2025-08-02 10:40:33', 'T', 'Bebidas y snacks',          'A'),
('CC1004', '2025-08-05 13:50:00', 'C', 'Dulces y panadería',        'A');

-- CC1001
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1001' AND fecha='2025-07-02 10:15:23'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Café de Colombia 500g'), 2, 56000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1001' AND fecha='2025-07-02 10:15:23'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Leche entera 1L'), 3, 12600.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1001' AND fecha='2025-07-02 10:15:23'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Pan campesino'), 2, 7000.00, 1);

-- CC1002
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1002' AND fecha='2025-07-03 18:45:10'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Gaseosa cola 1.5L'), 4, 26000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1002' AND fecha='2025-07-03 18:45:10'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Papas fritas 150g'), 5, 27500.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1002' AND fecha='2025-07-03 18:45:10'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Maní salado 200g'), 2, 14000.00, 1);

-- CC1003
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1003' AND fecha='2025-07-05 09:05:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Detergente líquido 1L'), 1, 12000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1003' AND fecha='2025-07-05 09:05:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Jabón en barra 3un'), 1,  8000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1003' AND fecha='2025-07-05 09:05:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Agua sin gas 600ml'), 6, 13200.00, 1);

-- CC1001
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1001' AND fecha='2025-07-10 14:22:40'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Café Orgánico Sierra Nevada 250g'), 1, 22000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1001' AND fecha='2025-07-10 14:22:40'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Mermelada fresa 300g'), 1,  7500.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1001' AND fecha='2025-07-10 14:22:40'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Pan campesino'), 1,  3500.00, 1);

-- CC1004
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1004' AND fecha='2025-07-12 11:11:11'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Yogur natural 1L'), 2, 12000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1004' AND fecha='2025-07-12 11:11:11'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Té verde botella 500ml'), 3, 11400.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1004' AND fecha='2025-07-12 11:11:11'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Chocolate de mesa 250g'), 1,  9000.00, 1);

-- CC1005
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1005' AND fecha='2025-07-15 19:35:05'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Café de Colombia 500g'), 1, 28000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1005' AND fecha='2025-07-15 19:35:05'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Leche entera 1L'), 4, 16800.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1005' AND fecha='2025-07-15 19:35:05'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Gaseosa cola 1.5L'), 2, 13000.00, 1);

-- CC1006
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1006' AND fecha='2025-07-18 08:55:30'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Detergente líquido 1L'), 2, 24000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1006' AND fecha='2025-07-18 08:55:30'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Jabón en barra 3un'), 2, 16000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1006' AND fecha='2025-07-18 08:55:30'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Agua sin gas 600ml'), 12, 26400.00, 1);

-- CC1007
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1007' AND fecha='2025-07-20 16:01:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Croissant mantequilla'), 6, 15000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1007' AND fecha='2025-07-20 16:01:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Café Orgánico Sierra Nevada 250g'), 2, 44000.00, 1);

-- CC1008
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1008' AND fecha='2025-07-25 12:20:45'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Papas fritas 150g'), 10, 55000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1008' AND fecha='2025-07-25 12:20:45'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Gaseosa cola 1.5L'), 5, 32500.00, 1);

-- CC1002
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1002' AND fecha='2025-08-01 17:05:12'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Leche entera 1L'), 8, 33600.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1002' AND fecha='2025-08-01 17:05:12'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Yogur natural 1L'), 4, 24000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1002' AND fecha='2025-08-01 17:05:12'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Pan campesino'), 4, 14000.00, 1);

-- CC1003
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1003' AND fecha='2025-08-02 10:40:33'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Té verde botella 500ml'), 5, 19000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1003' AND fecha='2025-08-02 10:40:33'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Agua sin gas 600ml'), 10, 22000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1003' AND fecha='2025-08-02 10:40:33'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Maní salado 200g'), 3, 21000.00, 1);

-- CC1004
INSERT INTO miscompras.compras_productos (id_compra, id_producto, cantidad, total, estado) VALUES
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1004' AND fecha='2025-08-05 13:50:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Chocolate de mesa 250g'), 2, 18000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1004' AND fecha='2025-08-05 13:50:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Mermelada fresa 300g'), 2, 15000.00, 1),
((SELECT id_compra FROM miscompras.compras WHERE id_cliente='CC1004' AND fecha='2025-08-05 13:50:00'),
 (SELECT id_producto FROM miscompras.productos WHERE nombre='Café de Colombia 500g'), 1, 28000.00, 1);