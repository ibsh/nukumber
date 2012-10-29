def something_to_pass
  pass "a precondition"
  pass "an action"
  pass "a postcondition"
end

def something_to_fail
  pass "a precondition"
  pass "an action"
  fail "I refuse to pass!"
  pass "a postcondition"
end