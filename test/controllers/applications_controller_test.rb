require 'test_helper'

class ApplicationsControllerTest < ActionController::TestCase
  def make_event
    Event.create!(
      name: 'Event',
      start_date: '2015-12-20',
      end_date: '2015-12-22',
      description: 'Sed ut perspiciatis unde omnis.',
      organizer_name: 'Klaus Mustermann',
      organizer_email: 'klaus@example.com',
      organizer_email_confirmation: 'klaus@example.com',
      website: 'google.com',
      code_of_conduct: 'coc.website',
      city: 'Berlin',
      country: 'Germany',
      deadline: '2015-12-01',
      number_of_tickets: 10
    )
  end

  def make_application(event)
    Application.create!(
      name: 'Joe',
      email: 'joe@test.com',
      email_confirmation: 'joe@test.com',
      event: event,
      answer_1: 'Hi',
      answer_2: 'Hi',
      answer_3: 'Hi'
    )
  end

  # GET show
  test 'shows application to admin users' do
    admin_login

    event = make_event
    application = make_application(event)

    get :show, event_id: event.id, id: application.id

    assert_response :success
  end

  test 'does not show application to non-admin users' do
    event = make_event
    application = make_application(event)

    get :show, event_id: event.id, id: application.id

    assert_response 401
  end

  test 'raise exception if application does not exist' do
    admin_login

    event = make_event

    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, event_id: event.id, id: 1
    end
  end

  # POST create
  test 'proper redirection after successful application' do
      event = make_event

      post :create, event_id: event.id,
                    application: {
                      name: 'Joe',
                      email: 'joe@test.com',
                      email_confirmation: 'joe@test.com',
                      event: event,
                      answer_1: 'Hi',
                      answer_2: 'Hi',
                      answer_3: 'Hi'
                    }

      assert_redirected_to event
  end

  test 'no redirection after failed validations' do
    event = make_event

    post :create, event_id: event.id,
                  application: {
                    name: 'Joe'
                  }

    assert_response :success
  end
end
