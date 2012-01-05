logic = require './logically'

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



clue1  = new logic.IndirectClue {vegetable: beans}, {meat: chicken}
clue2  = new logic.IndirectClue {diner: cronkel}, {meat: chicken}
clue3a = new logic.IndirectClue {meat: beef}, {diner: cronkel}
clue3b = new logic.IndirectClue {meat: beef}, {diner: frossel}
clue4  = new logic.IndirectClue {meat: duck}, {diner: trusil}
clue5a = new logic.IndirectClue {vegetable: asparagus}, {diner: frossel}
clue5b = new logic.IndirectClue {vegetable: asparagus}, {diner: trusil}
clue6a = new logic.IndirectClue {meat: duck}, {vegetable: beans}
clue6b = new logic.IndirectClue {meat: duck}, {vegetable: corn}
clue7a = new logic.IndirectClue {diner: cronkel}, {vegetable: turnips}
clue7b = new logic.IndirectClue {diner: cronkel}, {vegetable: asparagus}
clue8  = new logic.IndirectClue {vegetable: turnips}, {diner: frossel}

clues = [clue1, clue2, clue3a, clue3b, clue4, clue5a, clue5b, clue6a, clue6b, clue7a, clue7b, clue8]



logic.solve {diner: diners},
  meat: meats
  vegetable: vegetables,
  clues
