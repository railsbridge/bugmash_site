require File.join(File.dirname(__FILE__), '..', 'test_helper')

class EventTest < ActiveSupport::TestCase
  should_validate_presence_of :name
  should_have_many :participants

  context '#current' do
    setup do
      @current = Factory(:event)
      Factory(:event, :current => false)
    end

    should 'return the current Event' do
      assert_equal @current, Event.current
    end
  end

    context '.participants.find_or_create' do
    setup do
      @event =  Factory(:event)
      @participant = Factory(:participant, :lighthouse_id => 'cowboy',
                                           :github_id => 'baldie',
                                           :event => @event)
      assert_equal 1, Participant.count
    end

    should 'find the participant by #name' do
      @event.participants.find_or_create('John McClane')
      assert_equal @participant, @event.participants.last
    end

    should 'find the participant by #lighthouse_id' do
      @event.participants.find_or_create('cowboy')
      assert_equal @participant, @event.participants.last
    end

    should 'find the participant by #github_id' do
      @event.participants.find_or_create('baldie')
      assert_equal @participant, @event.participants.last
    end

    should 'create new participant if not found' do
      @bruce = @event.participants.find_or_create('Bruce Dickenson')
      assert_equal 2, Participant.count
      assert_equal @bruce, @event.participants.last
    end
  end
end
