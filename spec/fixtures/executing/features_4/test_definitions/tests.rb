def checking_the_before_hook
  check = @before_var
  pass "I check for a variable set up by the hook"
  check.should == 42
  pass "I should find it"
end

def checking_the_tagged_before_hook
  check = @before_var
  pass "I check for a variable set up by the hook"
  check.should == 'monkey butler'
  pass "I should find it"
end

def checking_the_after_hook
  $after_var = "foo"
  pass "I set up a variable for the after hook"
end

def checking_the_tagged_after_hook
  $after_var = "foo"
  pass "I set up a variable for the after hook"
end

def before_and_after_for_a_failed_test
  $after_var = "foo"
  # note no pass line; this test will fail
end