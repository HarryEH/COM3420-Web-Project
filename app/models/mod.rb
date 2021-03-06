# == Schema Information
#
# Table name: mods
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  isActive               :boolean
#  isAdmin                :boolean
#
# Indexes
#
#  index_mods_on_email                 (email) UNIQUE
#  index_mods_on_reset_password_token  (reset_password_token) UNIQUE
#

class Mod < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # This method means newly registered mods cannot log in
  def active_for_authentication?
    super && isActive?
  end

  def inactive_message
    if !isActive?
      :not_approved
    else
      super # Use whatever other message
    end
  end

end
