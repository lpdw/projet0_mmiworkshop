# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  name       :string
#  color      :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon       :string
#  parent_id  :integer
#

require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
