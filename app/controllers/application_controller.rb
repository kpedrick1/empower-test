class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)

    set_session_values resource

    if resource.kind_of? Patient
      patients_checkout_path

    else
      physicians_orders_path
    end
  end


  def set_session_values resource

    username = resource.username

    result = 'Physician'

    if resource.kind_of? Patient
      result = 'Patient'
    end

    client = Restforce.new

    logger.debug result
    logger.debug username

    # Account__r.Virtual_Pharmacy__c,
    credential = client.query("SELECT Id,
                                      Account__c,
                                      Account__r.Name,
                                      Account__r.PersonContactId,
                                      Account__r.FirstName,
                                      Account__r.LastName,
                                      Account__r.GIC_Contest_Status__c,
                                      Account__r.PersonEmail
                                  FROM Portal_Credential__c 
                                  WHERE Username__c = '#{username}'
                                  AND Account_Type__c = '#{result}'").first

    if credential
      session[:account_id] = credential.Account__c
      session[:account_name] = credential.Account__r.Name
      session[:contact_id] = credential.Account__r.PersonContactId
      session[:account_first_name] = credential.Account__r.FirstName
      session[:account_last_name] = credential.Account__r.LastName
      session[:account_email] = credential.Account__r.PersonEmail
      session[:account_contest_status] = credential.Account__r.GIC_Contest_Status__c
      session[:username] = username
      # session[:Virtual_Pharmacy] = credential.Account__r.Virtual_Pharmacy__c
      session[:account_type] = result
    end

  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource)
    #root_path
    '/patients/products'
  end

end
