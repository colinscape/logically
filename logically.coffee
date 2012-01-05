_ = require 'underscore'

# This is of the form "The diner who ate beef ate squash"
class DirectClue
  constructor: (arg1, arg2) ->
    for kind,value of arg1
      @kind1 = kind
      @value1 = value
    for kind,value of arg2
      @kind2 = kind
      @value2 = value

  resolve: (solution) ->

    if solution[@kind1].length is 1 and @value1 in solution[@kind1] and @value2 in solution[@kind2]
      solution[@kind2] = [@value2]

    if @value2 not in solution[@kind2] and @value1 in solution[@kind1]
      solution[@kind1] = _.without solution[@kind1], @value1

    if solution[@kind2].length is 1 and @value2 in solution[@kind2] and @value1 in solution[@kind1]
      solution[@kind1] = [@value1]

    if @value1 not in solution[@kind1] and @value2 in solution[@kind2]
      solution[@kind2] = _.without solution[@kind2], @value2

    return solution

# This is of the form "The diner who ate beef didn't eat squash"
class IndirectClue
  constructor: (@arg1, @arg2) ->
    for kind,value of arg1
      @kind1 = kind
      @value1 = value
    for kind,value of arg2
      @kind2 = kind
      @value2 = value


  resolve: (solution) ->

    if solution[@kind1].length is 1 and @value1 in solution[@kind1] and @value2 in solution[@kind2]
      solution[@kind2] = _.without solution[@kind2], @value2

    if solution[@kind2].length is 1 and @value2 in solution[@kind2] and @value1 in solution[@kind1]
      solution[@kind1] = _.without solution[@kind1], @value1

    if solution[@kind2].length is 1 and @value2 in solution[@kind2] and @value1 in solution[@kind1]
      solution[@kind1] = _.without solution[@kind1], @value1

    if solution[@kind1].length is 1 and @value1 in solution[@kind1] and @value2 in solution[@kind2]
      solution[@kind2] = _.without solution[@kind2], @value2

    return solution


cleanup = (solution) ->

  solved = {}
  for s in solution
    for k,v of s
      if v.length is 1
        solved[k] = [] if not solved[k]?
        solved[k].push v  
  #console.log solved

  result = []
  for s in solution
    for k,v of s
      if v.length > 1
        s[k] = _.without v, solved[k]
    result.push s
  return result



badness = (solution) ->
  total = 0
  for s in solution
    total += s.diner.length + s.meat.length + s.vegetable.length - 3
  return total



solve = (key, data, clues) ->

  solution = []
  for index,values of key

    for v in values
      s = _.clone data
      s[index] = [v]
      solution.push s

  #console.log solution

  quality = badness solution
  oldQuality = quality + 1
  while quality < oldQuality

    solution = _.reduce clues,
                        (solution, clue) ->
                          clue.resolve s for s in solution
                        solution

    solution = cleanup solution


    oldQuality = quality
    quality = badness solution

  if quality is 0
    console.log "Solved!"
    console.log solution
  else
    console.log "Failed to solve. Current state:"
    console.log solution

  
  
module.exports.solve = solve
module.exports.DirectClue = DirectClue
module.exports.IndirectClue = IndirectClue

