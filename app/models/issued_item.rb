class IssuedItem < ApplicationRecord
  belongs_to :employee
  belongs_to :item
  belongs_to :admin, class_name: "User", foreign_key: 'issued_by'
  validates :issued_at,  presence: true

  # validates :issued_date, :return_date, :quantity, presence: true
  # validate :issued_date_before_return_date

  private

  def issued_date_before_return_date
    if issued_date.present? && return_date.present? && issued_date > return_date
      errors.add(:return_date, "must be after the issued date")
    end
  end
end
