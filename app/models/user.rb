# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  project_id             :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  admin                  :boolean          default(FALSE)
#  diploma_year           :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :project
  has_many :features, through: :project

  validates :email, presence: true

  before_create :set_as_admin_if_first

  include Gravtastic
  gravtastic size: 100

  delegate :has_feature?, to: :project

  default_scope { order('last_name, first_name') }

  def to_s
    if first_name.nil? or last_name.nil?
      "#{email}"
    else
      "#{first_name} #{last_name}"
    end
  end



  private

    def set_as_admin_if_first
      self.admin = true unless User.any?
    end
end
