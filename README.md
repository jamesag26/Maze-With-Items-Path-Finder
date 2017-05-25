# Maze-With-Items-Path-Finder
This project is written in prolog. For this project given a beginning coordinate in the maze and a maze that looks similiar to this:  
maze[[o,e,j,p,o],
    [o,j,o,o,o],
    [o,j,mt,j,o],
    [o,o,e,o,o],
    [p,o,j,mb,o]]
Where 0s represent open spaces to traverse and j's represent blocked paths, p's represent pikachu, mb represents a masterball, mt represents a mewtwo and e represents an egg. This program will return the path taken from beginning to end along with the user score based upon how many eggs are hatched and pikachus are caught along the way to getting the masterball and using it to catch mewtwo. Even given an unsolvable path the program will successfully terminate. Some requirements before the path ends by catching mewtwo are that an egg has to be hatched, which means an egg has to be picked up and walked 3 spaces with before catching mewtwo, at least 1 pikachu has to be caught and the masterball has to be picked up. More than one egg can be hatched and more than one pikachu can be caught which would boost the score. Hatched eggs are worth 10 points and pikachus are worth 1 point. The score doesnt factor into the path finders decision making besides for the need to have at least 1 pikachu and 1 hatched egg. The score and path taken are returned to the user.
Included here is the prolog file for solving a path in a given maze and a report explaining the decisions behind the design of the program and that goes more in depth in what each function does in the program.
