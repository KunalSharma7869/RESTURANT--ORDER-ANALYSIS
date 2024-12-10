create database resturant;
use resturant;
show tables;
alter table menu_items rename column ï»¿menu_item_id to menu_item_id;
alter table order_details rename column ï»¿order_details_id to order_details_id;
select * from order_details;
-- CHECK DUPLICATES RECORDS 
select count(*) as duplicate_records ,od. order_details_id,order_id,od.order_date,od.order_time,item_id from order_details od group by order_details_id,order_id,order_date,
order_time,item_id
having count(*)>1;

-- CHECK FOR MISSING VALUES
select sum(case when order_details_id is null then 1 else 0 end)as order_details_missing_id,
sum(case when order_id is null then 1 else 0 end)as order_id_missing,
sum(case when order_date is null then 1 else 0 end)as order_date_missing,
sum(case when order_time is null then 1 else 0 end)as order_time_missing,
sum(case when item_id is null then 1 else 0 end)as item_id_missing from order_details;

-- TO BETTER UNDERSTAND THE ITEMS TABLES BY FINDING THE NUMBER OF ROWS IN TABLE,
 -- THE LEAST AND MOST EXPENSIVE ITEM,AND THE ITEM PROCES WITHIN EACH CATEGORY .
select category,max(price)as maximum_price,min(price)as minimum_price from menu_items group by category;

-- WAHT ARE THE LEAST EXPENSIVE AND MOST EXPENSIVE ITEM ON THE MENU
select item_name,max(price)as maximum_price from menu_items group by item_name  order by maximum_price desc  limit 1; 
select item_name,min(price)as minimum_price from menu_items group by item_name  order by minimum_price   limit 1; 

-- HOW MANY ITALIAN DISHES ON THE MENU? WHAT ARE THE LEAST  AND MOST EXPENSIVE ITALIAN DISHES ON MENU


select count(*)as item_count  from menu_items where category="Italian";
select menu_item_id ,item_name ,category,price from menu_items where category='Italian' order by price desc limit 1; 
select menu_item_id,item_name,category,price from menu_items where category='Italian' order by price limit 1; 

-- HOW MANY DISHES ARE IN EACH CATEGORY ? WAHT IS THE AVERAGE DISH PRICE  WITHIN EACH CATEGORY
select category,count(*) as item_count ,round(avg(price),2)as average_price  from menu_items  group by category order by item_count desc;


-- NOW EXPLORE MORE ABOUT ORDERS TABLE 
select * from order_details;

-- HOW MANY ORDERS WERE MADE WITHIN DATE RANGE --
select min(order_date),max(order_date) from order_details;
select  count( distinct order_id) from order_details;

-- WHICH ORDERED HAS THE MOST NUMBER OF ITEMS
select order_id,count(item_id)as total_items from order_details group by order_id order by 2 desc limit 10;

select order_id ,count(item_id)as item_count,dense_rank() over ( order by count(item_id)desc)as rankk from order_details group by order_id;
 
 
 -- HOW MANY ORDERS  HAS MORE THAN 12 ITEMS
 with item_count as(select order_id,count(item_id)as item_count from order_details group by order_id)
 select count(*)from item_count where item_count>12;
 
 
 -- CUSTOMER BEHAVIOUR 
 -- COBINE BOTH THE TABLE ANS SEE  ALL DETAILS OF TABLES 
select * from menu_items inner join order_details on menu_items.menu_item_id=order_details.item_id;


-- WHAT WERE THE LEAST AND MOST ORDERED  ITEMS? WHAT CATEGORIES WERE THE IN--  
select count(item_id)as item_count,item_name,category from menu_items inner join order_details on menu_items.menu_item_id=order_details.item_id group by item_name,category order by item_count desc;

-- WHAT   WERE THE TOP 5 ORDER THAT SPEND THE MOST MONEY

select order_id,round(sum(price),2)as money from menu_items inner join order_details on menu_items.menu_item_id=order_details.item_id 
group by order_id order by money desc limit 5;

-- VIEW  THE DETAILS  OF THE HIGHEST SPEND ORDER.WHICH SPECIFIES  ITEM WERE PURCHASED

select  order_id,round(sum(price),2)as money ,category,count(*)as number_of_items from menu_items inner join order_details on menu_items.menu_item_id=order_details.item_id 
where order_id=440
group by order_id ,category order by money desc ;


select  category,item_name,count(*)as number_of_items,item_name ,avg(price) as avg_price from menu_items inner join order_details on menu_items.menu_item_id=order_details.item_id 
where order_id=440 and category='Italian'
group by order_id ,category ,item_name order by avg_price desc ;


-- VIEW THE DETAILS OF TOP 5 HIGHEST SPENDS
select order_id ,category,count(item_id)as item_count from menu_items as m right join order_details od on m.menu_item_id=od.item_id
where order_id in (440,1957,2075,330,2675) group by order_id,category order by item_count desc;






 


