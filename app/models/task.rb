class Task < ApplicationRecord
  validates :name, presence: true, uniqueness: {scope: :user_id} , length: { maximum: 30}
  validates :description, length: { maximum: 140}
  validate :validate_name_not_including_comma

  belongs_to :user

  private
    def validate_name_not_including_comma
      errors.add(:name, "にカンマを含めることはできません") if name&.include?(",")
    end
end
