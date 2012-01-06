logic = require './logically'


#   1. Cronkel ate neither the turnips nor the peas.
#   2. The diner who ate the lamb did not eat the orange.
#   3. The diner who ate the lamb ate either the turnips or the broccoli.
#   4. The diner who ate the pork was not Frensel.
#   5. The diner who ate the pork did not eat the raspberries.
#   6. The diner who ate the pear ate the duck.
#   7. Wozisil ate either the mango or the pear.
#   8. Frensel did not eat the broccoli.
#   9. The diner who ate the orange was not Cronkel.
#  10. The diner who ate the peas ate either the mango or the raspberries.
#  11. Frensel did not eat the raspberries.
#  12. The diner who ate the raspberries did not eat the broccoli.


cronkel = "Cronkel"
frensel = "Frensel"
pendoz = "Pendoz"
wozisil = "Wozisil"
diners = [cronkel, frensel, pendoz, wozisil]

duck = "duck"
goose = "goose"
lamb = "lamb"
pork = "pork"
meats = [duck, goose, lamb, pork]

broccoli = "broccoli"
peas = "peas"
spinach = "spinach"
turnips = "turnips"
vegetables = [broccoli, peas, spinach, turnips]

mango = "mango"
orange = "orange"
pear = "pear"
raspberries = "raspberries"
fruits = [mango, orange, pear, raspberries]



clue1  = new logic.MultipleIndirectClue {diner: cronkel}, {vegetable: [turnips, peas]}
clue2  = new logic.IndirectClue {meat: lamb}, {vegetable: orange}
clue3  = new logic.ChoiceDirectClue {meat: lamb}, {vegetable: [turnips, broccoli]}
clue4  = new logic.IndirectClue {meat: pork}, {diner: frensel}
clue5  = new logic.IndirectClue {meat: pork}, {fruit: raspberries}
clue6  = new logic.DirectClue {fruit: pear}, {meat:duck}
clue7  = new logic.ChoiceDirectClue {diner: wozisil}, {fruit: [mango, pear]}
clue8  = new logic.IndirectClue {diner: frensel}, {vegetable: broccoli}
clue9  = new logic.IndirectClue {fruit: orange}, {diner: cronkel}
clue10 = new logic.ChoiceDirectClue {vegetable: peas}, {fruit: [mango, raspberries]}
clue11 = new logic.IndirectClue {diner: frensel}, {fruit: raspberries}
clue12 = new logic.IndirectClue {fruit: raspberries}, {vegetable: broccoli}

clues = [clue1, clue2, clue3, clue4, clue5, clue6, clue7, clue8, clue9, clue10, clue11, clue12]



logic.solve {diner: diners},
  meat: meats
  vegetable: vegetables
  fruit: fruits,
  clues
