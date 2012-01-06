logic = require './logically'


#   1. The diner who ate the beans did not eat the chicken.
#   2. Cronkel did not eat the chicken.
#   3. The diner who ate the beef was neither Cronkel nor Frossel.
#   4. The diner who ate the duck was not Trusil.
#   5. The diner who ate the asparagus was neither Frossel nor Trusil.
#   6. The diner who ate the duck ate neither the beans nor the corn.
#   7. Cronkel ate neither the turnips nor the asparagus.
#   8. The diner who ate the turnips was not Frossel.


cronkel = "Cronkel"
frossel = "Frossel"
grimble = "Grimble"
trusil = "Trusil"
diners = [cronkel, frossel, grimble, trusil]

beef = "beef"
chicken = "chicken"
duck = "duck"
venison = "venison"
meats = [beef, chicken, duck, venison]

asparagus = "asparagus"
beans = "beans"
corn = "corn"
turnips = "turnips"
vegetables = [asparagus, beans, corn, turnips]



clue1 = new logic.IndirectClue {vegetable: beans}, {meat: chicken}
clue2 = new logic.IndirectClue {diner: cronkel}, {meat: chicken}
clue3 = new logic.MultipleIndirectClue {meat: beef}, {diner: [cronkel, frossel]}
clue4 = new logic.IndirectClue {meat: duck}, {diner: trusil}
clue5 = new logic.MultipleIndirectClue {vegetable: asparagus}, {diner: [frossel, trusil]}
clue6 = new logic.MultipleIndirectClue {meat: duck}, {vegetable: [beans, corn]}
clue7 = new logic.MultipleIndirectClue {diner: cronkel}, {vegetable: [turnips, asparagus]}
clue8 = new logic.IndirectClue {vegetable: turnips}, {diner: frossel}

clues = [clue1, clue2, clue3, clue4, clue5, clue6, clue7, clue8]



logic.solve {diner: diners},
  meat: meats
  vegetable: vegetables,
  clues
