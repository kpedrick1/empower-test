class Physicians::PasswordsController < Devise::PasswordsController
  
  layout "login"
  
  def create
    
    username = params[:physicians_physician][:username]
    
    client = Restforce.new
    
    if !Physician.where(:username => username).empty?
    
      result = client.get "/services/apexrest/portal/password/physician", :username => username, :Business_Unit__c => ENV['BUSINESS_UNIT']
      
      if result.body.status
        
        password = result.body.password
        physician = Physician.where(:username => username).first
        
        physician.password = password
        physician.save
        
        flash[:notice] = "You password has been reset, please check you inbox"
        redirect_to new_physicians_physician_session_path
      else
        
        flash[:danger] = "Something went wrong. Please try again"
        redirect_to new_physicians_physician_password_path
        
      end
      
    else 
    
      flash[:danger] = "The NPI / DEA is incorrect. Please try again"
      redirect_to new_physicians_physician_password_path
    end
    
  end
  
end
