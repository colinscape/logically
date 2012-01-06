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

    # If eating beef, eat squash
    if solution[@kind1].length is 1 and @value1 in solution[@kind1] and @value2 in solution[@kind2]
      solution[@kind2] = [@value2]

    # If not eating squash, remove beef
    if @value2 not in solution[@kind2] and @value1 in solution[@kind1]
      solution[@kind1] = _.without solution[@kind1], @value1

    # If eating squash, eat beef
    if solution[@kind2].length is 1 and @value2 in solution[@kind2] and @value1 in solution[@kind1]
      solution[@kind1] = [@value1]

    # If not eating beef, remove squash
    if @value1 not in solution[@kind1] and @value2 in solution[@kind2]
      solution[@kind2] = _.without solution[@kind2], @value2

    return solution

# This is of the form "The diner who ate beef ate squash or asparagus"
class ChoiceDirectClue
  constructor: (arg1, arg2) ->
    for kind,value of arg1
      @kind1 = kind
      @value1 = value
    for kind,value of arg2
      @kind2 = kind
      @value2 = value

  resolve: (solution) ->

    # If eating beef, don't eat anything but squash and asparagus
    if solution[@kind1].length is 1 and @value1 in solution[@kind1]
      solution[@kind2] = @value2

    # If not eating squash and asparagus, remove beef
    if (_.difference solution[@kind2], @value2).length is solution[@kind2].length
      solution[@kind1] = _.without solution[@kind1], @value1

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

    # If eating beef then remove squash
    if solution[@kind1].length is 1 and @value1 in solution[@kind1] and @value2 in solution[@kind2]
      solution[@kind2] = _.without solution[@kind2], @value2

    # If eating squash, remove beef
    if solution[@kind2].length is 1 and @value2 in solution[@kind2] and @value1 in solution[@kind1]
      solution[@kind1] = _.without solution[@kind1], @value1

    return solution

# This is of the form "The diner who ate beef didn't eat squash or asparagus"
class MultipleIndirectClue
  constructor: (@arg1, @arg2) ->
    for kind,value of arg1
      @kind1 = kind
      @value1 = value
    for kind,value of arg2
      @kind2 = kind
      @value2 = value


  resolve: (solution) ->

    # First, treat the multiple things independently
    for v in @value2
      # If eating beef then remove squash
      if solution[@kind1].length is 1 and @value1 in solution[@kind1] and v in solution[@kind2]
        solution[@kind2] = _.without solution[@kind2], v

      # If eating squash, remove beef
      if solution[@kind2].length is 1 and v in solution[@kind2] and @value1 in solution[@kind1]
        solution[@kind1] = _.without solution[@kind1], @value1

    # Secondly, look for possibilities that have only the multiple
    # Eg, if the vegetable choice is either squash or aparagus then can't eat beef
    seek = @value2.sort()
    if solution[@kind2].length is seek.length and (_.difference seek, solution[@kind2]).length is 0
      solution[@kind1] = _.without solution[@kind1], @value1

    return solution


# Find situations where, for example, there are 2 diners who could eat only beans or corn
# In this case, no other diner can eat beans or corn
resolveCircles = (solution) ->

  possibleCircles = {}
  for s in solution
    for k,v of s
      possibleCircles[k] = [] if not possibleCircles[k]?
      possibleCircles[k].push (_.clone v).sort()

  result = []
  for k,v of possibleCircles
    for test in v
      partners = _.filter v, (a) -> 
        (_.difference a, test).length is 0 and (_.difference test, a).length is 0 
      if partners.length is test.length and test.length > 1
        counter = 0
        for s in solution
          r = _.clone s
          if solution[counter][k].length > test.length
            solution[counter][k] = _.without solution[counter][k], test
          ++counter
                     
  return solution

# Find categories that have been solved and ensure that this knowledge is propagated.
cleanup = (solution) ->

  solved = {}
  for s in solution
    for k,v of s
      if v.length is 1
        solved[k] = [] if not solved[k]?
        solved[k].push v  

  result = []
  for s in solution
    for k,v of s
      if v.length > 1
        s[k] = _.without v, solved[k]
    result.push s
  return result


# Measure the ambiguity in a solution
ambiguity = (solution) ->
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

  quality = ambiguity solution
  oldQuality = quality + 1
  while quality < oldQuality

    solution = _.reduce clues,
                        (solution, clue) ->
                          clue.resolve s for s in solution
                        solution

    solution = resolveCircles solution

    solution = cleanup solution


    oldQuality = quality
    quality = ambiguity solution

  if quality is 0
    console.log "Solved!"
    console.log solution
  else
    console.log "Failed to solve. Current state:"
    console.log solution

  
  
module.exports.solve = solve
module.exports.DirectClue = DirectClue
module.exports.IndirectClue = IndirectClue
module.exports.MultipleIndirectClue = MultipleIndirectClue
module.exports.ChoiceDirectClue = ChoiceDirectClue
