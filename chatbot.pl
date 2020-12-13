% including all the files
:- [appetizers].
:- [maincourse].
:- [dessert].
:- [drinks].
:- use_module(library(random)).

% Global variables. Used through assert and retract in this file
:- dynamic usr_name/1, information/2, menu_appetizer/2, menu_maincourse/2, menu_drink/2, menu_dessert/2, feedback/2, maincourse/1, drink/1, dessert/1, appetizer/1, menu_price/1.

% Main function which will first print welcome message and then start the conversation with the user
% More details follow later in this file
chatbot:-
        print_welcome,
        continuous_conversation.
/*
 This function is for continuous conversation until user says "bye"
 It asks question to user to take the order based on the menu and also
 replies to the questions of the user accordingly. Moreover, it also 
 talks to the user based on saome random questions and answers
*/
continuous_conversation:-
        repeat, 
        print_user,      
        read_input(S),
        reply_generator(S,R),
        print_bot, 
        write_full_list(R),
        check_quit(S), 
        print_order, 
        print_talking_history, !,halt.

one_conversation(S):-
        reply_generator(S,R),
        print_bot, 
        write_full_list(R),
        continuous_conversation.
/*
Reply generating based on the user questions. if it not an actual question based on the patterns then bot will ask questions in the following pattern:
       1. General Information: What's your name ?
       2. Appetizer: What would you like to have in appetizer ?
       3. Maincourse: What would you like to order in maincourse ?
       4. Drinks: Would you like to have anything in drinks ?
       5. Desserts: What would you like in dessert ?
       6. Feedback: Did you like talking to me ?
       7. Random Questions: Can we be friends ? 
*/
reply_generator(S, R):-
        check_quit(S), !,
        database_response(bye, Res), 
        pick_any(Res, R).
reply_generator(S, R):-
        check_thanks(S), !,
        database_response(thanked, Res), 
        pick_any(Res, R).
reply_generator(S, R):-
        pattern_name(S, _), !,
        database_response(my_name, D),
        pick_any(D, R).
reply_generator(S, R):-
        pattern_my_appetizers(S, _), !,
        database_response(my_appetizers, D),
        pick_any(D, R).
reply_generator(S, R):-
        pattern_my_maincourses(S, _), !,
        database_response(my_maincourses, D),
        pick_any(D, R).
reply_generator(S, R):-
        pattern_my_drinks(S, _), !,
        database_response(my_drinks, D),
        pick_any(D, R).
reply_generator(S, R):-
        pattern_my_desserts(S, _), !,
        database_response(my_desserts, D),
        pick_any(D, R).
reply_generator(S, R):-
        pattern_me(S, _), !,
        database_response(me, D),
        pick_any(D, R).
reply_generator(S, R):-
        \+ check_question(S), 
        \+ information(_, _), !,
        take_information(1),
        database_response(thanks, D),
        pick_any(D, R).
reply_generator(S, R):-
        \+ check_question(S), 
        \+ menu_appetizer(_, _), !,
        take_appetizer(2),
        database_response(thanks, D),
        pick_any(D, R).
reply_generator(S, R):-
        \+ check_question(S), 
        \+ menu_maincourse(_, _), !,
        take_maincourse(2),
        database_response(thanks, D),
        pick_any(D, R).
reply_generator(S, R):-
        \+ check_question(S), 
        \+ menu_drink(_, _), !,
        take_drink(2),
        database_response(thanks, D),
        pick_any(D, R).
reply_generator(S, R):-
        \+ check_question(S), 
        \+ menu_dessert(_, _), !,
        take_dessert(2),
        database_response(thanks, D),
        pick_any(D, R).
reply_generator(S, R):-
        \+ check_question(S), 
        \+ feedback(_, _), !,
        take_feedback(4),
        database_response(thanks, D),
        pick_any(D, R).
reply_generator(S, R):-
        \+ check_question(S), !,
        database_response(random_questions, Res),
        pick_any(Res, R).
reply_generator(S, R):- 
        check_question(S), !,
        database_response(random_answers, Res),
        pick_any(Res, R).

% This functions help to generate replly based on pattern of questions which arise midway, that is when ordering the menu
user_response(S, R):-
        check_quit(S), !,
        database_response(bye, Res), 
        pick_any(Res, R).
user_response(S, R):-
        check_thanks(S), !,
        database_response(thanked, Res), 
        pick_any(Res, R).
user_response(S, R):-
        pattern_name(S, _), !,
        database_response(my_name, D),
        pick_any(D, R).
user_response(S, R):-
        pattern_my_appetizers(S, _), !,
        database_response(my_appetizers, D),
        pick_any(D, R).
user_response(S, R):-
        pattern_my_maincourses(S, _), !,
        database_response(my_maincourses, D),
        pick_any(D, R).
user_response(S, R):-
        pattern_my_drinks(S, _), !,
        database_response(my_drinks, D),
        pick_any(D, R).
user_response(S, R):-
        pattern_my_desserts(S, _), !,
        database_response(my_desserts, D),
        pick_any(D, R).
user_response(S, R):-
        pattern_me(S, _), !,
        database_response(me, D),
        pick_any(D, R).
%pattern midway done

%Basic Useful functions
check_greeting(S):-
        database_hi(D),
        check_value_exist(S, D, A),
        A \== [].
check_question(S):-
        member('?', S).
check_thanks(S):-
        database_thank(D),
        check_value_exist(S, D, A),
        A \== [].
check_quit(S):- 
        check_subset([bye], S).
check_no(S):- 
        check_subset([no], S).


%this function will not decrement if N <= 1, this is to continuously ask for more appetizers, maincourse, desserts or drinks unless user inputs "no"
specialDecrement(N, M):-
    N>1,
    M is N - 1.
specialDecrement(N, M):-
    M is N.

% Asking question of feedback section one after another and processing it accordingly
take_feedback(0).
take_feedback(N):-
        database_questions(feedback, D),
        nth_item(D, N, R),
        print_bot,
        write_full_list(R),
        print_user,
        read_input(S),
        assert(feedback(R, S)),
        take_feedback(R, S),
        M is N - 1,
        take_feedback(M).

take_feedback(_, S):-
        check_no(S),
        one_conversation(S).

take_feedback(_, _).

% Asking question of dessert section one after another and processing it accordingly
take_dessert(0).
take_dessert(N):-
        database_questions(menu_dessert, D),
        nth_item(D, N, Q),
        print_bot,
        write_full_list(Q),
        print_dessert,
        print_user,
        read_input(R),
        assert(menu_dessert(Q, R)),
        take_dessert(Q, R),
        specialDecrement(N, M),
        take_dessert(M).

take_dessert(_, RL):-
        check_no(RL),
        one_conversation(RL).

take_dessert(QL, RL):-
        nth_item(QL, 1, Q),
        check_list_contains(Q, dessert), !,
        check_dessert_in_loop(RL).
take_dessert(_, _).

% Asking question of drink section one after another and processing it accordingly
take_drink(0).
take_drink(N):-
        database_questions(menu_drink, D),
        nth_item(D, N, Q),
        print_bot,
        write_full_list(Q),
        print_drink,
        print_user,
        read_input(R),
        assert(menu_drink(Q, R)),
        take_drink(Q, R),
        specialDecrement(N, M),
        take_drink(M).

take_drink(_, RL):-
        check_no(RL),
        one_conversation(RL).

take_drink(QL, RL):-
        nth_item(QL, 1, Q),
        check_list_contains(Q, drink), !,
        check_drink_in_loop(RL).
take_drink(_, _).

% Asking question of maincourse section one after another and processing it accordingly
take_maincourse(0).
take_maincourse(N):-
        database_questions(menu_maincourse, D),
        nth_item(D, N, Q),
        print_bot,
        write_full_list(Q),
        print_maincourse,
        print_user,
        read_input(R),
        assert(menu_maincourse(Q, R)),
        take_maincourse(Q, R),
        specialDecrement(N, M),
        take_maincourse(M).

take_maincourse(_, RL):-
        check_no(RL),
        one_conversation(RL).

take_maincourse(QL, RL):-
        nth_item(QL, 1, Q),
        check_list_contains(Q, maincourse), !,
        check_maincourse_in_loop(RL).
take_maincourse(_, _).

% Asking question of Appetizer section one after another and processing it accordingly
take_appetizer(0).
take_appetizer(N):-
        database_questions(menu_appetizer, D),
        nth_item(D, N, Q),
        print_bot,
        write_full_list(Q),
        print_appetizer,
        print_user,
        read_input(R),
        assert(menu_appetizer(Q, R)),
        take_appetizer(Q, R),
        specialDecrement(N, M),
        take_appetizer(M).

take_appetizer(_, RL):-
        check_no(RL),
        one_conversation(RL).

take_appetizer(QL, RL):-
        nth_item(QL, 1, Q),
        check_list_contains(Q, appetizers), !,
        check_appetizer_in_loop(RL).
take_appetizer(_, _).

% Asking question of Information section one after another and processing it accordingly
take_information(0).
take_information(N):-
        database_questions(info, D),
        nth_item(D, N, Q),
        print_bot,
        write_full_list(Q),
        print_user,
        read_input(R),
        assert(information(Q, R)),
        take_information(Q, R),
        M is N - 1,
        take_information(M).

take_information(QL, RL):-
        nth_item(QL, 1, Q),
        check_list_contains(Q, name), !,
        take_username(Q, RL).
take_information(_, _).

% Take input in loop in order to check validity and output the error and take the input again
% Also answer the questions by user eg: what is your name ?
take_username(Q):-
        print_user,
        read_input(S),
        take_username(Q, S).
take_username(_, RL):-
        check_valid_name(RL), !.
take_username(Q, _):-
        database_response(get_name, D), 
        pick_any(D, X), 
        print_bot,
        write_full_list(X),
        take_username(Q).

% Removed the validity on name and just added that to the global name variable
check_valid_name(NL):-
        nth_item(NL, 1, N),
        assert(usr_name(N)).

% Take input in loop in order to check validity and output the error and take the input again
% Also answer the questions by user eg: what do you like in appetizers ?
check_appetizer_in_loop:-
        print_user,
        read_input(S),
        check_appetizer_in_loop(S).
check_appetizer_in_loop(S):- 
        user_response(S, R),
        print_bot, 
        write_full_list(R),
       check_appetizer_in_loop.
check_appetizer_in_loop(S):- 
        check_valid_appetizer(S), !.
check_appetizer_in_loop(_):- 
        database_response(get_aappetizers, D),
        pick_any(D, R),
        print_bot,
        write_full_list(R),
        check_appetizer_in_loop.

% Take input in loop in order to check validity and output the error and take the input again
% Also answer the questions by user eg: what do you like in appetizers ?
check_maincourse_in_loop:-
        print_user,
        read_input(S),
        check_maincourse_in_loop(S).
check_maincourse_in_loop(S):- 
        user_response(S, R),
        print_bot, 
        write_full_list(R),
       check_maincourse_in_loop.
check_maincourse_in_loop(S):- 
        check_valid_maincourse(S), !.
check_maincourse_in_loop(_):- 
        database_response(get_amaincourses, D),
        pick_any(D, R),
        print_bot,
        write_full_list(R),
        check_maincourse_in_loop.

% Take input in loop in order to check validity and output the error and take the input again
% Also answer the questions by user eg: what do you like in appetizers ?
check_drink_in_loop:-
        print_user,
        read_input(S),
        check_drink_in_loop(S).
check_drink_in_loop(S):- 
        user_response(S, R),
        print_bot, 
        write_full_list(R),
       check_drink_in_loop.
check_drink_in_loop(S):- 
        check_valid_drink(S), !.
check_drink_in_loop(_):- 
        database_response(get_adrinks, D),
        pick_any(D, R),
        print_bot,
        write_full_list(R),
        check_drink_in_loop.

% Take input in loop in order to check validity and output the error and take the input again
% Also answer the questions by user eg: what do you like in appetizers ?
check_dessert_in_loop:-
        print_user,
        read_input(S),
        check_dessert_in_loop(S).
check_dessert_in_loop(S):- 
        user_response(S, R),
        print_bot, 
        write_full_list(R),
       check_dessert_in_loop.
check_dessert_in_loop(S):- 
        check_valid_dessert(S), !.
check_dessert_in_loop(_):- 
        database_response(get_adesserts, D),
        pick_any(D, R),
        print_bot,
        write_full_list(R),
        check_dessert_in_loop.

% global variable for menu price
get_global_menu_price(T):-
        retract(menu_price(T)).
get_global_menu_price(T):-
        T is 0.


% Retrieving appetizer variable or empty if it doesn't exist
get_appetizer_name([H|_], X):-
        appetizer_map(H, X).
get_appetizer_price([H|_], X):-
        appetizer_price_map(H, X).

% getting appetizer name and price from the code
get_global_appetizer(T):-
        retract(appetizer(T)).
get_global_appetizer(T):-
        T=[].

% Checking validity and saving the name and price of the item
check_valid_appetizer(S):- 
        appetizers_db(D),                               % getting all the values from the database
        check_value_exist(S, D, A),                     % Checking if the entered value by the user exist, if not then fail and print error message
        get_appetizer_name(A, X),                       % getting name from the code
        X \== [],               
        get_global_appetizer(T),                        % getting saved name if any, else []
        append([X],T,P),                                % appending it to the result
        assert(appetizer(P)),                           % saving it back
        get_appetizer_price(A, E),                      % getting item price if any, else 0 
        get_global_menu_price(F),                       % getting saved price if any, else 0 
        G is E+F,                                       % adding price
        assert(menu_price(G)).                          % saving it back

% getting maincourse name and price from the code
get_maincourse_name([H|_], X):-
        maincourse_map(H, X).

get_maincourse_price([H|_], X):-
        maincourse_price_map(H, X).

% Retrieving maincourse variable or empty if it doesn't exist
get_global_maincourse(T):-
        retract(maincourse(T)).
get_global_maincourse(T):-
        T=[].

% Checking validity and saving the name and price of the item
check_valid_maincourse(S):- 
        maincourses_db(D),
        check_value_exist(S, D, A),
        get_maincourse_name(A, X),
        X \== [],
        get_global_maincourse(T),
        append([X],T,P),
        assert(maincourse(P)),
        get_maincourse_price(A, E),
        get_global_menu_price(F),
        G is E+F,
        assert(menu_price(G)).

% getting drink name and price from the code
get_drink_name([H|_], X):-
        drinks_map(H, X).

get_drink_price([H|_], X):-
        drinks_price_map(H, X).

% Retrieving drink variable or empty if it doesn't exist
get_global_drink(T):-
        retract(drink(T)).
get_global_drink(T):-
        T=[].

% Checking validity and saving the name and price of the item
check_valid_drink(S):- 
        drinks_db(D),
        check_value_exist(S, D, A),
        get_drink_name(A, X),
        X \== [],
        get_global_drink(T),
        append([X],T,P),
        assert(drink(P)),
        get_drink_price(A, E),
        get_global_menu_price(F),
        G is E+F,
        assert(menu_price(G)).

% getting dessert name and price from the code
get_dessert_name([H|_], X):-
        dessert_map(H, X).
get_dessert_price([H|_], X):-
        dessert_price_map(H, X).

% Retrieving dessert variable or empty if it doesn't exist
get_global_dessert(T):-
        retract(dessert(T)).
get_global_dessert(T):-
        T=[].

% Checking validity and saving the name and price of the item
check_valid_dessert(S):- 
        desserts_db(D),
        check_value_exist(S, D, A),
        get_dessert_name(A, X),
        X \== [],
        get_global_dessert(T),
        append([X],T,P),
        assert(dessert(P)),
        get_dessert_price(A, E),
        get_global_menu_price(F),
        G is E+F,
        assert(menu_price(G)).

% Print functions for welcoming, appetizer menu, maincourse menu, drink menu, dessert menu
% Just call this small functions anywhere in the file
print_welcome:-
        database_response(greeting, D),
        pick_any(D, W),
        print_bot,
        write_full_list(W), 
        flush_output. 

print_appetizer:-
        appetizers_list(W),
        print_bot,
        write_full_list(W), 
        flush_output.
    
print_maincourse:-
        maincourses_list(W),
        print_bot,
        write_full_list(W), 
        flush_output.
    
print_drink:-
        drinks_list(W),
        print_bot,
        write_full_list(W), 
        flush_output.

print_dessert:-
        desserts_list(W),
        print_bot,
        write_full_list(W), 
        flush_output.

% Function to print "Bot: " and "User:" 
bot('Bot ').
user('User').
print_bot:-
        bot(X), write(X), write(': '), flush_output.
print_user:-
        user(X), write(X), write(': '), flush_output.

% pick random
pick_any(Res, R):- 
        length(Res, Len),  
        Bound is Len + 1,
        random(1, Bound, Rand),
        nth_item(Res, Rand, R).

% Databases of different type of responses.
% Types: bye, greeting, get_aappetizers, get_amaincourses, get_adrinks, get_adesserts, get_name
%        my_name, my_appetizers, my_maincourses, my_drinks, my_desserts, thanks, thanked, me, random_questions, random_answers
database_response(bye, [
        ['Bye!'], 
        ['Hope to see you again.'], 
        ['Have a nice day!']
        ]).

database_response(greeting, [
        ['Hello, I welcome you to RK Restaurant'],
        ['Welcome to RK Restaurant!']
        ]).

database_response(get_aappetizers, [
        ['Haven\'t heard of that one before!'],
        ['Sorry that is not avaiable currently...'],
        ['Please select from above appetizer'],
        ['Hold on, I think we don\'t have that appetizer!'],
        ['We don\'t have that appetizer, can you select one from list']
        ]).

database_response(get_amaincourses, [
        ['Haven\'t heard of that one before!'],
        ['We don\'t have that one, sorry'],
        ['We don\'t have that main-course, can you select one from list'], 
        ['Hold on, I think we don\'t have that main-course!'],
        ['Sorry that is not avaiable currently...']
        ]).

database_response(get_adrinks, [
        ['Haven\'t heard of that one before!'],
        ['Sorry that is not avaiable currently...'],
        ['We don\'t have that one, sorry'],
        ['We don\'t have that drink, can you select one from list'],
        ['Hold on, I think we don\'t have that drink!']
        ]).

database_response(get_adesserts, [
        ['We don\'t have that drink, can you select one from list'],
        ['Sorry that is not avaiable currently...'],
        ['We don\'t have that one, sorry'],
        ['Hold on, I think we don\'t have that dessert!'],
        ['Haven\'t heard of that one before!']
        ]).

database_response(get_name, [
        ['Please enter you first name only'],
        ['Oh, I think I don\'t recognize that name, try something else'],
        ['I don\'t know anyone who has that name, can try enteing something else'],
        ['Can you try to enter you nick name?'],
        ['Ops, seems like I don\'t have your name in database, try something else!']
        ]).
            
database_response(my_name, [
        ['My name is Krishna, nice to meet you.'],
        ['I\'m krishna!'],
        ['Krishna, at your service, how may I help?']
        ]).

database_response(my_appetizers, [
        ['I like spring rolls!'],
        ['Samosa - it\'s great'],
        ['umm confused Never mind about my maincourse...'],
        ['channachat.']
        ]).

database_response(my_maincourses, [
        ['umm confused I don\'t know...'],
        ['Butter Chicken - it\'s great'],
        ['Vegetable Biryani'],
        ['I like Daal Makhani !']
        ]).

database_response(my_drinks, [
        ['I like tea!'],
        ['umm confused Never mind about my drinks...'],
        ['Mango Lassi - it\'s great'],
        ['Butter Milk.']
        ]).
database_response(my_desserts, [
        ['umm confused Never mind about my desserts...'],
        ['Rasmali.'],
        ['I like Rasgulla!'],
        ['GulabJamun - it\'s great']
        ]).

database_response(thanks, [
        ['Thanks for the letting me know!'],
        ['Thank you'],
        ['Ok, thanks.'],
        ['oh, My friend has that name!'],
        ['Awesome'],
        ['Nice name']
        ]).

database_response(thanked, [
        ['You\'re welcome!'],
        ['Any time.'],
        ['Glad to be of service.'],
        ['No worries.'],
        ['No problem.']
        ]).

database_response(me, [
        ['I\'m great, thanks for asking.'],
        ['Can\'t complain!'],
        ['Not too bad, yourself?'],
        ['I\'m okay, I suppose...'],
        ['Yep, I\'m fine, how are you?']
        ]).

database_response(random_questions, [
        ['oh..k'],
        ['Isn\'t it a nice day?'],
        ['Can we be friends?'],
        ['Have you talked to me before?'],
        ['Are you frequent customer?'],
        [':)'],
        ['Did you like mine restaurant?']
        ]).

database_response(random_answers, [
        ['I dunno...'],
        ['Sorry, I can\'t answer that one.'],
        ['Not sure!'],
        ['Can I get a different question?'],
        ['Oh, you\'ll have to ask someone else that.'],
        ['Sorry, I can\'t remember everything you said...'],
        ['I did not understand that one'],
        ['Soory, I cannot answer that'],
        ['I will pass your question, I do not know that answer']
        ]).
% Databases of responses done


% Databases of different type of question.
% Types: feedback, menu_dessert, menu_drink, menu_maincourse, menu_appetizer, info, hi, no, thankyou
database_questions(feedback, [
        ['Did you like talking to me?'],
        ['Ok, thanks. Have I been helpful?'],
        ['Hmm. Do you think that I am a human?'],
        ['So, what are your thoughts to make me better?']
        ]).

database_questions(menu_dessert, [
        ['Would you like to add more dessert?'],
        ['Aha, great choice. Would you like anything in desserts ?']
        ]).

database_questions(menu_drink, [
        ['Would you like to add more drinks?'],
        ['Sure. So what would you like to have in drinks?']
        ]).

database_questions(menu_maincourse, [
        ['Would you like to add more maincourse?'],
        ['Perfect. What do you prefer to have in maincourse?']
        ]).

database_questions(menu_appetizer, [
        ['Would you like to add more appetizers?'],
        ['Hope, you are hungry. So what would you like to have in appetizers (Enter only code)?']
        ]).

database_questions(info, [
        ['What\'s your name?']
        ]).

database_hi([
        hello, 
        hi, 
        hey
        ]).

database_no([
        no,
        nope,
        nothing
        ]).

database_thank([
        thank,
        pleasure,
        thanks,
        thankyou
        ]).
% Database of questions done


% Writing everthing in list, by recursive call
write_full_list([]):- nl.
write_full_list([H|T]):- write(H), write(' '), write_full_list(T).

% check if the list L2 contains List L, subset function
check_subset([], _).
check_subset([H|T], L2):- 
        member(H, L2),
        check_subset(T, L2).

check_value_exist([], _, []).
check_value_exist([H|T1], L2, [H|T3]):- 
        member(H, L2), !,
        check_value_exist(T1, L2, T3).
check_value_exist([_|T1], L2, L3):-
        check_value_exist(T1, L2, L3).

% Return the nth item
nth_item([H|_], 1, H).
nth_item([_|T], N, X):-
        nth_item(T, N1, X),
        N is N1 + 1.

% check if list B contains A
check_list_contains(A, B) :-
  atom(A),
  atom(B),
  name(A, AA),
  name(B, BB),
  check_list_contains(AA, BB).
check_list_contains(A, B) :-
  atom(A),
  name(A, AA),
  check_list_contains(AA, B).
check_list_contains(A, B) :-
  check_list_contains_helper(B, A),
  B \= [].

check_list_contains_helper(S, L) :-
  append(_, L2, L),
  append(S, _, L2).


% Helper funtion for read_input, to break the sentence and process it
read_input_helper(P):-read_initialize(L),words(P,L,[]).


read_initialize([K1,K2|U]):-get_code(K1),get_code(K2),read_initialize_helper(K2,U).

read_initialize_helper(46,[]):-!.
read_initialize_helper(63,[]):-!.
read_initialize_helper(33,[]):-!.
read_initialize_helper(10,[]):-!.

read_initialize_helper(K,[K1|U]):-K=<32,!,get_code(K1),read_initialize_helper(K1,U).
read_initialize_helper(_K1,[K2|U]):-get_code(K2),read_initialize_helper(K2,U).

% Parts of a sentence, words, numericals, digits, blank_space
words([V|U]) --> word(V),!,blank_space,words(U).
words([]) --> [].

word(U1) --> [K],{lc(K,K1)},!,numericals(U2),{name(U1,[K1|U2])}.
word(nb(N)) --> [K],{digit(K)},!,digits(U),{name(N,[K|U])}.
word(V) --> [K],{name(V,[K])}.

numericals([K1|U]) --> [K],{alpha_num(K,K1)},!,numericals(U).
numericals([]) --> [].

alpha_num(95,95) :- !.
alpha_num(K,K1):-lc(K,K1).
alpha_num(K,K):-digit(K).

digits([K|U]) --> [K],{digit(K)},!,digits(U).
digits([]) --> [].

blank_space--> [K],{K=<32},!,blank_space.
blank_space --> [].

digit(K):-K>47,K<58.

lc(K,K1):-K>64,K<91,!,K1 is K+32. 
lc(K,K):-K>96,K<123.


% Apply filter function
apply_filter([],[]).
apply_filter(['\n'|T], R):-  !,
        apply_filter(T, R).
apply_filter([nb(2), X|T], [Rm|R]):- 
        name(X, CharList),
        apply_filter_helper(CharList),!,
        name(Rm, [50|CharList]),
        apply_filter(T, R).
apply_filter([X|T], [X|R]):- 
        apply_filter(T, R).

apply_filter_helper([113,X|_]):-
        digit(X).

% Reading input and applying filter on it to categorize it
read_input(S):- read_input_helper(L), apply_filter(L,S).


% Patterns for each type of user questions

% Name questions
pattern_name([what, is, your, name, X |_], X):-!.
pattern_name(['what\'s', your, name, X |_], X):-!.
pattern_name([whats, your, name, X |_], X):-!.
pattern_name([what, are, you, called, X |_], X):-!.
pattern_name([who, are, you, X |_], X):-!.
pattern_name([_|T], X):-
        pattern_name(T, X).

% Appetizer questions
pattern_my_appetizers([what, do, you, like, in, appetizer, X |_], X):-!.
pattern_my_appetizers([what, do, you, usually, eat, in, appetizer, X |_], X):-!.
pattern_my_appetizers([can, you, suggest, any, appetizer, X |_], X):-!.
pattern_my_appetizers([your, favourite, appetizer, X |_], X):-!.
pattern_my_appetizers([_|T], X):-
        pattern_my_appetizers(T, X).

% Maincourse questions
pattern_my_maincourses([what, do, you, like, in, maincourse, X |_], X):-!.
pattern_my_maincourses([what, do, you, usually, eat, in, maincourse, X |_], X):-!.
pattern_my_maincourses([can, you, suggest, any, maincourse, X |_], X):-!.
pattern_my_maincourses([your, favourite, maincourse, X |_], X):-!.
pattern_my_maincourses([_|T], X):-
        pattern_my_maincourses(T, X).

% Drink questions
pattern_my_drinks([what, do, you, like, in, drinks, X |_], X):-!.
pattern_my_drinks([what, do, you, usually, take, in, drink, X |_], X):-!.
pattern_my_drinks([can, you, suggest, any, drinks, X |_], X):-!.
pattern_my_drinks([your, favourite, drink, X |_], X):-!.
pattern_my_drinks([_|T], X):-
        pattern_my_drinks(T, X).

% Dessert questions
pattern_my_desserts([what, do, you, like, in, desserts, X |_], X):-!.
pattern_my_desserts([what, do, you, usually, eat, in, dessert, X |_], X):-!.
pattern_my_desserts([can, you, suggest, any, desserts, X |_], X):-!.
pattern_my_desserts([your, favourite, dessert, X |_], X):-!.
pattern_my_desserts([_|T], X):-
        pattern_my_desserts(T, X).

% Questions on me 
pattern_me([how, are, you, X |_], X):-!.
pattern_me([are, you, ok, X |_], X):-!.
pattern_me([you, ok, X |_], X):-!.
pattern_me([you, okay, X |_], X):-!.
pattern_me([_|T], X):-
        pattern_me(T, X).

% Patterns done

round(X,Y,D) :- Z is X * 10^D, round(Z, ZA), Y is ZA / 10^D.

print_order:-
        write('\n--- Your Order ---\n'), fail.
print_order:-
        usr_name(P), 
        write_full_list(['User name: ', P]), fail.
print_order:-
        appetizer(T), 
        write_full_list(['Appetizers: ', T]), fail.
print_order:-
        maincourse(U), 
        write_full_list(['MainCourse: ', U]), fail.
print_order:-
        drink(R), 
        write_full_list(['Drinks: ', R]), fail.
print_order:-
        dessert(S), 
        write_full_list(['Desserts: ', S]), fail.
print_order:-
        menu_price(A),
        round(A, B, 2),
        write_full_list(['\nSubtotal:    ', B]),
        C is B*0.13,
        round(C, D, 2),
        write_full_list(['HST(13%):    ', D]), 
        E is B+D,
        round(E, F, 2),
        write_full_list(['Total:       ', F]), fail.
print_order.

print_talking_history:-
        write('\n--- Talking History ---\n'), fail.
print_talking_history:-
        nl, feedback(X, Y), write(X), write(' : '), write_full_list(Y), 
        retract(feedback(X, Y)), fail.
print_talking_history:-
        nl, menu_dessert(X, Y), write(X), write(' : '), write_full_list(Y), 
        retract(menu_dessert(X, Y)), fail.
print_talking_history:-
        nl, menu_drink(X, Y), write(X), write(' : '), write_full_list(Y), 
        retract(menu_drink(X, Y)), fail.
print_talking_history:-
        nl, menu_maincourse(X, Y), write(X), write(' : '), write_full_list(Y), 
        retract(menu_maincourse(X, Y)), fail.
print_talking_history:-
        nl, menu_appetizer(X, Y), write(X), write(' : '), write_full_list(Y), 
        retract(menu_appetizer(X, Y)), fail.
print_talking_history:-
        nl, information(X, Y), write(X), write(' : '), write_full_list(Y), 
        retract(information(X, Y)), fail.
print_talking_history.


?-chatbot. 