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

  validate :ref_date_valid_date?, if: 'ref_date.present?'
  validates :latitude, :longitude, numericality: true, if: 'latitude.present?'
  validates :title, presence: true
  validates :description, presence: true, if: :should_require_description?

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
    def should_require_description?
      # Thorough testing for this!
      medium.respond_to?(:text)
    end

    def ref_date_valid_date?
      # Check the date is a valid date
      errors.add(:ref_date, 'must be a valid date') unless (Date.parse(self.ref_date.to_s) rescue false)
    end
end
