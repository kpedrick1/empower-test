class Patients::RegistrationsController < Devise::RegistrationsController

  require 'rest-client'

  before_filter :configure_permitted_parameters, if: :devise_controller?

  layout :set_layout


  def new

    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @cart_size = session['cart_products'].length

    super #we are extending devise so we need to invoke the user creation here
  end

  def create

    pass = params[:patients_patient][:password]

    pass_conf = params[:patients_patient][:password_confirmation]

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

    physician_match = User.where("email = ? OR username = ?", params[:patients_patient][:email],params[:patients_patient][:username])

    if !physician_match.blank?
      flash[:danger] = "The DEA / NPI  or email already exists."
      redirect_to action: "new"
      return
    end

    # result needs to return errors
    result = create_account params[:patients_patient]


    if result.success == true

      params[:patients_patient][:account_id] = result.accountId
      params[:patients_patient][:portal_credential_id] = result.credentialId
      params[:patients_patient][:portal_credential_token] = result.credentialToken

      super

      #contest_site_callout params[:patients_patient][:username], "Qualified"

    else

      flash[:danger] = result.message
      redirect_to action: "new"
    end

  end

  def create_account params

    client = Restforce.new

    params[:email] = params[:username]

    args = Hash.new
    args["FirstName"] = params[:firstname]
    args["LastName"] = params[:lastname]
    args["Email"] = params[:email]
    args["Physician_Registration__c"] = params[:myPhysician]
    args["Password__c"] = params[:password]
    args["Phone"] = params[:phone]
    args["Business_Unit__c"] = ENV['BUSINESS_UNIT']

    result = client.get "/services/apexrest/portal/patientRegistration", :args => args

    result_body = result.body

    return result_body

  end

  def update
    super


    # puts "\n"
    # puts "\n"
    #
    # puts "contest_site_callout update````````"
    #
    # puts "\n"
    # puts "\n"

    #contest_site_callout session[:username], session[:account_contest_status]

  end

  def contest_site_callout(patient_username, gic_contest_status)

    # puts "\n"
    # puts "\n"
    #
    # puts "contest_site_callout"
    #
    # puts "\n"
    # puts patient_username
    # puts "\n"

    patient_match = User.select('username', 'encrypted_password' , 'portal_credential_token').where("username = ?", patient_username).first

    # puts "\n"
    # puts patient_match.username
    # puts "\n"
    #
    # puts "\n"
    # puts patient_match.encrypted_password
    # puts "\n"
    #
    # puts "\n"
    # puts patient_match.portal_credential_token
    # puts "\n"
    #
    # puts "\n"
    # puts gic_contest_status
    # puts "\n"

    post_body = '{"application_key":"fBV4wqPZqWgAc9Rvq28t","contest_users":[{"contest_email":"' +
        patient_match.username.to_s + '","contest_guid":"' +
        patient_match.portal_credential_token.to_s + '","contest_password":"' +
        patient_match.encrypted_password.to_s + '","gic_contest_status":"' +
        gic_contest_status.to_s + '"}]}'


    puts "\n"
    puts "\n"

    puts "post_body"
    puts post_body

    puts "\n"
    puts "\n"

    puts 'CONTEST_URL'

    puts ENV['CONTEST_URL'] + '/api/users'

    puts "\n"
    puts "\n"


    begin
      gic_client = RestClient::Resource.new(ENV['CONTEST_URL'] + '/api/users', :verify_ssl => OpenSSL::SSL::VERIFY_NONE)

      response = gic_client.post post_body.to_json, :content_type => :json, :accept => :json

    rescue RestClient::ExceptionWithResponse => err
      puts err.response
    end

    if err
      puts "there was an error"
    end

    if !err
      puts "there was not an error"
    end

    puts "\n Response#code: The HTTP response code\n"
    puts response.code

    puts "\n Response#body: The response body as a string. (AKA .to_s)\n"
    puts response.body

    puts "\n Response#cookies: A hash of HTTP cookies set by the server \n"
    puts response.cookies

    puts "\n Response#headers: A hash of HTTP response headers \n"
    puts response.headers

    puts "\n Response#cookie_jar: New in 1.8 An HTTP::CookieJar of cookies \n"
    puts response.cookie_jar

    puts "\n Response#request: The RestClient::Request object used to make the request \n"
    puts response.request

    puts "\n response.to_str \n"
    puts response.to_str

    puts "\n response.to_json \n"
    puts response.to_json


    puts "\n"
    puts "\n"
    puts "\n"

  end


  #allowing devise to access my fields
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password, :password_confirmation, :firstname, :lastname, :agreement, :myPhysician, :account_id, :portal_credential_id, :portal_credential_token
    end
  end

  protected
  def after_update_path_for(resource)
    edit_patients_patient_path(current_patients_patient)
  end

  def after_inactive_sign_up_path_for(resource)
    #'/patients/patients/sign_in' # Or :prefix_to_your_route

    '/patients/products'
  end

  private

  def set_layout

    current_patients_patient ? "patients" : "patients_login"
  end



end
