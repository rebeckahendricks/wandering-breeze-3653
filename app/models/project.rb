class Project < ApplicationRecord
  validates_presence_of :name, :material
  belongs_to :challenge

  has_many :contestant_projects
  has_many :contestants, through: :contestant_projects

  def contestant_count
    contestants.count
  end

  def total_contestant_experience
    contestants.sum do |contestant|
      contestant.years_of_experience
    end
  end

  def avg_contestant_experience
    total_contestant_experience.to_f / contestant_count
  end
end
