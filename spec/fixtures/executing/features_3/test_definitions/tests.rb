def background
  @monkeybutler = [2.8, 7, 'ahoy']
  pass "I set an instance variable in a Background"
end

def test
  local = @monkeybutler
  pass "I check the instance variable"
  local.should == [2.8, 7, 'ahoy']
  pass "it has the correct value"
end