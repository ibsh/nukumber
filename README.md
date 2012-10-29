Nukumber
========

A marginally less aggravating alternative to Cucumber

Note that this is very much a personal hobby project at the moment; you use it
utterly at your own risk.

After using Cucumber for a few months I got tired of problems with collisions in
the vocabulary of step names. I know that a ubiquitous language is supposed to
take care of such problems, but sometimes you're not in a position to affect the
language used on your project, and sometimes your project is so complex that
semantic overloading becomes likely if not inevitable.

So, if two steps are called the same thing but only do NEARLY the same thing,
you can end up with lots of horrible shared state and context conditions.

I still wanted to be able to run tests from feature files, which are a really
great method of communication and a good artefact of specification, but I needed
to get away from the shared step definition paradigm. Nukumber enables me to
write a single, distinct method for each feature element (background/scenario/
scenario outline) while still requiring adherence to the feature file.


For example (and included in the RSpec for the gem), the silly feature file:

Feature: Ruby arithmetic functions
  Scenario Outline: Addition
    Given I have integers <a> and <b>
    When I add them
    Then the result is <result>
  Examples: Easy sums
    | a | b | result |
    | 1 | 2 | 3      |
    | 5 | 9 | 14     |


Can be addressed by an equally silly Ruby file:

def addition

  a = $example['a'].to_i
  b = $example['b'].to_i
  pass 'I have integers <a> and <b>'

  result = a + b
  pass 'I add them'

  fail unless result == $example['result'].to_i
  pass 'the result is <result>'

end


So, what's the point of all this? The method is a test definition, not a step
definition. It's similar to RSpec or XUnit. I don't need to save any of my work
in a broader scope to pass it between steps, and the vocabulary of the steps can
gloss over unnecessarily complex context or detail. That may not be great from a
pure BDD perspective, but it's helpful when you're a tester on a complicated
legacy system.

What's common with Cucumber?
* If the feature file changes, the test will fail.
* I can still pass data into my test code from the Gherkin (any step arguments
  can be found in $args, and the current example for a Scenario Outline is in
  $example)
* I must still tie the test code to the progression of passing/failing steps.
* The test definition should still act as a thin translation layer between the
  Gherkin and my Ruby test classes.
* I can specify where my feature and definition files are to the Nukumber CLI.
  This means I can easily work on Cukes and Nukes on the same project if
  necessary.
* I can still tag my features and scenarios and run them by tag.
