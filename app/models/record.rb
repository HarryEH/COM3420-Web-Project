# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  location    :string
#  ref_date    :date
#  approved    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  medium_id   :integer
#  latitude    :float
#  longitude   :float
#
# Indexes
#
#  index_records_on_medium_id  (medium_id)
#

require 'auto_strip_attributes'

class Record < ActiveRecord::Base
  belongs_to :medium

  auto_strip_attributes :title, :description, :location, :squish => true

  validates :latitude, :longitude, numericality: {allow_blank: true}
  validates :title, presence: true
  validates :description, presence: true, unless: :medium_is_text?

  def to_s
    self.created_at.to_formatted_s(:long)
  end

  def to_s_mod
    if self.approved
      self.created_at.to_formatted_s(:long) + ' (Approved)'
    else
      self.created_at.to_formatted_s(:long) + ' (Unapproved)'
    end
  end

  private
    def medium_is_text?
      # Thorough testing for this!
      self.medium.is_a?(Text)
    end
end
