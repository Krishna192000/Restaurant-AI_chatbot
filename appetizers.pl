% Mapping code to item name
appetizer_map(a1, samosa).
appetizer_map(a2, channachat).
appetizer_map(a3, samosachat).
appetizer_map(a4, dahipuri).
appetizer_map(a5, frenchfries).
appetizer_map(a6, springrolls).

% Mapping price to item code
appetizer_price_map(a1, 4.99).
appetizer_price_map(a2, 6.99).
appetizer_price_map(a3, 6.99).
appetizer_price_map(a4, 7.99).
appetizer_price_map(a5, 3.99).
appetizer_price_map(a6, 4.99).

% Used for printing menu
appetizers_list(['Appetizers:',
    '\n\t a1: samosa      - $4.99',
    '\n\t a2: channachat  - $6.99', 
    '\n\t a3: samosachat  - $6.99',
    '\n\t a4: dahipuri    - $7.99', 
    '\n\t a5: frenchfries - $3.99', 
    '\n\t a6: springrolls - $4.99'
    ]).

% used for checking user input to the database
appetizers_db([
    a1, 
    a2, 
    a3, 
    a4, 
    a5,
    a6
    ]).