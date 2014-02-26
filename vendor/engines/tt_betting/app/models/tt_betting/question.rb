module TtBetting
  class Question < ActiveRecord::Base
    attr_protected
    has_many :choices
    has_many :answers
    accepts_nested_attributes_for :choices
    has_one :choice
    validates :name, :time_to_expire, :score, presence: true
    validates :score, :format => { :with => /^(\d+)(\.)?\d{0,2}$/ }, :numericality => {:greater_than => 0}

    validate :time_to_expire_greater_than_current

    def time_to_expire_greater_than_current
      if time_to_expire && DateTime.now > time_to_expire
        errors.add(:time_to_expire, "should be greater than current")
      end
    end
  end
end
