class Patients::MailingsController < Patients::ApplicationController
  
  layout "patients"

  def new 

    client = Restforce.new
    @physician = get_patients_salesforce client
    init
    
  end
  
  def create
    
    caseObject = params[:case]
    caseObject[:SuppliedName] = params[:firstname] + ' ' + params[:lastname]    
    caseObject = caseObject.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} 

    client = Restforce.new
    
    if client.insert "Case", caseObject    
      flash[:success] = "Message Sent!"
    else 
      flash[:error] = "An Error has occurred. Try again in a few minutes"
    end    
    
    redirect_to new_patients_mailing_path
    
  end

protected

  def get_patients_salesforce client
    client.find "Account", session[:account_id]
  end
  
  def init 
      @firstname = session[:account_first_name]
      @lastname = session[:account_last_name]
      @email = session[:account_email]
  end  


end
