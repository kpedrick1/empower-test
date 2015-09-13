class EmailconfirmationsController < ApplicationController

  skip_before_action :require_login, only: [:index]

  layout "login"

  def index

    @page_message

    result = confirm_email_salesforce params

    @type = result.accountType

     if result.success == true

       if result.accountType == 'Patient'
         flash[:notice] = "Email Confirmation Successful"
         redirect_to new_patients_patient_session_path
       else
         flash[:notice] = "Email Confirmation Successful. An email will be sent to your email after your registration is processed."
         redirect_to new_physicians_physician_session_path
       end
     else
       @page_message = "Something Went Wrong"
     end

  end

  def confirm_email_salesforce params

    client = Restforce.new

    result = client.get "/services/apexrest/portal/emailconfirmation", params

    result_body = result.body

    return result_body

  end

end