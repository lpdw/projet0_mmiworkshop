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
#  dateDebut  :datetime         not null
#  dateFin  :datetime         not null


class Workshop < ActiveRecord::Base
  has_many :projects

  validates :name, presence: true

  def to_s
  	"#{name}"
  end
end
