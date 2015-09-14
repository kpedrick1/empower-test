
class CustomFailure < Devise::FailureApp

  def redirect_url

    client = Restforce.new

    if scope == :physicians_physician

      if params[:physicians_physician] != nil && params[:physicians_physician][:username] != nil


        physician_accounts = client.query("select Id from Account where Physician_NPI_DEA__c = '#{params[:physicians_physician][:username]}'")

        physician_match = Physician.where("username = ?", params[:physicians_physician][:username])

        if physician_accounts.size > 0 && physician_match.blank?
          flash.clear
          flash[:danger] = "Please Register."
          return new_physicians_physician_registration_path

        end

      end

      return new_physicians_physician_session_path

    else

      if params[:patients_patient] != nil && params[:patients_patient][:username] != nil

        patient_accounts = client.query("select Id from Account where PersonEmail = '#{params[:patients_patient][:username]}'")

        patient_match = Patient.where("username = ?", params[:patients_patient][:username])

        if patient_accounts.size > 0 && patient_match.blank?
          flash.clear
          flash[:danger] = "Please Register."
          return new_patients_patient_registration_path

        end

      end

      return new_patients_patient_session_path
    end

  end

  def respond

    if http_auth?
      http_auth
    else
      redirect
    end
  end

end