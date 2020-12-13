% Mapping code to item name
maincourse_map(m1, shahipannermasala).
maincourse_map(m2, chanamasala).
maincourse_map(m3, daalmakkani).
maincourse_map(m4, daaltadka).
maincourse_map(m5, shahichickenmasala).
maincourse_map(m6, butterchicken).
maincourse_map(m7, chickentikkamasal).
maincourse_map(m8, chanamasala).
maincourse_map(m9, roti).
maincourse_map(m10, butterroti).
maincourse_map(m11, butternaan).
maincourse_map(m12, garlicnaan).
maincourse_map(m13, bonelesschickenbiryani).
maincourse_map(m14, chickenbiryani).
maincourse_map(m15, vegetablebiryani).

% Mapping price to item code
maincourse_price_map(m1, 9.99).
maincourse_price_map(m2, 11.99).
maincourse_price_map(m3, 10.99).
maincourse_price_map(m4, 10.99).
maincourse_price_map(m5, 13.99).
maincourse_price_map(m6, 13.99).
maincourse_price_map(m7, 12.99).
maincourse_price_map(m8, 9.99).
maincourse_price_map(m9, 1.99).
maincourse_price_map(m10, 2.99).
maincourse_price_map(m11, 2.99).
maincourse_price_map(m12, 2.99).
maincourse_price_map(m13, 13.99).
maincourse_price_map(m14, 12.99).
maincourse_price_map(m15, 10.99).

% Used for printing menu
maincourses_list(['Maincourses:',
    '\n\t m1: Shahi Panner Masala       - $9.99',
    '\n\t m2: Chana Masala              - $11.99',
    '\n\t m3: Daal Makhani              - $10.99',
    '\n\t m4: Daal Tadka                - $10.99',
    '\n\t m5: Shahi Chicken Masala      - $13.99',
    '\n\t m6: Butter Chicken            - $13.99',
    '\n\t m7: Chicken Tikka Masala      - $12.99',
    '\n\t m8: Chanamasala               - $9.99',
    '\n\t m9: Roti                      - $1.99',
    '\n\t m10: Butter Roti              - $2.99',
    '\n\t m11: Butter Naan              - $2.99',
    '\n\t m12: Garlic Naan              - $2.99',
    '\n\t m13: Boneless Chicken Biryani - $13.99',
    '\n\t m14: Chicken Biryani          - $12.99',
    '\n\t m15: Vegetable Biryani        - $10.99'
    ]).

% used for checking user input to the database
maincourses_db([
    m1, 
    m2, 
    m3, 
    m4, 
    m5, 
    m6, 
    m7, 
    m8, 
    m9, 
    m10,
    m11,
    m12,
    m13,
    m14,
    m15
    ]).