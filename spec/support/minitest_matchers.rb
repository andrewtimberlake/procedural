require 'minitest/spec'

module MiniTest::Expectations
  infect_an_assertion :assert_equal, :to_equal
  infect_an_assertion :assert_match, :to_match
  infect_an_assertion :assert_raises, :to_raise, :block
end
