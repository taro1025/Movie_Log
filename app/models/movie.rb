class Movie < ApplicationRecord
  validates :title,{presence: true, length: {maximum: 40}}
end
