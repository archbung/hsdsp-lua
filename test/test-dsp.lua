local dsp = require 'dsp'
local tasty = require 'tasty'

local group = tasty.test_group
local test = tasty.test_case
local assert = tasty.assert

return {
  group 'conv1d' {
    test('one', function ()
      tasty.assert.are_equal(dsp.conv1d({1,2,3,4},{1}), {1,2,3,4})
    end)
  }
}
