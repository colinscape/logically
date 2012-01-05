logic = require './logically'

#   1. The diner who ate the beef ate the squash.
#   2. The diner who ate the beef was Cronkel.
#   3. The diner who ate the turnips was not Gertel.
#   4. The diner who ate the pork was not Pendoz.


cronkel = "Cronkel"
gertel = "Gertel"
pendoz = "Pendoz"
diners = [cronkel, gertel, pendoz]

beef = "beef"
chicken = "chicken"
pork = "pork"
meats = [beef, chicken, pork]

asparagus = "asparagus"
squash = "squash"
turnips = "turnips"
vegetables = [asparagus, squash, turnips]



clue1 = new logic.DirectClue {meat: beef}, {vegetable: squash}
clue2 = new logic.DirectClue {meat: beef}, {diner: cronkel}
clue3 = new logic.IndirectClue {vegetable: turnips}, {diner: gertel}
clue4 = new logic.IndirectClue {meat: pork}, {diner: pendoz}
clues = [clue1, clue2, clue3, clue4]



logic.solve {diner: diners},
  meat: meats
  vegetable: vegetables,
  clues
