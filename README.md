# Inventory & Supply Chain Performance Dashboard

**Turning Inventory Data into Actionable Business Insights**

## 1. Title & Short Summary

I built an interactive Power BI dashboard to analyze inventory and supply chain performance at PT. XYZ Logistic throughout 2025. The analysis surfaced two problems happening at the same time: **Rp133.7 billion of capital is tied up in overstock**, while **103 product-warehouse combinations face a stockout risk**. From these findings, I explored ways to optimize inventory, including inter-warehouse transfers to address 96 of the 103 product-warehouse combinations at risk of running short.

**Tools:** SQL (MySQL), Power BI

## 2. Background & Business Problems

In supply chain operations, product availability depends not only on how much inventory a company holds, but also on how well that inventory is managed and distributed. Too much stock ties up capital, while too little can get in the way of fulfilling customer orders.

With that in mind, I developed an inventory and supply chain analysis project for PT. XYZ Logistic, a logistics company that, in this project's scenario, manages 300 SKUs across eight warehouses in cities throughout Indonesia. I used operational data from 2025 to get a fuller picture of inventory conditions, stock movements, and warehouse performance.

From a business perspective, I focused on three main problems.

**First, stock buildup that ties up company capital.** I identified products whose inventory levels exceed operational needs. Overstock like this can raise storage costs and leave capital stuck in goods that move relatively slowly.

**Second, stockout risk caused by a reorder policy that isn't adaptive enough.** A static reorder level can overlook differences in demand patterns, sales velocity, and inventory needs across warehouses. As a result, the company may reorder at the wrong time, either too early or too late.

**Third, a potential imbalance in inventory distribution between warehouses.** When one warehouse holds excess stock while another runs short of the same item, the company should consider whether the need can be met by redistributing inventory before placing additional purchases.

These three problems pushed me to see inventory not just as a count of goods on hand, but as a resource that has to be managed efficiently. I wanted to build visualizations that help identify inventory conditions, monitor supply chain indicators, and spot opportunities for better, data-driven action.

## 3. Objectives & Analytical Questions

After identifying the problems in inventory management, I wanted to understand how data could help the company set ordering priorities, evaluate supplier performance, and optimize stock distribution across warehouses.

I didn't want this dashboard to be just a tool for tracking inventory numbers. I wanted it to be an analytical tool that helps the supply chain team understand operations, spot potential inefficiencies, and decide on actions based on data.

To that end, I defined four main analytical questions that guided the data processing, the visualization design, and the recommendations in this dashboard.

#### 1. Inventory Planning

**Which products need to be reordered, and how much stock is required?**

I wanted to identify products at risk of running out of stock by looking at current inventory levels, stock requirements, and reorder levels. This analysis helps prioritize reorders so that availability is protected without adding excess inventory.

#### 2. Supplier Performance

**Which suppliers have the longest lead times and absorb the largest purchasing budgets?**

I wanted to evaluate supplier performance based on order fulfillment time and the size of the budget allocated. By comparing local and import suppliers, I can identify which suppliers deserve a closer look in terms of delivery reliability and procurement efficiency.

#### 3. Warehouse Efficiency

**Which warehouses carry excess inventory, and how can stock distribution be optimized?**

I wanted to compare inventory conditions across warehouses to find locations with stock buildup and potential distribution imbalances. The results can serve as a basis for evaluating inter-warehouse transfer opportunities before the company makes additional purchases.

#### 4. Inventory Capital

**How much capital is tied up in slow-moving or unsold stock?**

I wanted to measure the value of inventory that may be unproductive because of low movement. This analysis shows how much capital is locked in inventory and gives a sense of the opportunity to use company capital more effectively.

These four questions are the foundation of the Inventory & Supply Chain Performance dashboard. Each visualization is designed to answer a specific analytical need, so the information shown not only describes operations but also draws attention to the issues that call for further evaluation and action.

## 4. Data Understanding & Preparation

### Understanding the Dataset

Before analyzing inventory performance, I first studied the structure and characteristics of the available data. I worked with six CSV files covering January 1 to December 31, 2025, with the inventory position analyzed based on the final balances as of December 2025.

I obtained the dataset from [Rocket Tutor](https://rocket-tutor.myr.id/). It is a simulated dataset designed to resemble the operations of a logistics company, so I used it as a business scenario to explore inventory and supply chain management problems.

I grouped the six tables into three master tables that hold reference information and three transaction tables that record operational activity. This structure let me connect product, supplier, warehouse, purchasing, sales, and stock movement information in a single analytical model.

### Mapping the Data

I mapped each table based on its role in answering the business questions I had defined.

**Master Data**

- **Products: 300 products.** I used product and category information to analyze inventory conditions by type of goods. Each product is linked to one supplier.
- **Suppliers: 80 suppliers.** I used supplier type (42 import and 38 local suppliers) and lead times of 2–30 days to evaluate procurement performance.
- **Warehouses: 8 warehouses.** I used warehouse location and capacity data to compare inventory conditions and asset density across regions.

**Transaction Data**

- **Purchase Orders: 1,500 orders.** I used order quantities, PO values, and transaction status to evaluate purchasing activity and compare budget allocation across suppliers.
- **Sales Orders: 2,500 orders.** I used sales quantities and order status to understand demand fulfillment and identify orders that ended up as backorders.
- **Stock Movements: 8,356 records.** This table became one of my main sources of analysis because it records the movement date, the type of transaction (inbound or outbound), the quantity, and the stock balance after each movement.

Overall, the data shows 504,526 units of inbound stock and 377,009 units of outbound stock. The gap between the two gives an early picture of inventory dynamics, although it can't explain every change in stock without considering opening balances and other transactions.

### Data Modeling & Unit of Analysis

Once I understood the table structure, I chose the **product-warehouse combination as the main unit of analysis**. This approach lets me evaluate inventory at a more granular level instead of looking only at the company's total stock.

With 300 products and 8 warehouses, 2,400 product-warehouse combinations are possible. However, the dataset covers only 2,328 of them. I kept this difference in the analysis so that combinations with no records wouldn't automatically be treated as zero stock without sufficient evidence.

I then linked the tables through `product_id`, `supplier_id`, and `warehouse_id`. In my initial checks, every ID in the transaction tables had a matching entry in the master tables.

This structure became the basis for merging the data and building the indicators needed in the dashboard. I also paid attention to the level of detail in each table so that joins wouldn't cause double counting of purchase, sales, or inventory values.

### Key Variables & Derived Metrics

I didn't rely only on the variables available in the data. I also built several indicators to connect operational data with business analysis needs.

#### 1. Current Stock & Inventory Value

I used `stock_after_movement`, `movement_type`, `quantity`, and `movement_date` to trace inventory changes. To get the latest stock balance, I took the most recent movement record for each product-warehouse combination and linked it to `unit_cost`.

Inventory asset value is calculated with this formula:

**Asset Value = Current Stock × Unit Cost**

This approach gives a total inventory asset value of **Rp347.35 billion**, based on final balances and the unit costs available in the dataset.

#### 2. Backorder Rate

To measure the share of orders that couldn't be fulfilled because of stock shortages, I calculated the backorder rate as the number of Backorder orders compared with all orders with Fulfilled and Backorder status.

**Backorder Rate = Backorder ÷ (Fulfilled + Backorder) × 100%**

The result is a backorder rate of **10.26%**, based on 244 Backorder orders out of 2,378 orders included in the calculation.

I excluded Cancelled orders from the denominator because they don't represent demand that still needs to be fulfilled.

#### 3. Asset Density per Warehouse

I calculated inventory asset value per square meter by dividing each warehouse's total asset value by its capacity in square meters.

**Asset per m² = Warehouse Inventory Asset Value ÷ Warehouse Capacity (m²)**

This indicator helps me compare inventory value density across warehouses. That said, I use it as a comparison indicator, not as a direct measure of how physically full a warehouse is.

#### 4. Supplier Lead Time & Procurement Budget

I used `supplier_type`, `lead_time_days`, `quantity_ordered`, `po_amount`, and `po_status` to analyze supplier performance.

In this project, I categorize suppliers with a lead time of at least 25 days as long lead time suppliers. I also compared PO values across suppliers to see how the procurement budget is distributed.

The 25-day threshold is an analytical criterion I set for this project, not a universal standard for judging supplier performance.

#### 5. Stock Status & Reorder Evaluation

I used the latest stock and `reorder_level` to evaluate the inventory status of each product-warehouse combination. This indicator is the basis for identifying products that need attention, from excess stock to the risk of running out.

I also considered the relationship between available stock and procurement needs to set priorities for reorder evaluation.

For a more adaptive analysis, reorder levels could be compared against estimated demand during lead time plus safety stock. That approach, however, requires consistent demand calculations and clear assumptions.

### Data Quality Assessment

Before using the data, I ran quality checks to confirm format consistency, uniqueness, completeness, and relationships between tables.

Overall, the initial checks showed no missing values, duplicate rows, or duplicate IDs in columns that should be unique. I also checked stock balances for consistency with the preceding movement quantities.

Even so, I found a few conditions worth noting.

**Inconsistent Date Formats**

I found 30 rows in the `stock_movements` table using the date format `2025/12/31`, while the remaining rows used `2025-12-31`. This difference needed to be standardized so dates could be read consistently and used in time-based analysis.

**Inconsistent Movement Types**

In 60 rows, the `movement_type` column used lowercase `in` and `out`, while the rest used `IN` and `OUT`. I flagged the need to standardize the spelling so that stock movement groupings wouldn't split what are really the same category.

**Zero-Quantity Movements**

I found 215 movement records with a quantity of zero. These records need to be examined to understand whether they are administrative entries, records with no effect on the balance, or data that isn't needed for certain calculations.

I didn't delete them right away, because that decision has to take into account the function each record serves in the inventory recording system.

**Limited Movement History**

A total of 277 product-warehouse combinations have only one movement record. This limits the information available for understanding the historical movement patterns of those combinations.

Because of this, I needed to distinguish between stock that is truly inactive and stock that simply has a limited recording history. A single movement record isn't enough to prove that a product has no demand.

### Data Limitations & Analytical Considerations

Besides checking data quality, I also identified several limitations that could affect how the results are interpreted.

#### 1. Purchase Order Value vs. Inventory Value

The `po_amount` value doesn't always equal `quantity_ordered` multiplied by `unit_cost` across all 1,500 purchase orders.

For that reason, I used PO values to compare budgets across suppliers, not as a component that can be directly reconciled with inventory asset value. This difference has to be kept in mind when interpreting the results so that the two indicators aren't treated as representing the same economic value.

#### 2. Sales Orders vs. Stock Movements

The data records about 186 thousand units sold, while total outbound stock reaches 377,009 units. The two figures have different scopes and can't be directly compared as equivalent measures.

I found no direct key that would let each sales order be traced to a corresponding outbound stock record. Because of this, I analyzed sales data and stock movement data as two separate sources of information, without assuming that all outbound stock came from sales.

#### 3. Limited Time Coverage

This analysis covers only one year, 2025. That period is enough to describe operations during the observation year, but not enough to identify seasonal patterns that repeat from year to year.

As a result, trend findings should be read in the context of the available period and shouldn't be assumed to represent long-term demand patterns.

### From Raw Data to Business Analysis

Through this process, I gained an understanding of the data structure, the relationships between tables, the relevant indicators, and the limitations to consider before drawing conclusions.

To me, this stage is an important foundation of the analysis. Data that has been carefully checked and understood helps me build more consistent indicators, reduces the risk of misinterpretation, and ensures that the resulting visualizations actually relate to the business questions I want to answer.

## 5. Methodology & Tools

### From Raw Data to Actionable Insights

After understanding the data structure and the business problems I wanted to analyze, I started building a workflow to turn raw data into information that is useful for inventory and supply chain management.

I used MySQL to process the data, run exploration, build analytical indicators, and prepare derived tables. I then used those outputs in Power BI to build an interactive dashboard connecting inventory conditions, warehouse performance, and supplier performance.

For me, the main challenge in this process wasn't simply combining six CSV files. It was making sure every indicator had a consistent definition and could be used to answer the business questions I had set.

### 1. Analytical Workflow

I organized the analysis into stages so that each processed result could be reused and stay consistent when displayed in the dashboard.

**CSV → MySQL → Data Cleaning → Exploratory Data Analysis → Analytical Tables → Power BI Dashboard → Insights & Recommendations**

I started by importing the six CSV files into MySQL, then checked the structure, data types, value consistency, and relationships between tables. After the necessary cleaning, I explored inventory characteristics, purchasing and sales activity, and stock movements during 2025.

Based on that exploration, I built four derived tables, each designed for a different analytical need.

- **`analisis_gudang`**: summarizes the frequency and quantity of stock movements, the latest inventory balance, and asset value for each product-warehouse combination.
- **`laporan_turnover_stok`**: analyzes opening stock, inbound and outbound goods, closing stock, inventory turnover, and estimated days inventory sits idle.
- **`total_aset_warehouse`**: compares inventory asset value across warehouses and identifies locations with a high concentration of asset value.
- **`klasifikasi_stock`**: groups inventory conditions by stock status, estimated daily demand, days of cover, and the need for reorder evaluation.

By separating the results into these tables, I could reuse the SQL calculations when building visualizations in Power BI, and I didn't have to rewrite the analytical logic for every visual.

### 2. Core Analytical Logic

With the data processing flow in place, I defined the calculation logic used to measure inventory conditions and identify areas that need attention.

#### Determining Current Stock

I used the `ROW_NUMBER()` window function to identify the last movement record for each product-warehouse combination. The `stock_after_movement` value from that record is then used as the latest inventory balance in the analysis.

This approach gives me the stock position at the end of the period without summing all post-movement balances, which would cause double counting.

#### Calculating Inventory Value

To understand how much capital is tied up in inventory, I multiplied the latest stock by each product's unit cost.

**Inventory Value = Current Stock × Unit Cost**

I used this result to analyze inventory asset value overall, by warehouse, and by stock status.

#### Estimating Daily Demand and Days of Inventory Cover

I calculated average daily sales by dividing the total quantity of non-Cancelled orders by 365 days.

**Daily Demand = Total Non-Cancelled Sales Quantity ÷ 365**

I then used the *days of cover* indicator to estimate how long the available inventory can meet average daily sales.

**Days of Cover = Current Stock ÷ Daily Demand**

This indicator helps me compare stock sufficiency against supplier lead time. If inventory is expected to run out before the next delivery arrives, the product needs closer attention.

In my interpretation, I treat average daily sales as a proxy for demand. This calculation assumes that the quantity of non-cancelled orders can be used to estimate sales during the observation period.

#### Measuring Inventory Turnover

I calculated the turnover ratio to evaluate how quickly inventory turns over during the analysis period.

**Turnover Ratio = Total Stock Out ÷ Average Inventory**

Using average inventory calculated from opening and closing stock, I then estimated the days inventory sits idle with this formula:

**Days Inventory Outstanding = 365 ÷ Turnover Ratio**

Together, these two indicators help me tell relatively active products apart from low-turnover ones. How they are interpreted still depends on how consistently outbound stock is recorded and whether opening balance data is available.

#### Classifying Inventory Status

I translated the inventory indicators into six statuses so that stock conditions are easier to monitor and prioritize in the dashboard.

The classification is applied in order using `CASE WHEN`, so the first condition that is met becomes the product's final status.

| Status | Classification Rule |
|---|---|
| Inactive | Zero stock and no demand during the observation period. |
| Overstock | Stock on hand, but no demand during the observation period. |
| Stockout | Zero stock while demand exists. |
| Critical | Days of cover is shorter than supplier lead time. |
| Warning | Stock on hand is at or below the reorder level. |
| Safe | None of the previous conditions are met. |

This approach turns inventory data into categories that are easier to understand and act on. Stock status also directs attention to products that need reordering, inventory review, or further checks.

#### Developing a Reorder Threshold

I also used a rule-based approach to build a recommended reorder level that accounts for demand during lead time plus additional safety stock.

The formula I used is:

**Recommended Reorder Level = (Daily Demand × Supplier Lead Time) + (Maximum Daily Demand × 90 Days)**

The first component estimates the demand while waiting for delivery, and the second adds a safety buffer based on the maximum daily demand over 90 days.

I used the result as a basis for evaluating reorder needs against the static reorder level available in the data.

Because the safety stock component uses the maximum daily demand during the observation period, this is a rule I set for the project, not a statistical safety stock estimate that accounts for demand distribution and lead time variability.

#### Measuring Backorder Rate

To complete the inventory analysis, I calculated the backorder rate as the share of orders with Backorder status out of all orders with Fulfilled and Backorder status.

**Backorder Rate = Backorder ÷ (Fulfilled + Backorder) × 100%**

I excluded Cancelled orders so the indicator stays focused on orders that are still relevant for evaluating demand fulfillment.

### 3. Tools Implementation

In this project, I used two main tools with complementary roles.

#### MySQL 8.0: Data Preparation & Analysis

I used MySQL to store the raw data, clean it, explore it, and build the analytical tables.

I imported all six CSV files with `LOAD DATA INFILE` into tables with defined data types such as `VARCHAR`, `INT`, `BIGINT`, and `DATE`, and set primary keys according to each table's structure.

During the analysis, I used several SQL features to handle different data processing needs:

- **CTEs and JOINs:** structure the query steps and combine information from multiple tables.
- **Window Functions:** use `ROW_NUMBER()`, `LAG()`, and `AVG() OVER()` to identify the latest movement, compare values across rows, and calculate indicators by group.
- **CASE WHEN:** build the stock status classification rules and group inventory conditions.
- **CREATE TABLE AS:** save processed results into derived tables that can be reused in later analysis.

Using SQL let me process data at the product-warehouse level and produce the indicators that form the foundation of the dashboard.

#### Power BI: Visualization & Business Monitoring

After preparing the analytical tables in MySQL, I used Power BI to build a dashboard that brings together inventory, warehouse performance, stock movements, and supplier performance.

I designed the visualizations so that users can see the key indicators first and then drill into the details behind them. The dashboard includes KPI cards, a stock status distribution chart, an inventory monitoring table, a monthly stock movement trend, a warehouse performance comparison, and the relationship between supplier lead time and budget.

I also added interactive filters so information can be reviewed by period, warehouse, supplier type, and product category as the analysis requires.

By combining MySQL and Power BI, I built a workflow that connects structured data processing with information that is easier to understand. The end result isn't just a set of charts with numbers, but a dashboard designed to help identify inventory problems and pinpoint areas for further evaluation.

## 6. Data Cleaning & Preparation

### Ensuring Data Quality Before Analysis

Before calculating KPIs and analyzing inventory performance, I first made sure the data was of adequate quality and consistency. Small errors, such as differences in how a category is spelled or inconsistent date formats, can affect the grouping, calculations, and visualizations in the dashboard.

I did all of the data cleaning in MySQL. The process covered checks for duplicates, missing values, and referential consistency between tables, as well as standardization of the values used in the analysis.

### 1. Data Quality Checks

I started by checking the six tables for issues that could affect the reliability of the analysis.

#### Duplicate Records

I checked for possible duplicates using `ROW_NUMBER()` on the column combinations relevant to each table. For example, I checked the `po_id` and `po_date` combination in the purchasing data, and `so_id`, product, and warehouse in the sales data.

The checks found no duplicate rows based on those criteria. In addition, primary keys on the ID columns help ensure that each recorded entity is unique.

#### Missing Values

I checked every column in all six tables using `IS NULL` to find missing values.

The checks showed no `NULL` values in the columns examined, so I could continue processing without imputing any missing data.

#### Referential Integrity

I also checked the relationships between the transaction tables and the master tables to make sure every `product_id`, `supplier_id`, and `warehouse_id` in use had a matching reference.

The check showed that every ID used in transactions had a match in the master tables. This helped me avoid orphan records when joining tables with `JOIN`.

### 2. Data Standardization & Correction

With no duplicate, missing, or invalid reference issues, I moved on to standardizing data formats so they could be processed consistently.

#### Standardizing Movement Types

I found 60 rows in the `movement_type` column using lowercase `in` and `out`, while the other categories used uppercase.

To fix this, I used:

`UPPER(TRIM(movement_type))`

This standardizes the case and also removes leading and trailing spaces. As a result, all movement categories can be grouped consistently, without being read as different categories just because of formatting.

#### Cleaning Sales Order Status and Purchase Order Status

### Cleaning Sales Order Status and Purchase Order Status

I used `REGEXP_REPLACE()` with the `[[:cntrl:]]` pattern to identify and remove hidden control characters from the `so_status` and `po_status` columns in the `sales_orders` and `purchase_orders` tables.

This step ensures that status values are stored consistently, preventing hidden characters from causing inconsistencies when categorizing, filtering, grouping, or calculating KPIs based on statuses such as `Backorder`, `Fulfilled`, and `Cancelled` on `purchase_orders` and `Received`, `Cancelled` and `Open` on `sales_orders`.

#### Validating Date Formats

I found 30 `movement_date` records using slashes as separators, such as `2025/12/31`, which differ from the date format used in the other rows.

I checked the column's data type and import results to make sure the dates were stored as valid `DATE` values rather than plain text.

Once I confirmed that all dates were read correctly, I could use `movement_date` to sort transactions, identify the latest movement, and run period-based analysis.

### 3. Data Preparation for Analysis

After finishing the checks and standardization, I prepared the data to build the indicators needed for the inventory analysis.

#### Reconstructing Beginning Inventory

One challenge I ran into was that opening stock for the year wasn't directly available, even though it's needed to calculate inventory turnover in a more meaningful way.

To work around this, I reconstructed the stock before the first movement for each product-warehouse combination, using the balance after the movement and the quantity of the first transaction.

For inbound movements (*IN*), I calculated:

**Stock Before Movement = Stock After Movement − Quantity**

For outbound movements (*OUT*), I calculated:

**Stock Before Movement = Stock After Movement + Quantity**

I then used the stock before the first movement as an estimate of the opening balance for the inventory reconstruction.

I checked the reconstruction again against the order of movements and the recorded stock balances. Whether the balances matched at each step was the basis for judging how consistent the calculation was.

#### Handling Cancelled Transactions

I separated transactions that are still relevant for demand and procurement analysis from those that have been cancelled.

In the sales data, I excluded orders with `Cancelled` status from the demand and backorder rate calculations, so the calculations focus on orders that weren't cancelled.

In the purchasing data, I excluded POs with `Cancelled` status from the supplier budget calculations, so the value of cancelled orders wouldn't get mixed in with POs that are still relevant to the analysis.

I applied these exclusions according to the purpose of each indicator, without deleting any transaction records from the raw data.

#### Creating Analytical Variables

Once the data was ready, I created derived variables to connect operational records with business analysis needs.

These variables include:

- **Current Stock:** the latest balance for each product-warehouse combination.
- **Inventory Value:** estimated inventory value based on the stock balance and unit cost.
- **Daily Demand:** average daily sales quantity during the observation period.
- **Days of Cover:** the estimated number of days inventory can meet average sales.
- **Inventory Turnover Ratio:** an indicator of inventory turnover based on outbound stock and average inventory.
- **Days Inventory Outstanding:** estimated days inventory sits idle, based on the turnover ratio.
- **Stock Status:** a classification of inventory condition based on stock, demand, lead time, and reorder level.
- **Recommended Reorder Level:** a reorder threshold based on estimated demand during lead time plus safety stock.

I built these variables with SQL queries so that the results could be reused in the analytical tables and the Power BI dashboard.

### 4. Retaining Records for Analytical Integrity

During data cleaning, I didn't delete every record that looked unusual. I kept 215 movement records with zero quantity and 277 product-warehouse combinations that have only one movement record.

I kept the zero-quantity records because a quantity of zero doesn't automatically mean a record is invalid. Deleting them without further checks could remove information that may be relevant to operational recording.

I also kept the product-warehouse combinations with a single movement record, because a small number of records doesn't by itself prove the data is wrong. Those records still provide information about the recorded balance, even if they aren't enough to describe the full historical movement pattern.

By keeping both groups, I avoided deleting data based on assumptions alone and separated data quality problems from limitations in the available information.

### Outcome

After completing the checks, standardization, and data preparation, I ended up with a more consistent dataset for analysis.

I didn't focus only on fixing formats. I also checked relationships between tables, reconstructed the information I needed, and decided how to treat transactions according to the goals of the analysis.

The result is the foundation for the KPI calculations, the stock status classification, and the derived tables used in the *Inventory & Supply Chain Performance* dashboard.

## 7. Exploratory Data Analysis (EDA)

### Discovering Patterns Behind Inventory Imbalances

After finishing data cleaning and preparing the analytical variables, I moved on to *Exploratory Data Analysis (EDA)* using MySQL.

At this stage, I wanted to understand how inventory moved throughout 2025, identify the products and warehouses facing stock problems, and evaluate the factors that affect procurement and distribution efficiency.

Early exploration showed that total inbound stock reached 504,526 units, higher than the 377,009 units of outbound stock. I also found an imbalance in inventory conditions across product-warehouse combinations. Some had excess stock, while others faced a risk of running short.

To understand these problems in more depth, I split the exploration into six areas of analysis. The results became the basis for choosing the indicators, visualizations, and recommendations I present in the dashboard.

### 1. Inventory Shortage Risk: Identifying Products at Risk

**I found 103 product-warehouse combinations that are out of stock or at risk of running out before the next supply arrives.**

I started the exploration by classifying the 2,328 product-warehouse combinations into six inventory statuses, based on the latest stock, daily demand, *days of cover*, supplier lead time, and reorder level.

The classification gives the following distribution:

| Stock Status | Number of Combinations |
|---|---:|
| Safe | 1,091 |
| Overstock | 811 |
| Warning | 265 |
| Stockout | 97 |
| Inactive | 58 |
| Critical | 6 |
| **Total** | **2,328** |

From these results, I grouped the Stockout and Critical categories as the group that needs special attention. There are 97 combinations with zero stock despite having demand, and 6 combinations whose stock is expected to run out before a new order arrives.

I then looked closely at the six Critical combinations. Their *days of cover* ranges only from 5 to 17 days, while supplier lead times range from 15 to 26 days. In other words, the available inventory isn't enough to cover demand while waiting for the next delivery.

When I grouped the risk by product category, Packaging had the most combinations at 27, followed by Raw Material at 24. By location, WH-008 had the most at-risk combinations with 17, followed by WH-006 with 16. WH-003 had the fewest, with 8.

I also found something interesting when comparing the Warning and Safe groups. The median *days of cover* for the Warning group is around 377 days, while for the Safe group it is around 1,605 days. Both figures far exceed supplier lead times.

This suggests that the static reorder level used previously doesn't fully reflect actual inventory needs. A product can land in the Warning category even though its stock is still enough to meet demand for a long time.

> **Key Finding:** Stock shortage risk isn't only about how much inventory is on hand. It also comes from a mismatch between the reorder policy, actual needs, and procurement lead time.

### 2. Reorder Level Analysis: Evaluating Existing Replenishment Rules

**I found that the old reorder levels tend to be higher than the recommendations calculated from the needs and demand characteristics of each product-warehouse combination.**

Having found that the static reorder level doesn't fully reflect inventory conditions, I compared it with a recommended reorder level calculated from daily demand and supplier lead time.

The formula I used is:

**Recommended Reorder Level = (Daily Demand × Lead Time) + (Maximum Daily Demand × 90)**

The first component estimates the demand while waiting for delivery, and the second adds a safety buffer based on the maximum daily demand over 90 days.

The exploration showed that the old reorder levels range from 20 to 300 units, with a median of 173 units. The value is the same for a given product in every warehouse, regardless of demand differences at each location.

In contrast, the recommended reorder levels I calculated range from roughly 90 to 130 units, with a median of 95 units. They are more adaptive because they account for each warehouse's product needs and the supplier's lead time.

Among the combinations with sales records, I found that about 72% of the old reorder levels sit above the new recommendation, with a median ratio of about 1.8 times.

This suggests that the previous reorder level policy was too high for most of the combinations analyzed. That could push the company to hold more inventory than the estimated need.

I also considered that the recommended reorder levels can be reviewed by warehouse managers according to the operating conditions at each location. For products that are overstocked in many warehouses, alternatives such as sales promotions could be considered to help reduce the buildup.

> **Key Finding:** A uniform reorder level isn't necessarily right for every warehouse. The reorder point should take demand characteristics and lead time into account so inventory is neither excessive nor short.

### 3. Backorder Analysis: Understanding Unfulfilled Demand

**I found that backorder problems aren't always visible in year-end stock conditions. Most combinations that experienced backorders actually had a Safe stock status at the end of the observation period.**

I continued the exploration by evaluating sales orders to understand how often the company couldn't meet customer demand.

I calculated the backorder rate as the number of Backorder orders compared with the total of Fulfilled and Backorder orders. Overall, the result is **10.26%**.

Comparing warehouses showed noticeable variation. WH-003 Denpasar had the highest backorder rate at 11.86%, while WH-007 Jakarta had the lowest at 7.61%.

I then went deeper at the product-warehouse combination level. Of the 1,505 combinations with valid orders, 231 (about 15%) have experienced a backorder. These cover 172 different products.

However, I found that the backorder percentage alone doesn't fully describe how serious the problem is. A total of 85 combinations even have a 100% backorder rate, but each has only one or two valid orders.

In other words, a high percentage doesn't necessarily mean a large volume of problems. I need to look at the number of backorder events together with the percentage to set analytical priorities more proportionally.

Another interesting finding came from linking backorder history to the stock classification at the end of 2025. Of the 231 combinations that experienced backorders, only 17 currently have Stockout status and 1 has Critical status. By contrast, 168 combinations actually have Safe status.

This shows that backorders can occur at specific points during the observation period and don't always reflect inventory conditions at year-end.

> **Key Finding:** Backorders should be analyzed based on order fulfillment history, not just the stock balance at a single point in time. Percentages and the number of events also need to be considered together.

### 4. Overstock Analysis: Identifying Trapped Inventory Capital

**I found that inventory buildup isn't limited to a few specific products. It is spread across hundreds of product-warehouse combinations, with a total asset value of Rp133.7 billion.**

After exploring the risk of stock shortages, I turned to the other side of the inventory problem: overstock.

In this analysis, I defined overstock as products that still have a stock balance but have no recorded demand throughout 2025.

The result shows **811 product-warehouse combinations with an asset value of about Rp133.7 billion**, or about 38% of the total inventory value of Rp347.35 billion.

I then compared overstock value by warehouse location. WH-004 has the highest value at Rp19.05 billion across 108 items, while WH-008 has the lowest at Rp14.63 billion across 86 items. The other warehouses are relatively close to each other, at around Rp15.6–17.3 billion.

This distribution shows that the capital buildup isn't concentrated in a single warehouse but is spread across many locations.

Grouping inventory by product category, Raw Material has the most overstock items with 188 combinations, followed by Sparepart with 181.

By asset value, Raw Material is also the highest at Rp34.8 billion, followed by Packaging at Rp30.7 billion.

I then looked at the products with the largest overstock value. The highest is about Rp980 million, from product IPRD-0221 in WH-005.

However, the ten highest-value combinations together account for only about 5.6% of total overstock value.

This shows that the trapped capital isn't caused by just a few high-value products. The problem is spread across hundreds of items, so addressing it requires a more comprehensive inventory review.

> **Key Finding:** Overstock is spread across many warehouses and product categories. Inventory optimization needs to be done comprehensively, not just by focusing on a few items with the largest asset value.

### 5. Supplier & Procurement Analysis: Evaluating Procurement Efficiency

**I found that suppliers with long lead times aren't always the ones that absorb the largest procurement budgets.**

After evaluating inventory conditions, I moved on to procurement activity to understand the relationship between supplier delivery time and purchasing budget allocation.

I started by identifying suppliers by lead time. SUP-0005 (Import) and SUP-0048 (Local) have the longest lead time at 30 days. They are followed by SUP-0015, SUP-0002, and SUP-0077 at 29 days.

Overall, there are 21 suppliers with a lead time of at least 25 days, supplying 67 products. These products fall into five categories, with Packaging having the most at 20 products, followed by Raw Material at 15.

I then evaluated the distribution of the procurement budget, excluding POs with Cancelled status. Of the roughly Rp6.51 billion total procurement value, Import suppliers absorb 55.2% of the budget and Local suppliers 44.8%.

I also found that the procurement budget isn't concentrated in a single supplier. The supplier with the largest budget, SUP-0007 (Import), accounts for only about 3.9% of the total.

Another interesting point is that none of the ten suppliers with the largest procurement budgets has a lead time of 25 days or more.

This suggests that suppliers with long delivery times aren't always the ones contributing the largest share of the budget. Supplier evaluation therefore needs to consider more than one indicator, especially lead time and procurement value.

> **Key Finding:** Procurement risk doesn't always track the size of the budget. Suppliers with long lead times still deserve attention even when their budget contribution is relatively small.

### 6. Warehouse & Demand Analysis: Comparing Operational Performance

**I found that although the number of stock movement activities is relatively similar across warehouses, asset density and demand patterns differ quite a lot.**

In the final stage, I explored operational activity across warehouses to understand how inventory and demand are distributed by location.

I started by comparing the number of stock movement transactions. Activity across warehouses is fairly close, ranging from 982 to 1,093 transactions.

However, when I compared the transaction counts with warehouse area, the ratios differed significantly. WH-006 Bandung has the highest ratio at 0.94 transactions per m², while WH-003 Denpasar has the lowest at 0.14 transactions per m².

I also compared warehouse capacity with the value of inventory stored. Denpasar has the largest capacity at 7,820 m², but the lowest asset value per m² at around Rp6.0 million. Bandung, in contrast, has the smallest capacity at 1,146 m² and the highest asset value per m² at around Rp37.8 million.

This difference shows that inventory value is not evenly distributed relative to warehouse capacity. That said, I use asset per m² and transactions per m² as comparison measures of asset value and activity density, not as direct measures of how physically full a warehouse is.

Next, I evaluated the distribution of sales orders by city. Semarang has the highest order volume with 622 orders, but because the city has two warehouses, the average is about 311 orders per warehouse. Among cities with a single warehouse, Medan recorded the highest volume at 338 orders. The other cities fall in the range of 272–295 orders.

I also traced the monthly changes in order volume. Overall, order counts fluctuate without a consistent upward or downward trend. February had the lowest number of orders at 171, while May recorded the highest at 220. Bandung, Jakarta, and Semarang also saw order declines in February.

Narrowing the analysis down by city, Surabaya showed a fairly notable change. Orders fell from 33 in May to 13 in October, before rising again to 27 in December.

To help read these movements, I used a three-month moving average and the `LAG()` function to compare the change in order counts from the previous month.

> **Key Finding:** Similar levels of operational activity don't always mean similar asset density or demand. Location-based analysis gives a more detailed picture of how each warehouse differs.

### Overall EDA Findings

Across the six areas of exploration, I found that inventory problems aren't only about how much stock is available, but also about how stock is allocated, ordered, and distributed.

The four main findings that stood out to me are:

1. **Inventory Overstock:** Rp133.7 billion, or about 38% of total inventory asset value, is tied up in 811 product-warehouse combinations with no recorded demand during 2025.
2. **Inventory Shortage Risk:** 103 product-warehouse combinations are out of stock or at risk of running out before the next delivery arrives.
3. **Backorder:** The backorder rate reaches 10.26%, showing that some orders couldn't be fulfilled given stock availability.
4. **Supplier Lead Time:** 21 suppliers have a lead time of at least 25 days and need attention in procurement planning.

Together, these findings show that the company faces two conditions at once: excess inventory that ties up capital, and stock shortages that can get in the way of fulfilling orders.

From here, I began directing the analysis toward how both problems can be addressed through reorder level evaluation, optimized stock distribution across warehouses, and supplier performance monitoring.

These exploration results are what I then translated into the indicators, visualizations, and recommendations in the *Inventory & Supply Chain Performance Dashboard*.

## 8. Insights & Key Findings

### Uncovering the Root Causes of Inventory Problems

From the analysis, I found that PT. XYZ Logistic's main problem isn't simply a shortage of inventory. It is an imbalance in stock distribution, along with a reorder policy that hasn't been adjusted to the needs of each warehouse.

On one hand, some inventory piles up with no recorded demand throughout 2025. On the other, some products run short badly enough to hold up order fulfillment. This suggests the company needs to evaluate how inventory is allocated, when orders are placed, and how procurement performance is managed.

I summarized seven key insights from the data exploration. Each one links a quantitative finding to its business implication and to improvement opportunities the supply chain team can consider.

### 1. Most Stockout Risks Can Potentially Be Addressed Through Stock Redistribution

Of the 103 product-warehouse combinations that are out of stock or in critical condition, 96 (93%) were found to have the same product overstocked in another warehouse, while the remaining seven had no match in the initial identification.

This suggests that most stock shortage risks may stem from an imbalance in how inventory is distributed between warehouses, rather than from a shortage of supply overall. Before making new purchases, the company can therefore evaluate transferring stock from warehouses with excess inventory to those that need it, which speeds up fulfillment and also reduces idle inventory.

That said, this recommendation needs to take into account how much stock is actually available, the needs of the source warehouse, shipping costs, and transfer time before it is put into practice.

### 2. A Uniform Reorder Level Can Drive Excess Inventory

The old reorder level was set to the same value for the same product in every warehouse, even though demand characteristics can differ. Based on the recommended reorder level calculations, in most product-warehouse combinations with sales, the old reorder level is higher than the new recommendation.

This suggests that a uniform reorder policy doesn't necessarily reflect the needs of each warehouse. In low-demand locations, a reorder threshold that is too high can drive excess procurement, while locations with high demand or long lead times need planning that fits their operating conditions.

The company can therefore evaluate and adjust reorder levels based on the demand and lead time of each product-warehouse combination, reducing unnecessary purchases while keeping stock available. Even so, this recommendation still needs to be validated against actual demand patterns and company inventory policy so that the adjustment doesn't end up raising the risk of stock shortages.

### 3. Rp133.7 Billion in Inventory Capital Is Tied Up in Products with No Recorded Sales

A total of 811 product-warehouse combinations have no recorded sales throughout 2025, with a total inventory value of about Rp133.7 billion, or 38% of the total inventory asset value of Rp347.35 billion. Overstock value per warehouse ranges from Rp14.6 billion to Rp19.0 billion, while the ten combinations with the largest overstock value account for only about 5.6% of total overstock value.

This shows that potentially excess inventory value is spread across many products and warehouses rather than concentrated in a few high-value items, so part of the company's capital may be tied up in goods that generated no sales during the observation period.

Still, having no recorded sales in one year doesn't necessarily mean a product won't be needed in the future. The company can review its purchasing plans, evaluate whether stock in other warehouses can be put to use, and consider promotional programs for goods that are still sellable. Because the problem is spread across hundreds of product-warehouse combinations, addressing it calls for consistent procurement rules and inventory monitoring, not just a focus on a few of the highest-value products.

### 4. Suppliers with Long Lead Times Need Attention in Procurement Planning

Procurement budget, excluding Cancelled POs, splits roughly 55% to Import suppliers and 45% to Local suppliers. The average lead time is 18.3 days for Import suppliers and 15.8 days for Local suppliers. In addition, 21 suppliers have a lead time of at least 25 days, supply 67 products, and absorb about 23.6% of the total procurement budget. On the other hand, the budget isn't concentrated in a single supplier, since the largest one accounts for only about 3.9% of total procurement.

This suggests that Import suppliers have a longer average delivery time and that part of the procurement budget goes to suppliers with high lead times. That has to be factored into order timing and the stock needed while waiting for supply.

However, a long lead time doesn't automatically mean poor supplier performance, because its effect on inventory risk also depends on demand patterns, delivery reliability, and stock availability. The company can therefore prioritize monitoring suppliers with long lead times, evaluate safety stock needs, and adjust ordering schedules for products that depend on those suppliers. The evaluation can be done in stages according to the risk level of each product and supplier, without having to change the entire procurement strategy at once.

### 5. Inventory Asset Value per Square Meter Differs by Up to 6.3 Times Across Warehouses

Bandung has the highest inventory asset value per square meter at around Rp37.8 million/m², while Denpasar has the lowest at Rp6.0 million/m², a difference of about 6.3 times. Denpasar has the largest warehouse capacity at 7,820 m², with an inventory asset value of about Rp47.1 billion. However, its stock movement activity per square meter is only 0.14 transactions/m², compared with 0.94 transactions/m² in Bandung.

This shows that asset value and inventory activity aren't distributed proportionally to warehouse area. Bandung has higher asset value and activity per unit of area, while Denpasar has more space with a lower asset value per square meter.

That said, asset value and transactions per square meter don't directly describe how physically full a warehouse is, or how efficient it is. The company can therefore revisit its inventory allocation and capacity utilization based on the needs of each location, including watching for potential capacity pressure in Bandung and checking whether capacity fits operational needs in Denpasar. Before deciding on consolidation or moving stock, the company still needs to consider the physical volume of goods, actual capacity, distribution costs, and each warehouse's demand patterns.

### 6. Backorder Rates Differ Across Warehouses Even Though Stock Movement Activity Is Relatively Similar

Backorder rates by warehouse range from 7.61% in Jakarta to 11.86% in Denpasar, against an overall average of 10.26%. Meanwhile, the number of stock movement transactions per warehouse falls between 982 and 1,093, so the difference in transaction counts is small compared with the variation in backorder rates.

This suggests that stock movement volume alone isn't enough to explain differences in how well each warehouse fulfills orders. Backorder variation can relate to product mix, demand patterns, stock availability, or reorder policy. The data doesn't prove that backorder differences are caused by how a warehouse is managed, but the variation gives a basis for evaluating the operational factors at each location.

Jakarta can serve as a starting benchmark against Denpasar, which has the highest backorder rate, through an analysis of product mix, stockout frequency, supplier lead time, and reorder level fit. In this way, the company can identify practices that may be worth applying in other warehouses, without assuming that a single indicator determines overall performance.

### 7. Backorders Don't Always Reflect Current Stock Conditions

Of the 231 product-warehouse combinations that experienced backorders during 2025, only 17 had Stockout status and one had Critical status at the end of the observation period, while the other 168 had Safe status.

This suggests that most product-warehouse combinations that experienced backorders are no longer short of stock at year-end. In other words, inventory status at a single point in time doesn't necessarily describe what happened over the course of the year, because a backorder can occur when stock is temporarily insufficient and then get resolved once inventory is replenished.

Inventory evaluation therefore needs to consider event history, not just the latest balance. The company should monitor stock availability and order fulfillment regularly so that temporary shortages can be spotted earlier. Backorder history can also be used to evaluate how well reorder levels and procurement schedules match actual needs. Combining current stock information with order history gives a more complete picture of inventory risk than relying only on end-of-period status.

### Bringing the Insights Together

These seven insights show that PT. XYZ Logistic's inventory problems are interconnected. Reorder levels that haven't been adjusted to each warehouse's needs can drive suboptimal procurement, while inventory that isn't matched by demand can pile up and tie up company capital.

At the same time, imbalanced stock distribution and long supplier lead times can raise the risk of stock shortages and backorders at certain locations.

Based on these findings, I see three improvement priorities the company can consider:

1. **Optimize inventory distribution:** evaluate stock transfer opportunities between warehouses before making new purchases.
2. **Adjust the reorder policy:** evaluate reorder levels based on product needs, demand characteristics, and supplier lead time.
3. **Strengthen inventory and procurement monitoring:** track overstock, stockouts, backorders, and supplier performance regularly.

Through this analysis, I didn't just identify inventory imbalances. I also connected the data findings to opportunities for operational improvement. The results became the basis for a dashboard that helps the supply chain team set priorities, evaluate procurement decisions, and manage inventory distribution more deliberately.

## 9. Recommendations & Impact

### From Data Insights to Actionable Recommendations

Based on the analysis, I concluded that optimizing PT. XYZ Logistic's inventory should follow three main approaches: balancing stock distribution across warehouses, controlling new procurement, and adjusting the reorder policy to actual needs.

I put together seven recommendations based on their potential impact on stockout risk, tied-up capital, and operational efficiency. The priority order starts with actions that make use of inventory already on hand, then moves to preventing new buildup, before turning to longer-term policy improvements and monitoring.

### 1. Transfer Stock Between Warehouses

I recommend evaluating stock transfers for 96 of the 103 product-warehouse combinations that are out of stock or critical and have the same product overstocked in another warehouse. The Stock Monitoring Status table in the dashboard can serve as a starting list for identifying which warehouses need stock and which could be transfer sources. The other seven combinations can be evaluated for new purchases after checking whether they could be fulfilled from warehouses that still have excess or safe stock available for allocation.

Based on an initial estimate, the stock required for these 103 combinations is about 3,330 units, worth Rp1.45 billion, and about 93% of the combinations are reported to have fulfillment potential through stock in other warehouses. Using stock that is already available can speed up fulfillment and ease the distribution imbalance without immediately increasing the company's total stock.

However, these figures are estimates of need, not savings that have been realized. The amount of stock that can be transferred still has to be calculated based on target inventory levels, actual stock availability, the needs of the source warehouse, and transfer costs, to make sure the source warehouse keeps enough stock for local demand.

### 2. Review Open Purchase Orders

I recommend re-reviewing the 295 purchase orders with Open status, worth about Rp1.29 billion, to identify orders that aren't urgent and could be postponed, reduced, or cancelled in line with contract terms and procurement conditions. The analysis shows that all 295 Open POs relate to products whose total stock across all warehouses is estimated to cover more than one year of demand. Additional purchases could therefore add to the existing buildup, once needs and procurement commitments have been verified.

For future POs, the company can adopt an approval mechanism based on overall inventory needs, checking stock across all warehouses, demand projections, orders already in progress, and supplier lead time before an order is approved. This evaluation should help limit unnecessary inventory additions and improve planning for incoming goods.

That said, the Rp1.29 billion is the nominal value of Open POs under evaluation, not a guaranteed saving. Whether to postpone or cancel depends on contract status, cancellation costs, future needs, and delivery commitments. In addition, PO values can't be directly equated with inventory asset value because of calculation differences within the dataset.

### 3. Implement Dynamic Reorder Levels

I recommend changing the reorder level policy from a single static value per product to a value tailored to each product-warehouse combination, using an initial approach of Recommended Reorder Level = (Daily Demand × Lead Time) + (Maximum Daily Demand × 90). It combines estimated demand during lead time with additional safety stock based on 90 days of maximum daily demand.

Implementation can start with the products with the largest gap between the old reorder level and the new recommendation. Values should then be reviewed periodically, for example monthly or quarterly, based on changes in demand and procurement performance.

Initial calculations show recommended reorder levels in the range of roughly 90–130 units, while the old values range from 20 to 300 units. This adjustment could reduce unnecessary orders and provide a more relevant basis for deciding when to order at each warehouse.

However, the formula is an initial approach and not a statistical safety stock calculation. The maximum 90-day demand component can produce high thresholds for products with demand spikes, so the recommendations should be validated through simulation or post-implementation monitoring, adjusted to operating conditions by warehouse managers, and supported by more than one year of data to evaluate seasonal patterns.

### 4. Reduce Slow-Moving Inventory

I recommend a phased evaluation of the 811 product-warehouse combinations that have stock but no recorded sales throughout 2025. Options include promotions or bundling for products piled up in many warehouses, reviewing returns or trade-ins with suppliers for products with high inventory value (especially Raw Material and Packaging), and evaluating storage needs and whether each product should stay on the active product list.

The total inventory value in this group reaches Rp133.7 billion, or about 38% of total inventory asset value, while the ten largest combinations contribute only about 5.6% of that value. The effort therefore needs to cover many products and not focus only on the highest-value items.

As an illustration, if the company reduced inventory value in this group by 10%, the nominal value freed up would be about Rp13.4 billion. A reduction like that could help release tied-up capital, but the figure is a calculation scenario, not a profit projection, because the outcome depends on the company's ability to sell, move, or return the goods, and on the value actually received.

Discounted sales can also reduce margins, while returns or trade-ins depend on agreements with suppliers. Each option should therefore be evaluated on recovery value, execution cost, and impact on profit. And since having no sales in 2025 doesn't automatically mean a product will never be needed again, liquidation decisions should consider the product's function, operational needs, and demand prospects.

### 5. Evaluate Suppliers with Long Lead Times

I recommend evaluating the 21 suppliers with a lead time of at least 25 days that supply 67 products, through delivery time negotiations, setting delivery service targets, and reviewing alternative suppliers for products at risk of stock shortages.

For products that depend on long lead time suppliers, the company also needs to make sure the reorder level policy uses an appropriate procurement time estimate. Long lead times increase the inventory needed while waiting for delivery, so if procurement time isn't accounted for properly, the company risks stockouts even after a purchase order has been placed.

Improving lead times could shorten procurement wait times and leave room to review safety stock needs. Success can be tracked through changes in the average lead time and the number of suppliers with a lead time of at least 25 days.

Numeric targets, however, should be set after the company assesses how feasible negotiations are and the actual condition of each supplier. A decision to switch suppliers should also consider unit price, quality, delivery consistency, and logistics costs, because Local suppliers don't always offer lower prices or better quality than Import suppliers.

### 6. Evaluate Stock Distribution and Warehouse Utilization

I recommend evaluating inventory distribution with attention to each warehouse's operating characteristics. Denpasar has the largest capacity, the lowest asset value per square meter, and the highest backorder rate. Bandung has the smallest capacity and the highest asset value per square meter. Jakarta, with the lowest backorder rate at 7.61%, can serve as an initial benchmark for evaluating differences in product characteristics, stock availability, and procurement policy across warehouses.

This recommendation is based on the roughly 6.3-fold difference in asset value per square meter, while the number of stock movement transactions per warehouse is relatively close. Comparing by transaction volume alone isn't enough to understand differences in inventory conditions and order fulfillment.

The evaluation should help the company identify stock redistribution opportunities, review whether inventory allocation matches each location's needs, and anticipate capacity pressure at specific warehouses.

Even so, Jakarta's 7.61% backorder rate can only be used as an initial benchmark, not as a target every warehouse can automatically reach, since differences in demand, product mix, and customer characteristics still have to be taken into account. In addition, asset per square meter doesn't directly show how physically full a warehouse is, so any large-scale consolidation or stock relocation should be backed by actual capacity data, goods volume, distribution costs, distance to customers, and each location's service needs.

### 7. Make the Dashboard a Routine Monitoring Tool

I recommend using the dashboard as part of regular inventory and procurement evaluation, not just as an end-of-period report. Monitoring can be split into two levels:

- **Weekly:** review the Stock Monitoring Status table, check products with Critical status, and evaluate transfer or procurement needs.
- **Monthly:** evaluate the main KPIs: Stockout Risk, Backorder Rate, Total Inventory Asset, and Supplier Lead Time.

The company can also set special alerts for products whose days of cover is shorter than supplier lead time, and record every backorder event so that stock shortage history can be analyzed consistently.

This recommendation matters because the analysis shows that many product-warehouse combinations that experienced backorders had Safe status at the end of 2025, so monitoring only the closing balance isn't enough to catch temporary shortages.

Routine monitoring should help the team spot risks earlier, set action priorities, and evaluate the results of the inventory policies applied. Its effectiveness can be measured through changes in the backorder rate, the number of Critical combinations, the value of overstock, and the time needed to respond to stockout risks.

### Conclusion: Connecting Recommendations to Business Impact

From the analysis, I put the recommendations in sequence so the company can make use of the inventory it already has, prevent new buildup, and improve its procurement policy over the long term.

The three main priorities I propose are:

1. **Stock redistribution:** evaluate inter-warehouse transfers to address stock shortages before making new purchases.
2. **Procurement control:** review Open POs and improve purchase approval rules to prevent adding stock that isn't yet needed.
3. **Inventory policy improvement:** apply reorder levels that better fit product-warehouse needs and monitor the results regularly.

The remaining recommendations (evaluating slow-moving inventory, suppliers, and warehouse utilization) can support all three priorities. The dashboard serves as a monitoring tool that helps the team identify problems, decide on actions, and track progress.

Through this project, I applied data analysis to turn quantitative findings into recommendations that are relevant to business problems. I also came to understand that the value of analysis doesn't stop at identifying problems. It lies in how the results can be used to support better-measured decisions.

## 10. Dashboard / Final Visualization

-  ![alt text](image.png).
- **5 KPI Cards:** Total SKUs (300), Stockout Risk (103), Backorder Rate (10.26%), Total Assets (Rp347.35 billion), and Average Supplier Lead Time (17.11 days).
- **Insight Panel:** 6 key findings highlighting stockout risks, high reorder levels, overstock capital, supplier performance, warehouse asset density, and backorder rate differences.
- **Stock Distribution Donut Chart:** Displays the distribution of 2,328 product-warehouse combinations across stock statuses: Aman, Overstock, Waspada, Stockout, Tidak Aktif, and Kritis.
- **Stock Monitoring & Recommendation Table:** Identifies product-level stock conditions, demand, lead time, recommended reorder levels, and suggested actions.
- **Monthly Stock Movement Chart:** Compares monthly incoming and outgoing stock from January to December 2025.
- **Warehouse Performance Table:** Compares warehouse capacity, inventory assets, asset value per square meter, stock movement transactions, and backorder rates.
- **Slow-Moving Inventory Bar Chart:** Highlights the value of overstock inventory across warehouses.
- **Supplier Performance Scatter Plot:** Compares supplier lead time and purchase order budget, distinguishing between Import and Local suppliers.

### Interactivity

The dashboard provides interactive filters for:
- **Month:** January–December.
- **Warehouse Name:** Filter performance by warehouse location.
- **Supplier Type:** Compare Import and Local suppliers.
- **Product Category:** Analyze inventory performance by product category.

These filters allow users to explore inventory and supply chain performance across different periods, warehouses, suppliers, and product categories.

### Live Link

**[View the Power BI dashboard](https://ugm365-my.sharepoint.com/:u:/r/personal/muhammadzidane2004_365_ugm_ac_id/Documents/Project.pbix?d=w6a07e38100f24cc3a6eeed1308158d6c&csf=1&web=1&e=zICpHd)**

### Additional Notes

The current dashboard focuses on inventory monitoring, stock distribution, warehouse performance, supplier analysis, and actionable recommendations. Sales trends by product, warehouse, or region are not displayed on this dashboard. Although reorder level issues are highlighted in the Insight Panel and recommended reorder levels are included in the monitoring table, there is no dedicated visual comparing reorder levels against overstock risk. These could be considered for future dashboard development.

