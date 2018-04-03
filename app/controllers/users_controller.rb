class UsersController < ApplicationController

  def index
  	@users = User.all
  	@user = User.find_by_id(params[:id])           
  end

  def new
  	@user = User.new
  end

   def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri.to_s
  end

    def callback
     client = Signet::OAuth2::Client.new(client_options)
         client.code = params[:code]
         response = client.fetch_access_token!

         session[:authorization] = response
         session[:authorization][:code] = params[:code]
          redirect_to '/users'
  end

  def calendars
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    @calendar_list = service.list_calendar_lists
end


  def events
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    @event_list = service.list_events(params[:calendar_id])
end


 def new_event
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    today = Date.today
    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: today + 1),
      summary: 'New event!'
    })

    service.insert_event(params[:calendar_id], event)
    redirect_to events_url(calendar_id: params[:calendar_id])
end

  def create
  	user = User.new(user_params)
  	if user.save
  		flash[:message] = 'user created ok'
  		redirect_to '/users'
  	else
  		flash[:message] = 'try again'
  		redirect_to users_new_path
  	end
  end

  def show
  	    
  end
      def refreshToken
        client = Signet::OAuth2::Client.new(client_options)
        client.update!(session[:authorization])    
        client.update!(:additional_parameters => {"access_type" => "offline"})
        rescue Google::Apis::AuthorizationError
        response = client.refresh!
        session[:authorization] = session[:authorization].merge(response)
        retry    
    end    
    
    def tokenRefresh
        client = Signet::OAuth2::Client.new(client_options)
        client.update!(session[:authorization])    
        client.update!(:additional_parameters => {"access_type" => "offline"})
        rescue Google::Apis::AuthorizationError
            response = client.refresh!
            session[:authorization] = session[:authorization].merge(response)
        retry
    end  


  private
  def user_params
  	params.require(:user).permit(:username, :email, :password)
  end

  def client_options
    {
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: 'http://localhost:3000/callback',
    }
  end

end