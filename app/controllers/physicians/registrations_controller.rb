class Physicians::RegistrationsController < Devise::RegistrationsController
  
  before_filter :configure_permitted_parameters, if: :devise_controller? 

  layout :set_layout

  # check passwords match
  # check local db for email or username
  # call sf create user method and parse response should return json with error message or objects
  # create user in local database with coresponding salesforce Ids account id and portal credential id
  
  def new
    super #we are extending devise so we need to invoke the user creation here
  end
  
  def create    
    
    pass = params[:physicians_physician][:password]

    pass_conf = params[:physicians_physician][:password_confirmation]


    if pass.length < 8
      flash[:danger] = "Password needs has to be at least 8 character long"
      redirect_to action: "new"
      return
    end

    if pass != pass_conf
      flash[:danger] = "Password does not match the confirm password."
      redirect_to action: "new"
      return
    end

    physician_match = User.where("email = ? OR username = ?", params[:physicians_physician][:email],params[:physicians_physician][:username])

    if !physician_match.blank?
      flash[:danger] = "The DEA / NPI  or email already exists."
      redirect_to action: "new"
      return
    end

    # result needs to return errors
    result = create_account params[:physicians_physician]

    if result.success == true

      params[:physicians_physician][:account_id] = result.accountId
      params[:physicians_physician][:portal_credential_id] = result.credentialId
      params[:physicians_physician][:portal_credential_token] = result.credentialToken

      super
    else

      flash[:danger] = result.message
      redirect_to action: "new"
    end

  end
  
  def create_account params
    
    client = Restforce.new

    args = Hash.new
    args["FirstName"] = params[:firstname]
    args["LastName"] = params[:lastname]
    args["Email"] = params[:email]
    args["Physician_NPI_DEA__c"] = params[:username]
    args["Password__c"] = params[:password]
    args["Phone"] = params[:phone]
    args["practiceZip"] = params[:practiceZip]

    result = client.get "/services/apexrest/portal/physician", :args => args

    result_body = result.body

    return result_body
  end
    
  
  #allowing devise to access my fields
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password, :password_confirmation, :firstname, :lastname, :agreement, :practicezip, :account_id, :portal_credential_id, :portal_credential_token
    end
  end

  protected
  def after_update_path_for(resource)
    edit_physicians_physician_path(current_physicians_physician)
  end

  def after_inactive_sign_up_path_for(resource)
    '/physicians/physicians/sign_in' # Or :prefix_to_your_route
  end

  private
    
    def set_layout
      
      current_physicians_physician ? "physicians" : "login"    
    end
  
end
