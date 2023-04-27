class Member < ApplicationRecord
  belongs_to :team

  has_many :project_members, dependent: :nullify
  has_many :projects, through: :project_members, dependent: :nullify
end
