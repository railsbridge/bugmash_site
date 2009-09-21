class Participant < ActiveRecord::Base
  has_many :contributions
  belongs_to :event
  validates_presence_of :name

  named_scope :top_scorers, :order => 'score DESC'
end
