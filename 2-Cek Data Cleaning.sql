-- Data Cleaning (bersih semua)
-- TABEL SUPLIERS (TIDAK ADA DUPLIKAT)
WITH DUPLI AS (
SELECT * , row_number () OVER (partition by supplier_name) AS ROW_NUM
FROM suppliers  )
SELECT * 
FROM DUPLI
WHERE ROW_NUM > 1
; 

-- TABLE WAREHOUSE (AMAN)
SELECT * 
FROM warehouses 
; 

-- TABLE PRODUCTS (TIDAK ADA DUPLIKAT)
WITH DUPLI_PRODUCT AS (
SELECT * , ROW_NUMBER() OVER (PARTITION BY PRODUCT_ID, PRODUCT_NAME) AS ROW_NUM
FROM PRODUCTS ) 
SELECT * 
FROM DUPLI_PRODUCT
WHERE ROW_NUM > 1
; 
-- CEK NULL 
SELECT * 
FROM PRODUCTS
WHERE
	product_id IS NULL OR 
    product_name IS NULL OR 
    category IS NULL OR 
    supplier_id IS NULL OR
    unit_cost IS NULL OR
    reorder_level IS NULL
;

-- TABLE PURCHASE_ORDER (TIDAK ADA DUPLIKAT)
WITH DUPLI_PO AS (
SELECT * , ROW_NUMBER() OVER(PARTITION BY PO_ID, PO_DATE) AS ROW_NUM
FROM purchase_orders )
SELECT * 
FROM DUPLI_PO
WHERE ROW_NUM > 1
; 
    
SELECT * 
FROM purchase_orders
WHERE
	po_id IS NULL OR 
    po_date IS NULL OR 
    supplier_id IS NULL OR 
    product_id IS NULL OR
    quantity_ordered IS NULL OR
    po_amount IS NULL OR
    po_status IS NULL
;

-- RAPIIN PO STATUS (ADA HIDDEN CHAR)
SELECT PO_STATUS , REGEXP_REPLACE(PO_STATUS, '[[:cntrl:]]', 'G')
FROM purchase_orders; 

UPDATE purchase_orders
SET PO_STATUS = REGEXP_REPLACE(PO_STATUS, '[[:cntrl:]]', ''); 

SELECT * FROM purchase_orders WHERE PO_STATUS = 'CANCELLED'; 

-- TABEL SALES ORDER (TIDAK ADA DUPLIKAT)
WITH DUPLI_SO AS (
SELECT * ,  
ROW_NUMBER() OVER(PARTITION BY SO_ID, PRODUCT_ID, WAREHOUSE_ID) AS ROW_NUM 
FROM SALES_ORDERS)
SELECT * 
FROM DUPLI_SO
WHERE ROW_NUM > 1
; 

SELECT * 
FROM sales_orders
WHERE
	so_id IS NULL OR 
    so_date IS NULL OR 
    product_id IS NULL OR
    warehouse_id IS NULL OR
    quantity_sold IS NULL OR
    so_status IS NULL
;

-- RAPIIN SO STATUS 
SELECT SO_STATUS , REGEXP_REPLACE(SO_STATUS, '[[:cntrl:]]', 'G')
FROM sales_orders; 

UPDATE sales_orders
SET SO_STATUS = REGEXP_REPLACE(SO_STATUS, '[[:cntrl:]]', ''); 

SELECT * 
FROM sales_orders
WHERE SO_STATUS = 'BACKORDER'; 



-- TABLE STOCK MOVEMNET (TIDAK ADA DUPLIKAT)

WITH DUPLI_SM AS (
SELECT * , ROW_NUMBER() OVER(PARTITION BY MOVEMENT_ID,MOVEMENT_DATE, PRODUCT_ID, WAREHOUSE_ID, MOVEMENT_TYPE, QUANTITY) AS ROW_NUM 
FROM stock_movements)
SELECT * 
FROM DUPLI_SM
WHERE ROW_NUM > 1
;

-- GADA NILAI NULL
SELECT * 
FROM stock_movements
WHERE
	movement_id IS NULL OR 
    movement_date IS NULL OR 
    product_id IS NULL OR
    warehouse_id IS NULL OR
    movement_type IS NULL OR
    quantity IS NULL OR
    stock_after_movement IS NULL
;

-- RAPIIN BARIS 
select movement_type, upper(trim(movement_type))
from stock_movements; 

update stock_movements
set movement_type = upper(trim(movement_type)); 


-- hapus qunatity out nya 0 
SELECT * FROM stock_movements
where quantity = 0; 

delete from stock_movements
where quantity = 0; 




