class Physicians::RegistrationsController < Devise::RegistrationsController
  
  before_filter :configure_permitted_parameters, if: :devise_controller? 

  layout :set_layout

  # check passwords match
  # check local db for email or username
  # call sf create user method and parse response should return json with error message or objects
  # create user in local database with coresponding salesforce Ids account id and portal credential id
  
  def new

    @physician_firstname = session['reg_physician_firstname']
    @physician_lastname = session['reg_physician_lastname']
    @physician_practiceZip = session['reg_physician_practiceZip']
    @physician_phone = session['reg_physician_phone']
    @physician_email = session['reg_physician_email']
    @physician_username = session['reg_physician_username']

    delete_cart_session

    super #we are extending devise so we need to invoke the user creation here
  end
  
  def create

    create_cart_session


    pass = params[:physicians_physician][:password]

    pass_conf = params[:physicians_physician][:password_confirmation]

    # check password length
    if pass.length < 8
      flash[:danger] = 'Password needs has to be at least 8 character long'
      redirect_to action: 'new'
      return
    end

    # check password upper
    if pass =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/

    else

      flash[:danger] = 'Password does not meet strength requirements'
      redirect_to :action => 'new'
      return
    end
    # check password lower

    # check password number


    if pass != pass_conf
      flash[:danger] = 'Password does not match the confirm password.'
      redirect_to action: 'new'
      return
    end


    physician_match = User.where("email = ? OR username = ?", params[:physicians_physician][:email],params[:physicians_physician][:username])

    if !physician_match.blank?
      flash[:danger] = 'The DEA / NPI  or email already exists.'
      redirect_to action: 'new'
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
      redirect_to action: 'new'
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
    #args["Promo_Code__c"] = params[:promoCode]
    args["Office_Contact__c"] = params[:officeContact]
    args["Business_Unit__c"] = ENV['BUSINESS_UNIT']

    result = client.get '/services/apexrest/portal/physician', :args => args

    result_body = result.body

    return result_body
  end
    
  
  #allowing devise to access my fields
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password, :password_confirmation, :firstname, :lastname, :agreement, :practicezip, :promoCode, :officeContact, :account_id, :portal_credential_id, :portal_credential_token
    end
  end

  protected
  def after_update_path_for(resource)
    edit_physicians_physician_path(current_physicians_physician)
  end

  def after_inactive_sign_up_path_for(resource)
    '/physicians/physicians/sign_in' # Or :prefix_to_your_route
  end

  def create_cart_session

    session['reg_physician_firstname'] = params[:physicians_physician][:firstname]
    session['reg_physician_lastname'] = params[:physicians_physician][:lastname]
    session['reg_physician_practiceZip'] = params[:physicians_physician][:practiceZip]
    session['reg_physician_promoCode'] = params[:physicians_physician][:promoCode]
    session['reg_physician_officeContact'] = params[:physicians_physician][:officeContact]
    session['reg_physician_phone'] = params[:physicians_physician][:phone]
    session['reg_physician_email'] = params[:physicians_physician][:email]
    session['reg_physician_username'] = params[:physicians_physician][:username]

  end

  def delete_cart_session

    session['reg_physician_firstname'] = nil
    session['reg_physician_lastname'] = nil
    session['reg_physician_practiceZip'] = nil
    session['reg_physician_promoCode'] = nil
    session['reg_physician_officeContact'] = nil
    session['reg_physician_phone'] = nil
    session['reg_physician_email'] = nil
    session['reg_physician_username'] = nil

  end

  private
    
    def set_layout
      
      current_physicians_physician ? "physicians" : "login"    
    end
  
end
