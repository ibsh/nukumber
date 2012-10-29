def addition

  a = $example['a'].to_i
  b = $example['b'].to_i
  pass 'I have integers <a> and <b>'

  result = a + b
  pass 'I add them'

  fail unless result == $example['result'].to_i
  pass 'the result is <result>'

end
