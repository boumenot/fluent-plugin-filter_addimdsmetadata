$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "fluent/plugin/filter_imds"
require "minitest/autorun"
require "test-unit"
require "fluent/test"
require "fluent/test/driver/output"
require "fluent/test/helpers"

Test::Unit::TestCase.include(Fluent::Test::Helpers)
Test::Unit::TestCase.extend(Fluent::Test::Helpers)
