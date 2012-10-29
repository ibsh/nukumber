Before do
  @before_var = 42
end

Before ('@tagged, @twice') do
  @before_var = 'monkey butler'
end

After do
  $after_var = "bar" if $after_var == "foo"
end

After ('@tagged') do |element, status|
  $after_var = "baz"
  $element = element
  $status = status
end
