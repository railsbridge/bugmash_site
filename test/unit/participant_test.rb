require File.join(File.dirname(__FILE__), '..', 'test_helper')

class ParticipantTest < ActiveSupport::TestCase
  should_have_db_indices [:name, :lighthouse_id], :active, :event_id
  should_validate_presence_of :name
  should_have_many :contributions
  should_have_named_scope :top_scorers
  should_belong_to :event
end
