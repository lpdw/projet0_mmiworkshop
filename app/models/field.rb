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

class Field < ActiveRecord::Base
  has_many :features
  belongs_to :parent, class_name: 'Field'
  has_many :children, class_name: 'Field', foreign_key: :parent_id

  default_scope { order('parent_id, position') }

  validates :name, presence: true
  validates :position, presence: true

  def child_features
    children.map { |f| f.features }.flatten.uniq
  end

  def smart_color
    color.empty? ? parent.color : color
  end

  def all_features
    (features + child_features).uniq
  end

  def ancestors
    result = ''
    result += parent.ancestors unless parent.nil?
    result += "#{name} / "
    result
  end


  def to_s
    "#{name}"
  end
end
