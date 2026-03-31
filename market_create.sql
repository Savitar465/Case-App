-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2025-10-13 23:36:52.029

-- Table: categories
CREATE TABLE categories (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    parent_id uuid  NULL,
    name varchar(100)  NOT NULL,
    slug varchar(100)  NOT NULL,
    description text  NULL,
    image_url varchar(500)  NULL,
    sort_order integer  NULL DEFAULT 0,
    is_active boolean  NULL DEFAULT true,
    created_at timestamp  NULL DEFAULT current_timestamp,
    updated_at timestamp  NULL DEFAULT current_timestamp,
    CONSTRAINT AK_4 UNIQUE (slug) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT categories_pk PRIMARY KEY (id)
);

-- Table: order_items
CREATE TABLE order_items (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    order_id uuid  NOT NULL,
    product_id uuid  NULL,
    variant_id uuid  NULL,
    seller_id uuid  NULL,
    product_name varchar(255)  NOT NULL,
    product_sku varchar(100)  NULL,
    variant_name varchar(255)  NULL,
    quantity integer  NOT NULL,
    unit_price decimal(10,2)  NOT NULL,
    total_price decimal(10,2)  NOT NULL,
    tax_amount decimal(10,2)  NULL DEFAULT 0.00,
    discount_amount decimal(10,2)  NULL DEFAULT 0.00,
    commission_amount decimal(10,2)  NULL DEFAULT 0.00,
    created_at timestamp  NULL DEFAULT current_timestamp,
    updated_at timestamp  NULL DEFAULT current_timestamp,
    CONSTRAINT CHECK_11 CHECK (( quantity > 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_12 CHECK (( unit_price >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_13 CHECK (( total_price >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT order_items_pk PRIMARY KEY (id)
);

CREATE INDEX idx_order_items_order_id on order_items (order_id ASC);

CREATE INDEX idx_order_items_product_id on order_items (product_id ASC);

-- Table: orders
CREATE TABLE orders (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    order_number varchar(50)  NOT NULL,
    user_id uuid  NULL,
    CONSTRAINT AK_9 UNIQUE (order_number) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT orders_pk PRIMARY KEY (id)
);

CREATE INDEX idx_orders_user_id on orders (user_id ASC);

CREATE INDEX idx_orders_status on orders ();

CREATE INDEX idx_orders_payment_status on orders ();

CREATE INDEX idx_orders_created_at on orders ();

-- Table: payment_transactions
CREATE TABLE payment_transactions (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    order_id uuid  NOT NULL,
    transaction_id varchar(255)  NULL,
    CONSTRAINT AK_10 UNIQUE (transaction_id) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT payment_transactions_pk PRIMARY KEY (id)
);

-- Table: product_images
CREATE TABLE product_images (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    product_id uuid  NOT NULL,
    url varchar(500)  NOT NULL,
    alt_text varchar(255)  NULL,
    sort_order integer  NULL DEFAULT 0,
    is_primary boolean  NULL DEFAULT false,
    created_at timestamp  NULL DEFAULT current_timestamp,
    CONSTRAINT product_images_pk PRIMARY KEY (id)
);

-- Table: product_variants
CREATE TABLE product_variants (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    product_id uuid  NOT NULL,
    sku varchar(100)  NOT NULL,
    name varchar(255)  NOT NULL,
    price decimal(10,2)  NOT NULL,
    compare_at_price decimal(10,2)  NULL,
    cost decimal(10,2)  NULL,
    quantity integer  NULL DEFAULT 0,
    weight decimal(10,3)  NULL,
    attributes jsonb  NULL,
    created_at timestamp  NULL DEFAULT current_timestamp,
    updated_at timestamp  NULL DEFAULT current_timestamp,
    CONSTRAINT AK_7 UNIQUE (sku) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_5 CHECK (( price >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_6 CHECK (( compare_at_price >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_7 CHECK (( cost >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_8 CHECK (( quantity >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT product_variants_pk PRIMARY KEY (id)
);

-- Table: products
CREATE TABLE products (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    seller_id uuid  NOT NULL,
    category_id uuid  NULL,
    sku varchar(100)  NOT NULL,
    name varchar(255)  NOT NULL,
    slug varchar(255)  NOT NULL,
    description text  NULL,
    short_description varchar(500)  NULL,
    price decimal(10,2)  NOT NULL,
    compare_at_price decimal(10,2)  NULL,
    cost decimal(10,2)  NULL,
    quantity integer  NULL DEFAULT 0,
    reserved_quantity integer  NULL DEFAULT 0,
    low_stock_threshold integer  NULL DEFAULT 5,
    weight decimal(10,3)  NULL,
    length decimal(10,2)  NULL,
    width decimal(10,2)  NULL,
    height decimal(10,2)  NULL,
    CONSTRAINT AK_5 UNIQUE (sku) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT AK_6 UNIQUE (slug) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_0 CHECK (( price >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_1 CHECK (( compare_at_price >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_2 CHECK (( cost >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_3 CHECK (( quantity >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT CHECK_4 CHECK (( reserved_quantity >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT products_pk PRIMARY KEY (id)
);

CREATE INDEX idx_products_seller_id on products (seller_id ASC);

CREATE INDEX idx_products_category_id on products (category_id ASC);

CREATE INDEX idx_products_status on products ();

CREATE INDEX idx_products_slug on products (slug ASC);

CREATE INDEX idx_products_sku on products (sku ASC);

CREATE INDEX idx_products_price on products (price ASC);

CREATE INDEX idx_products_created_at on products ();

-- Table: shipping_methods
CREATE TABLE shipping_methods (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    zone_id uuid  NOT NULL,
    name varchar(100)  NOT NULL,
    description text  NULL,
    base_rate decimal(10,2)  NOT NULL,
    per_kg_rate decimal(10,2)  NULL DEFAULT 0.00,
    min_days integer  NULL,
    max_days integer  NULL,
    is_active boolean  NULL DEFAULT true,
    created_at timestamp  NULL DEFAULT current_timestamp,
    updated_at timestamp  NULL DEFAULT current_timestamp,
    CONSTRAINT CHECK_15 CHECK (( base_rate >= 0 )) NOT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT shipping_methods_pk PRIMARY KEY (id)
);

-- Table: users
CREATE TABLE users (
    id uuid  NOT NULL DEFAULT uuid_generate_v4(),
    email varchar(255)  NOT NULL,
    username varchar(100)  NOT NULL,
    password_hash varchar(255)  NOT NULL,
    first_name varchar(100)  NULL,
    last_name varchar(100)  NULL,
    phone varchar(20)  NULL,
    CONSTRAINT AK_0 UNIQUE (email) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT AK_1 UNIQUE (username) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT users_pk PRIMARY KEY (id)
);

CREATE INDEX idx_users_email on users (email ASC);

CREATE INDEX idx_users_status on users ();

CREATE INDEX idx_users_role on users ();

-- foreign keys
-- Reference: FK_0 (table: addresses)
ALTER TABLE addresses ADD CONSTRAINT FK_0
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_1 (table: sellers)
ALTER TABLE sellers ADD CONSTRAINT FK_1
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_10 (table: cart_items)
ALTER TABLE cart_items ADD CONSTRAINT FK_10
    FOREIGN KEY (variant_id)
    REFERENCES product_variants (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_11 (table: orders)
ALTER TABLE orders ADD CONSTRAINT FK_11
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_12 (table: order_items)
ALTER TABLE order_items ADD CONSTRAINT FK_12
    FOREIGN KEY (order_id)
    REFERENCES orders (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_13 (table: order_items)
ALTER TABLE order_items ADD CONSTRAINT FK_13
    FOREIGN KEY (product_id)
    REFERENCES products (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_14 (table: order_items)
ALTER TABLE order_items ADD CONSTRAINT FK_14
    FOREIGN KEY (variant_id)
    REFERENCES product_variants (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_15 (table: order_items)
ALTER TABLE order_items ADD CONSTRAINT FK_15
    FOREIGN KEY (seller_id)
    REFERENCES sellers (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_16 (table: payment_transactions)
ALTER TABLE payment_transactions ADD CONSTRAINT FK_16
    FOREIGN KEY (order_id)
    REFERENCES orders (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_17 (table: reviews)
ALTER TABLE reviews ADD CONSTRAINT FK_17
    FOREIGN KEY (product_id)
    REFERENCES products (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_18 (table: reviews)
ALTER TABLE reviews ADD CONSTRAINT FK_18
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_19 (table: reviews)
ALTER TABLE reviews ADD CONSTRAINT FK_19
    FOREIGN KEY (order_item_id)
    REFERENCES order_items (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_2 (table: categories)
ALTER TABLE categories ADD CONSTRAINT FK_2
    FOREIGN KEY (parent_id)
    REFERENCES categories (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_20 (table: wishlists)
ALTER TABLE wishlists ADD CONSTRAINT FK_20
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_21 (table: wishlists)
ALTER TABLE wishlists ADD CONSTRAINT FK_21
    FOREIGN KEY (product_id)
    REFERENCES products (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_22 (table: coupon_uses)
ALTER TABLE coupon_uses ADD CONSTRAINT FK_22
    FOREIGN KEY (coupon_id)
    REFERENCES coupons (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_23 (table: coupon_uses)
ALTER TABLE coupon_uses ADD CONSTRAINT FK_23
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_24 (table: coupon_uses)
ALTER TABLE coupon_uses ADD CONSTRAINT FK_24
    FOREIGN KEY (order_id)
    REFERENCES orders (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_25 (table: shipping_methods)
ALTER TABLE shipping_methods ADD CONSTRAINT FK_25
    FOREIGN KEY (zone_id)
    REFERENCES shipping_zones (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_26 (table: page_views)
ALTER TABLE page_views ADD CONSTRAINT FK_26
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_27 (table: search_logs)
ALTER TABLE search_logs ADD CONSTRAINT FK_27
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_28 (table: notifications)
ALTER TABLE notifications ADD CONSTRAINT FK_28
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_3 (table: products)
ALTER TABLE products ADD CONSTRAINT FK_3
    FOREIGN KEY (seller_id)
    REFERENCES sellers (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_4 (table: products)
ALTER TABLE products ADD CONSTRAINT FK_4
    FOREIGN KEY (category_id)
    REFERENCES categories (id)
    ON DELETE  SET NULL  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: product_images)
ALTER TABLE product_images ADD CONSTRAINT FK_5
    FOREIGN KEY (product_id)
    REFERENCES products (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_6 (table: product_variants)
ALTER TABLE product_variants ADD CONSTRAINT FK_6
    FOREIGN KEY (product_id)
    REFERENCES products (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_7 (table: carts)
ALTER TABLE carts ADD CONSTRAINT FK_7
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_8 (table: cart_items)
ALTER TABLE cart_items ADD CONSTRAINT FK_8
    FOREIGN KEY (cart_id)
    REFERENCES carts (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_9 (table: cart_items)
ALTER TABLE cart_items ADD CONSTRAINT FK_9
    FOREIGN KEY (product_id)
    REFERENCES products (id)
    ON DELETE  CASCADE  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- sequences
-- Sequence: IF
CREATE SEQUENCE IF
      NO MINVALUE
      NO MAXVALUE
      NO CYCLE
      AS bigint
;

-- End of file.

