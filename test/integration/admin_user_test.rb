require File.join(File.dirname(__FILE__), '..', 'test_helper')

class AdminUserTest < ActionController::IntegrationTest
  context 'An administrator' do
    setup do
      @event = Factory(:event)
      stub(Contribution).dummy.stub!.first.stub!.updated_at {Time.now}
      sign_user_in
    end

    should 'be able to sign in' do
      assert_contain 'You are now signed in.'
      assert_equal root_path, path
    end

    should 'be able to sign out' do
      click_link 'leave'
      assert_contain 'You have signed out.'
      assert_equal root_path, path
    end

    should 'be able to adjust a Participants score' do
      participant = Factory(:participant, :event => @event)
      assert_equal 0, participant.score

      visit edit_participant_path(participant)
      fill_in 'Score', :with => '100'
      click_button 'Update'
      assert_equal participant_path(participant), path

      participant.reload
      assert_equal 100, participant.score
    end

    context '' do
      should 'be able to create a new Event' do
        visit new_event_path

        fill_in 'Name', :with => 'Another Bug Mash'
        check 'Current'
        click_button 'Create'
        assert_equal events_path, path
      end

      should 'be able to edit existing Event' do
        visit edit_event_path(@event)

        fill_in 'Name', :with => 'Changed'
        click_button 'Update'

        @event.reload
        assert_equal 'Changed', @event.name
        assert_equal events_path, path
      end
    end

    context 'working with issues' do
      setup { @issue = Factory(:issue)  }

      should 'be able to mark an Issue as fixed' do
        visit edit_issue_path(@issue)
        check 'issue_fixed'
        click_button 'Send'
        assert_path issues_path
        @issue.reload
        assert @issue.fixed?
      end
    end

    context 'working with Contributions' do
      setup { @participant = Factory(:participant) }

      should 'be able to create a new one' do
        visit new_contribution_path
        fill_in 'Lighthouse ID', :with => '2000'
        fill_in 'Point Value', :with => '100'
        select 'John McClane', :from => 'Participant'
        click_button 'Update'
        assert_contain 'Contribution created.'
        assert_path contributions_path
      end

      should 'be able to update existing contribution' do
        contribution = @participant.contributions.create(:lighthouse_id => 2000, :point_value => 25)

        visit edit_contribution_path(contribution)
        fill_in 'Point Value', :with => '100'
        click_button 'Update'
        assert_contain 'Contribution updated.'
        assert_path contributions_path
      end

      should 'be able to see the list of contributions' do
        contribution = @participant.contributions.create(:lighthouse_id => 2000, :point_value => 25)

        visit contributions_path
        assert_have_selector :a, :href => participant_path(@participant)
        assert_have_selector :a, :href => edit_contribution_path(contribution)
      end
    end
  end
end
