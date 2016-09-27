# == Schema Information
#
# Table name: workshops
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class WorkshopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
