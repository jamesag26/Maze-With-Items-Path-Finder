%James Alford-Golojuch
:- use_module(library(lists)).

%Initializes mazepath
mazepath(X,Y,Maze,[PathTemp2|PathMt],Score) :-
	%Checks to make sure maze has all valid items in it
	validmaze(e,Maze),
	validmaze(p,Maze),
	validmaze(mb,Maze),
	validmaze(mt,Maze),
	%Adds item to lists if player spawns on one
	walkable(X,Y,Maze,[],P2,[],E2,[],Mb2,[],Mt2),

	%travelmaze(X,Y,Maze,Path,Score,Visited,Item,Pikachu,Egg,Masterball,Mewtwo)
	%Search for eggs
	travelmaze(X,Y,Maze,PathE,Score,[[X,Y]],[e],PE,P2,EE,E2,MbE,Mb2,MtE,Mt2),
	%Gets last coordinates of PathE to start PathP at
	last(PathE,CoordsE),
	nth1(1,CoordsE,Xp),
	nth1(2,CoordsE,Yp),
	%Removes last coordinates from PathE to avoid repetition of coordinates	
	delete(PathE,CoordsE,PathE2),	

	%Search for pikachu
	travelmaze(Xp,Yp,Maze,PathP,Score,[[Xp,Yp]],[p],PP,PE,EP,EE,MbP,MbE,MtP,MtE),
	%Gets last coordinates of PathP to start PathMb at
	last(PathP,CoordsP),
	nth1(1,CoordsP,Xmb),
	nth1(2,CoordsP,Ymb),
	%Removes last coordinates from PathE to avoid repetition of coordinates	
	delete(PathP,CoordsP,PathP2),
	%Appends PathE2 and PathP2
	append(PathE2,PathP2,PathTemp),

	%Search for masterballs
	travelmaze(Xmb,Ymb,Maze,PathMb,Score,[[Xmb,Ymb]],[mb],PMb,PP,EMb,EP,MbMb,MbP,MtMb,MtP),
	%Gets last coordinates of PathMb to start PathMt at
	last(PathMb,CoordsMb),
	nth1(1,CoordsMb,Xmt),
	nth1(2,CoordsMb,Ymt),
	%Removes last coordinates from PathMb to avoid repetition of coordinates	
	delete(PathMb,CoordsMb,PathMb2),
	%Appends PathTemp and PathMb2
	append(PathTemp,PathMb2,PathTemp2),

	%Search for mewtwos
	travelmaze(Xmt,Ymt,Maze,PathMt,Score,[[Xmt,Ymt]],[mt],_,PMb,_,EMb,_,MbMb,_,MtMb).

%———————————travelmaze()——————————————
%Victory condition when searching for eggs
travelmaze(_,_,_,Path,_,Path,Item,Pikachu,Pikachu,Egg,Egg,Masterball,Masterball,Mewtwo,Mewtwo) :-
	%Checks if we are searching for pikachus
	nth1(1,Item,e),
	%Checks if we have found at least one egg
	length(Egg,N),
	N > 0,
	%Checks if we have hatched at least one egg
	hatchedeggs(Egg,Hatched,0),
	Hatched > 0,
	!.
	
%Victory condition when searching for pikachu
travelmaze(_,_,_,Path,_,Path,Item,Pikachu,Pikachu,Egg,Egg,Masterball,Masterball,Mewtwo,Mewtwo) :-
	%Checks if we are searching for pikachus
	nth1(1,Item,p),
	%Checks if we have found at least one pikachu
	length(Pikachu,N),
	N > 0,
	!.

%Victory condition when searching for masterball	
travelmaze(_,_,_,Path,_,Path,Item,Pikachu,Pikachu,Egg,Egg,Masterball,Masterball,Mewtwo,Mewtwo) :-
	%Checks if we are searching for masterballs
	nth1(1,Item,mb),
	%Checks if we have found at least one masterball
	length(Masterball,N),
	N > 0,
	!.

%Victory condition when searching for mewtwo
travelmaze(X,Y,_,Path,Score,Path,Item,Pikachu,Pikachu,Egg,Egg,Masterball,Masterball,Mewtwo,Mewtwo) :-
	%Checks if we are searching for mewtwo
	nth1(1,Item,mt),
	%Checks if we have found a square where mewtwo is
	length(Mewtwo,N),
	N > 0,
	%Checks if we are in a square where mewtwo is
	member([X,Y],Mewtwo),
	%Number of pikachu caught
	length(Pikachu,Np),
	%Number of eggs hatched
	hatchedeggs(Egg,Hatched,0),
	Score is Np + Hatched * 10,
	!.


%Move one unit down the path
travelmaze(X,Y,Maze,Path,Score,Visited,Item,PF,Pikachu,EF,Egg,MbF,Masterball,MtF,Mewtwo) :-
	YTemp is Y-1,
	%Checks to make sure new coordinates are still in maze
	YTemp > 0,
	%Checks to make sure path has not been visited before
	\+ member([X,YTemp],Visited),
	%Update distance traveled for hatching eggs if any
	hatchingeggs(Egg,Updatedeggs,[]),
	%Checks for walkable path and updates items if needed
	walkable(X,YTemp,Maze,Pikachu,P2,Updatedeggs,E2,Masterball,Mb2,Mewtwo,Mt2),
	%Path is walkable so update visited path
	append(Visited,[[X,YTemp]],Newvisited),
	%Travel maze from new coordinates
	travelmaze(X,YTemp,Maze,Path,Score,Newvisited,Item,PF,P2,EF,E2,MbF,Mb2,MtF,Mt2).

%Move one unit right on the path
travelmaze(X,Y,Maze,Path,Score,Visited,Item,PF,Pikachu,EF,Egg,MbF,Masterball,MtF,Mewtwo) :-
	XTemp is X+1,
	%Finds length of row from maze and makes sure new coordinate isn’t out of maze
	nth1(1,Maze,Row),
	length(Row,N),
	XTemp =< N,
	%Checks to make sure path has not been visited before
	\+ member([XTemp,Y],Visited),
	%Update distance traveled for hatching eggs if any
	hatchingeggs(Egg,Updatedeggs,[]),
	%Checks for walkable path and updates items if needed
	walkable(XTemp,Y,Maze,Pikachu,P2,Updatedeggs,E2,Masterball,Mb2,Mewtwo,Mt2),
	%Path is walkable so update visited path
	append(Visited,[[XTemp,Y]],Newvisited),
	%Travel maze from new coordinates
	travelmaze(XTemp,Y,Maze,Path,Score,Newvisited,Item,PF,P2,EF,E2,MbF,Mb2,MtF,Mt2).

%Follows same format as the travelmaze()’s above
%Move one unit up the path
travelmaze(X,Y,Maze,Path,Score,Visited,Item,PF,Pikachu,EF,Egg,MbF,Masterball,MtF,Mewtwo) :-
	YTemp is Y+1,
	length(Maze,N),
	YTemp =< N,
	%Checks to make sure path has not been visited before
	\+ member([X,YTemp],Visited),
	hatchingeggs(Egg,Updatedeggs,[]),
	walkable(X,YTemp,Maze,Pikachu,P2,Updatedeggs,E2,Masterball,Mb2,Mewtwo,Mt2),
	append(Visited,[[X,YTemp]],Newvisited),
	travelmaze(X,YTemp,Maze,Path,Score,Newvisited,Item,PF,P2,EF,E2,MbF,Mb2,MtF,Mt2).

%Move one unit left on the path
travelmaze(X,Y,Maze,Path,Score,Visited,Item,PF,Pikachu,EF,Egg,MbF,Masterball,MtF,Mewtwo) :-
	XTemp is X-1,
	XTemp > 0,
	%Checks to make sure path has not been visited before
	\+ member([XTemp,Y],Visited),
	hatchingeggs(Egg,Updatedeggs,[]),
	walkable(XTemp,Y,Maze,Pikachu,P2,Updatedeggs,E2,Masterball,Mb2,Mewtwo,Mt2),
	append(Visited,[[XTemp,Y]],Newvisited),
	travelmaze(XTemp,Y,Maze,Path,Score,Newvisited,Item,PF,P2,EF,E2,MbF,Mb2,MtF,Mt2).


%———————————End travelmaze()——————————————


%———————————walkable()——————————————
%Checking for walkable space which is false if space is not one of these spaces (‘j’)
%Checks for walkable space ‘o’ - no item, open space
walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	%Takes Y row from list and checks Xth space of row for value ‘o’
	%If value ‘o’ then space is walkable and nothing else happens
	nth1(Y,Maze,Row),
	nth1(X,Row,o),
	%Append original list values to corresponding ***2 values
	append(Pikachu,[],P2),
	append(Egg,[],E2),
	append(Masterball,[],Mb2),
	append(Mewtwo,[],Mt2).

%Rest of walkable() follows same format as the one above except
%Replace variable names being appended to lists depending on value of space
%Checks for walkable space ‘p’ - pikachu

%Appends item if space ahsnt been visited before
walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,p),
	%Checks if specific item has been picked up before
	member([X,Y],Pikachu),
	%Appends position of pikachu to P2 so that its known that we found a pikachu
	append(Pikachu,[],P2),
	append(Egg,[],E2),
	append(Masterball,[],Mb2),
	append(Mewtwo,[],Mt2).

walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,p),
	%Appends position of pikachu to P2 so that its known that we found a pikachu
	append(Pikachu,[[X,Y]],P2),
	append(Egg,[],E2),
	append(Masterball,[],Mb2),
	append(Mewtwo,[],Mt2).

%Checks for walkable space ‘e’ - egg
%If specific item at coordinates has been picked up before
walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,e),
	%Checks if item at coordinates has been picked up before
	member([X,Y,_],Egg),
	%Appends position of egg so that its known we found an egg
	append(Egg,[],E2),
	append(Pikachu,[],P2),
	append(Masterball,[],Mb2),
	append(Mewtwo,[],Mt2).

walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,e),
	%Appends position of egg so that its known we found an egg
	append(Egg,[[X,Y,0]],E2),
	append(Pikachu,[],P2),
	append(Masterball,[],Mb2),
	append(Mewtwo,[],Mt2).

%Checks for walkable space ‘mb’ - masterball
walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,mb),
	%Checks if item at coordinates has been picked up before
	member([X,Y],Masterball),
	%Appends position of master ball to Mb2 so its known we have a masterball
	append(Masterball,[],Mb2),
	append(Pikachu,[],P2),
	append(Egg,[],E2),
	append(Mewtwo,[],Mt2).

walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,mb),
	%Appends position of master ball to Mb2 so its known we have a masterball
	append(Masterball,[[X,Y]],Mb2),
	append(Pikachu,[],P2),
	append(Egg,[],E2),
	append(Mewtwo,[],Mt2).

%Checks for walkable space ‘mt’ - mewtwo
walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,mt),
	%Checks if location has already been visited
	member([X,Y],Mewtwo),
	%Appends position of mewtwo to Mt2 so that its known that we found a mewtwo
	append(Mewtwo,[],Mt2),
	append(Pikachu,[],P2),
	append(Egg,[],E2),
	append(Masterball,[],Mb2).

walkable(X,Y,Maze,Pikachu,P2,Egg,E2,Masterball,Mb2,Mewtwo,Mt2) :-
	nth1(Y,Maze,Row),
	nth1(X,Row,mt),
	%Appends position of mewtwo to Mt2 so that its known that we found a mewtwo
	append(Mewtwo,[[X,Y]],Mt2),
	append(Pikachu,[],P2),
	append(Egg,[],E2),
	append(Masterball,[],Mb2).

%———————————End walkable()——————————————

%———————————hatchingeggs()——————————————
%If there are no eggs then nothing happens
hatchingeggs(Eggs,Updatedeggs,Updatedeggs) :-
	length(Eggs,0).

hatchingeggs([Head|Tail],Finaleggs,Updatedeggs) :-
	%Checks to see if egg has already been hatched
	nth1(3,Head,Count),
	Count >= 3,
	append(Updatedeggs,[Head],Updatedeggs2),
	%Check next egg for being hatched
	hatchingeggs(Tail,Finaleggs,Updatedeggs2).

hatchingeggs([Head|Tail],Finaleggs,Updatedeggs) :-
	%Gets coordinates of egg to update the counter
	nth1(1,Head,X),
	nth1(2,Head,Y),
	%Increases Count for egg
	nth1(3,Head,Count),
	Newcount is Count+1,
	append(Updatedeggs,[[X,Y,Newcount]],Updatedeggs2),
	%Check next egg
	hatchingeggs(Tail,Finaleggs,Updatedeggs2).

%———————————End hatchingeggs()——————————————

%———————————hatchingeggs()——————————————

%When no eggs are currently being hatched
hatchedeggs(Eggs,N,N) :-
	length(Eggs,0).

%When top egg is hatched
hatchedeggs([Head|Tail],Nf,N) :-
	%See if top egg has distance of 3
	nth1(3,Head,Dist),
	Dist >= 3,
	%If so increase count of hatched eggs
	N2 is N+1,
	%Check next egg
	hatchedeggs(Tail,Nf,N2).

%When top egg isn’t hatched
hatchedeggs([_|Tail],Nf,N) :-
	hatchedeggs(Tail,Nf,N).

%———————————End hatchingeggs()——————————————

%———————————validmaze()——————————————
%Checks to see if Item in a member of each row of the maze until it is found or its not
validmaze(Item,[Head|_]) :-
	member(Item,Head).

validmaze(Item,[_|Tail]) :-
	validmaze(Item,Tail).