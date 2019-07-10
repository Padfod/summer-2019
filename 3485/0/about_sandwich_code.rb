# frozen_string_literal: true

# rubocop:diasble all
# rubocop:disable Security/Open, Lint/AssignmentInCondition
require File.expand_path(File.dirname(__FILE__) + '/neo')

# class sandwich
# :reek:FeatureEnvy
# :reek:UncommunicativeMethodName
# :reek:UnusedParameters
class AboutSandwichCode < Neo::Koan
  def count_lines(file_name)
    file = open(file_name)
    count = 0
    count += 1 while file.gets
    count
  ensure
    file.close
  end

  def test_counting_lines
    assert_equal 4, count_lines('example_file.txt')
  end

  def find_line(file_name)
    file = open(file_name)
    while line = file.gets
      return line if line =~ /e/
    end
  ensure
    file.close
  end

  def test_finding_lines
    assert_equal "test\n", find_line('example_file.txt')
  end

  # ------------------------------------------------------------------
  # THINK ABOUT IT:
  #
  # The count_lines and find_line are similar, and yet different.
  # They both follow the pattern of 'sandwich code'.
  #
  # Sandwich code is code that comes in three parts: (1) the top slice
  # of bread, (2) the meat, and (3) the bottom slice of bread.  The
  # bread part of the sandwich almost always goes together, but
  # the meat part changes all the time.
  #
  # Because the changing part of the sandwich code is in the middle,
  # abstracting the top and bottom bread slices to a library can be
  # difficult in many languages.
  #
  # (Aside for C++ programmers: The idiom of capturing allocated
  # pointers in a smart pointer constructor is an attempt to deal with
  # the problem of sandwich code for resource allocation.)
  #
  # Consider the following code:
  #

  def file_sandwich(file_name)
    file = open(file_name)
    yield(file)
  ensure
    file.close
  end

  # Now we write:

  def count_lines2(file_name)
    file_sandwich(file_name) do |file|
      count = 0
      count += 1 while file.gets
      count
    end
  end

  def test_counting_lines2
    assert_equal 4, count_lines2('example_file.txt')
  end

  # ------------------------------------------------------------------

  def find_line2(file_name)
    # Rewrite find_line using the file_sandwich library function.
  end

  def test_finding_lines2
    assert_equal nil, find_line2('example_file.txt')
  end

  # ------------------------------------------------------------------

  def count_lines3(file_name)
    open(file_name) do |file|
      count = 0
      count += 1 while file.gets
      count
    end
  end

  def test_open_handles_the_file_sandwich_when_given_a_block
    assert_equal 4, count_lines3('example_file.txt')
  end
end
# rubocop:enable Security/Open, Lint/AssignmentInCondition