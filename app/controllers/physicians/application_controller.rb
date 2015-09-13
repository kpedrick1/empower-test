class Physicians::ApplicationController <  ActionController::Base
  
  before_filter :authenticate_physicians_physician!
  
  #method to load chart information
  def load_chart_data account_id
    
    client = Restforce.new
    data_response = client.get "/services/apexrest/hvs/logs/#{account_id}"
  
    @systolic = data_response.body.systolic
    @diastolic = data_response.body.diastolic
  end    
  
end
