% Mapping code to item name
drinks_map(e1, coke).
drinks_map(e2, dietcoke).
drinks_map(e3, rootbeer).
drinks_map(e4, buttermilk).
drinks_map(e5, mangolassi).

% Mapping price to item code
drinks_price_map(e1, 2.49).
drinks_price_map(e2, 2.99).
drinks_price_map(e3, 2.99).
drinks_price_map(e4, 2.49).
drinks_price_map(e5, 3.99).

% Used for printing menu
drinks_list(['Drinks:',
    '\n\t e1: coke       - $2.49',
    '\n\t e2: dietcoke   - $2.99', 
    '\n\t e3: rootbeer   - $2.99',
    '\n\t e4: buttermilk - $2.49', 
    '\n\t e5: mangolassi - $3.99'
    ]).

% used for checking user input to the database
drinks_db([
    e1, 
    e2, 
    e3, 
    e4, 
    e5
    ]).