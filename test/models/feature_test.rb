# == Schema Information
#
# Table name: features
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  icon        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#  field_id    :integer
#  level       :integer
#

require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
end
