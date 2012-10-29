def a1
  # $args is a Hash (or Array of Hashes) representing any step arguments
  # Now precede each "pass" line below with the code it describes...
  pass "one"
  pass "three"
end

def a2
  # $args is a Hash (or Array of Hashes) representing any step arguments
  # Now precede each "pass" line below with the code it describes...
  pass "these:"
  fail
  pass "this"
  pass "that"
end

def a3
  # $args is a Hash (or Array of Hashes) representing any step arguments
  # $example is a Hash representing the current row for this outline
  # Now precede each "pass" line below with the code it describes...
  pass "a <object>"
  pass "I listen"
  pass "I hear <sound>"
end

def a4
  # $args is a Hash (or Array of Hashes) representing any step arguments
  # $example is a Hash representing the current row for this outline
  # Now precede each "pass" line below with the code it describes...
  pass "a <object>"
  pass "I do these things to it:"
  pass "its response is <response>"
end

def some_background
  # $args is a Hash (or Array of Hashes) representing any step arguments
  # Now precede each "pass" line below with the code it describes...
  pass "a setup step"
  pass "another setup step"
end

def b1
  # $args is a Hash (or Array of Hashes) representing any step arguments
  # Now precede each "pass" line below with the code it describes...
  pass "a precondition"
  pass "an action"
  fail "oh bugger"
end

def b2
  # $args is a Hash (or Array of Hashes) representing any step arguments
  # $example is a Hash representing the current row for this outline
  # Now precede each "pass" line below with the code it describes...
  pass "an <object>"
  pass "I look at it" unless $example['colour'] == 'yellow'
  pass "it is <colour>" unless $example['colour'] == 'yellow'
end
