# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
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
#  profesor               :boolean          default(FALSE)
#  diploma_year           :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :projects, :join_table => :users_projects
  #has_many :features, through: :projects

  validates :email, presence: true

  before_create :set_as_admin_if_first

  include Gravtastic
  gravtastic size: 100

  #delegate :has_feature?, to: :projects

  default_scope { order('last_name, first_name') }


# Méthode de recherche des utilisateurs, à partir de son nom, prénom ou mail
  def self.search(search)
    if search
      where("lower(first_name) LIKE lower('%#{search}%') OR lower(last_name) LIKE lower('%#{search}%') OR lower(email) LIKE lower('%#{search}%')")
    else
      all
    end
  end

  def to_s
    if first_name.nil? or last_name.nil?
      "#{email}"
    else
      "#{first_name} #{last_name}"
    end
  end

  def name_for_associated_inuts
    if first_name.nil? or last_name.nil?
      "#{email}"
    else
      "#{first_name} #{last_name} (#{email})"
    end
  end

  private

    def set_as_admin_if_first
      self.admin = true unless User.any?
    end
end