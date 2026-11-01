
-- 1. Tabel Suppliers (dari suppliers.csv)
CREATE TABLE suppliers (
    supplier_id VARCHAR(50) PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    supplier_type VARCHAR(100),
    lead_time_days INT
);

-- 2. Tabel Warehouses (dari warehouses.csv)
CREATE TABLE warehouses (
    warehouse_id VARCHAR(50) PRIMARY KEY,
    warehouse_name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    capacity_sqm INT
);

-- 3. Tabel Products (dari products.csv)
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    supplier_id VARCHAR(50),
    unit_cost BIGINT,
    reorder_level INT
);

-- 4. Tabel Purchase Orders (dari purchase_orders.csv)
CREATE TABLE purchase_orders (
    po_id VARCHAR(50) PRIMARY KEY,
    po_date DATE NOT NULL,
    supplier_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity_ordered INT,
    po_amount BIGINT,
    po_status VARCHAR(50)
);

-- 5. Tabel Sales Orders (dari sales_orders.csv)
CREATE TABLE sales_orders (
    so_id VARCHAR(50) PRIMARY KEY,
    so_date DATE NOT NULL,
    product_id VARCHAR(50),
    warehouse_id VARCHAR(50),
    quantity_sold INT,
    so_status VARCHAR(50)
);

-- 6. Tabel Stock Movements (dari stock_movements.csv)
CREATE TABLE stock_movements (
    movement_id VARCHAR(50) PRIMARY KEY,
    movement_date DATE NOT NULL,
    product_id VARCHAR(50),
    warehouse_id VARCHAR(50),
    movement_type VARCHAR(20),
    quantity INT,
    stock_after_movement INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/warehouses.csv' 
INTO TABLE warehouses
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;

select * from stock_movements; 



CREATE TABLE ANALISIS_GUDANG AS 
WITH ITUNGAN_STOCK AS (
SELECT 
    *, 
    ROW_NUMBER () OVER(PARTITION BY WAREHOUSE_ID, PRODUCT_ID ORDER BY MOVEMENT_ID DESC, movement_date DESC) AS URUTAN_PERGERAKAN
FROM
    stock_movements
), 
CURRENT_STOK AS (
SELECT MOVEMENT_ID, MOVEMENT_DATE, WAREHOUSE_ID, PRODUCT_ID, STOCK_AFTER_MOVEMENT AS STOK_SEKARANG 
FROM ITUNGAN_STOCK
WHERE URUTAN_PERGERAKAN = 1
)
SELECT 
	SM.warehouse_id, 
    W.CITY,
	SM.product_id, 
    COUNT(CASE WHEN SM.movement_type LIKE '%IN%' THEN 1 END) AS FREQ_MASUK, 
    SUM(CASE WHEN SM.movement_type LIKE '%IN%' THEN quantity ELSE 0 END) AS QTY_MASUK,
    COUNT(CASE WHEN SM.movement_type LIKE '%OUT%' THEN 1 END) AS FREQ_KELUAR, 
    SUM(CASE WHEN SM.movement_type LIKE '%OUT%' THEN quantity ELSE 0 END) AS QTY_KELUAR,
    CS.STOK_SEKARANG,
    P.UNIT_COST, 
    CS.STOK_SEKARANG * P.UNIT_COST AS ASET,
    W.CAPACITY_SQM
FROM stock_movements SM
JOIN CURRENT_STOK CS
	ON SM.product_id = CS.product_id AND SM.warehouse_id = CS.warehouse_id
JOIN PRODUCTS P 
	ON SM.product_id = P.product_id
LEFT JOIN warehouses W 
	ON SM.warehouse_id = W.warehouse_id
group by SM.warehouse_id, W.CITY, SM.product_id, CS.STOK_SEKARANG, W.CAPACITY_SQM
order by SM.warehouse_id, W.CITY, SM.product_id, CS.STOK_SEKARANG, W.CAPACITY_SQM
; 

SELECT 
	warehouse_id,
    city, 
    CAPACITY_SQM, 
    SUM(FREQ_MASUK) AS TOTAL_FREQ_MASUK,
    SUM(QTY_MASUK) AS TOTAL_QTY_MASUK,
    SUM(FREQ_KELUAR) AS TOTAL_FREQ_KELUAR,
    SUM(QTY_KELUAR) AS TOTAL_QTY_KELUAR,
    SUM(FREQ_MASUK) + SUM(FREQ_KELUAR) AS TOTAL_TRANSAKSI, 
    ROUND((SUM(FREQ_MASUK) + SUM(FREQ_KELUAR))/ CAPACITY_SQM, 2) AS TRANSAKSI_PER_METER,
    SUM(STOK_SEKARANG) AS TOTAL_STOCK, 
    SUM(ASET) AS TOTAL_ASET,
    ROUND(SUM(ASET) / CAPACITY_SQM, 2) AS ASET_PER_METER
FROM ANALISIS_GUDANG
GROUP BY 
	warehouse_id,
    city , 
     CAPACITY_SQM
;

-- buat tabel turn over

CREATE TABLE laporan_turnover_stok AS 
WITH Pergerakan_Urut AS (
    SELECT 
        warehouse_id,
        product_id,
        movement_type,
        quantity,
        stock_after_movement,
        ROW_NUMBER() OVER (
            PARTITION BY warehouse_id, product_id 
            ORDER BY movement_date ASC, movement_id ASC
        ) as urutan_transaksi
    FROM stock_movements
),
Stok_Awal_Table AS (
    SELECT 
        warehouse_id,
        product_id,
        CASE 
            WHEN UPPER(TRIM(movement_type)) = 'IN' THEN stock_after_movement - quantity
            WHEN UPPER(TRIM(movement_type)) = 'OUT' THEN stock_after_movement + quantity
            ELSE 0 
        END AS stok_awal
    FROM Pergerakan_Urut
    WHERE urutan_transaksi = 1
),
Mutasi_Stok AS (
    SELECT 
        warehouse_id,
        product_id,
        SUM(CASE WHEN UPPER(TRIM(movement_type)) = 'IN' THEN quantity ELSE 0 END) AS total_in,
        SUM(CASE WHEN UPPER(TRIM(movement_type)) = 'OUT' THEN quantity ELSE 0 END) AS total_out
    FROM stock_movements
    GROUP BY warehouse_id, product_id
),
Kalkulasi_Stok AS (
    SELECT 
        sa.warehouse_id,
        sa.product_id,
        sa.stok_awal,
        ms.total_in,
        ms.total_out,
        (sa.stok_awal + ms.total_in - ms.total_out) AS stok_akhir_aktual
    FROM Stok_Awal_Table sa
    JOIN Mutasi_Stok ms 
        ON sa.warehouse_id = ms.warehouse_id AND sa.product_id = ms.product_id
)

SELECT 
    w.warehouse_name,
    p.product_name,
    ks.stok_awal,
    ks.total_in AS barang_masuk,
    ks.total_out AS barang_terjual,
    ks.stok_akhir_aktual,
    ROUND(
        ks.total_out / NULLIF(((ks.stok_awal + ks.stok_akhir_aktual) / 2), 0), 2
    ) AS turnover_ratio,
    ROUND(
        365 / NULLIF((ks.total_out / NULLIF(((ks.stok_awal + ks.stok_akhir_aktual) / 2), 0)), 0), 0
    ) AS hari_mengendap, 
    p.reorder_level
FROM Kalkulasi_Stok ks
JOIN products p ON ks.product_id = p.product_id
JOIN warehouses w ON ks.warehouse_id = w.warehouse_id;

create table total_aset_warehouse as 
with urutan_movement as (
select 
	* , 
	row_number() over(partition by warehouse_id, product_id order by movement_date, movement_id) as urutan
from stock_movements as urutan
) , 
stock_awal as (
select * , 
case
	when urutan = 1 and movement_type like '%IN%' then stock_after_movement - quantity 
    when urutan = 1 and movement_type like '%OUT%' then stock_after_movement + quantity 
    else 0 
end as stock_awal_product
from urutan_movement

), 
Stok_Terkini AS (
    SELECT 
        warehouse_id,
        product_id,
        max(stock_awal_product) + SUM(CASE WHEN UPPER(TRIM(movement_type)) = 'IN' THEN quantity ELSE 0 END) - SUM(CASE WHEN UPPER(TRIM(movement_type)) = 'OUT' THEN quantity ELSE 0 END) AS sisa_stok
    FROM stock_awal
    GROUP BY 
        warehouse_id, 
        product_id
)
SELECT 
    w.warehouse_name,
    st.warehouse_id,
    SUM(st.sisa_stok * p.unit_cost) AS total_nilai_aset
FROM Stok_Terkini st
JOIN products p ON st.product_id = p.product_id
JOIN warehouses w ON st.warehouse_id = w.warehouse_id
GROUP BY 
    w.warehouse_name,
    st.warehouse_id
ORDER BY 
    total_nilai_aset DESC;
    
-- 4. BAGAIMANA TOTAL PENGADAAN DARI SUPLIER LOKAL VS IMPROT

SELECT 
    S.supplier_type,
    SUM(P.po_amount) AS TOTAL_PENGADAAN,
    COUNT(P.PO_ID) AS JUMLAH_TRANSAKSI,
    CONCAT(ROUND(AVG(S.lead_time_days)), ' HARI') AS LAMA_RATA2_PENGADAAN
FROM
    suppliers S
        JOIN
    purchase_orders P ON S.supplier_id = P.supplier_id
GROUP BY S.supplier_type
; 

