% Mapping code to item name
dessert_map(d1, rasgulla).
dessert_map(d2, gulabjamun).
dessert_map(d3, rasmalai).

% Mapping price to item code
dessert_price_map(d1, 4.99).
dessert_price_map(d2, 4.99).
dessert_price_map(d3, 5.99).

% Used for printing menu
desserts_list(['Desserts:',
    '\n\t d1: Rasgulla   - $4.99',
    '\n\t d2: Gulabjamun - $4.99', 
    '\n\t d3: Rasmalai   - $5.99'
    ]).

% used for checking user input to the database
desserts_db([
    d1, 
    d2, 
    d3
    ]).