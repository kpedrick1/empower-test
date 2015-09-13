class Physicians::PatientsController < Physicians::ApplicationController

  layout "physicians"
  
  def show
    
    @patient = get_patient_salesforce
    @prescriptions = get_prescriptions_patient_salesforce @patient

    load_chart_data @patient[:Id]
  end
  
  
  def new
      
    client = Restforce.new
    @physician = client.find "Account", current_physicians_physician.username, "Physician_NPI_DEA__c" 
    load_dates_salesforce
    load_emails_salesforce
  end
  
  def index
    
    @patients = Hash.new
    search_patients_salesforce
        
  end

  def create
    
    if validate_email
      
      result = create_patient_salesforce
      
      if result.success == true
        
        patient = create_patient result
        
        if patient.save

          contest_site_callout params[:patient][:PersonEmail], "Entered"
                  
          redirect_to controller: "prescriptions", action: "new", id: patient[:id]
          return
        else
          
          flash.now[:danger] = "Something was wrong. Is the email already registered?"
        end
        
      else
        
        flash.now[:danger] = "Something was wrong. Please review"
      end
      
    else
    
      flash.now[:danger] = "This Email is already registered in the System"
    end
      
      render_new
  end
  
  
  def edit
    
    @patient = get_patient_salesforce
    load_dates_salesforce
  end
  
  
  def update
    
    if update_patient_salesforce
      
      flash[:notice] = "Patient saved!"
    else 
      
      flash[:danger] = "Something went wrong"
    end
    
    redirect_to edit_physicians_patient_path(params[:id])
    
  end
  

  
  protected
  
    def get_prescriptions_patient_salesforce patient
    
      client = Restforce.new
      
      result = client.query("SELECT Id, 

                                    Opportunity.Id,
                                    Opportunity.Name,
                                    Opportunity.CloseDate, 
                                    Opportunity.StageName,
                                    Opportunity.Status__c,

                                    Refills__c,
                                    Opportunity_Date__c ,
                                    Is_Opportunity_Prescription__c ,
                                    Days__c,
                                    Dosage__c,
                                    Dosage__r.Name,
                                    Dosage__r.Id,
                                    Dosage__r.Display_Value__c,
                                    Administration__c,
                                    Quantity,
                                    PriceBookEntry.Name

                                  FROM OpportunityLineItem
                                  WHERE Opportunity.AccountId = '#{patient[:Id]}'
                                  ORDER BY Opportunity.CloseDate DESC")
      
    end
  
    def create_patient result
      
      patient = Patient.new
      patient.email = params[:patient][:PersonEmail]
      patient.username = params[:patient][:PersonEmail]
      patient.password = result.password
      patient.account_id = result.accountId
      patient.portal_credential_id = result.credentialId
      patient.portal_credential_token = result.credentialToken

      patient
    end
  
    def render_new
      
      client = Restforce.new
      @physician = client.find "Account", current_physicians_physician.username, "Physician_NPI_DEA__c" 
      load_dates_salesforce
      render :new
    end
  
    def update_patient_salesforce
      
      patient = params[:patient]
      patient = patient.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} 
      
      client = Restforce.new
      
      client.update "Account", patient
      
    end
  

    #queries the patient
    def get_patient_salesforce
      
      patient = Patient.find(params[:id])
      
      client = Restforce.new
      
      result = client.query("SELECT Id, 
                                      Name,
                                      FirstName, 
                                      LastName,
                                      First_Name__c,
                                      Last_Name__c,
                                      PersonBirthdate,
                                      Gender__c,
                                      PersonMobilePhone,
                                      PersonHomePhone,
                                      PersonEmail,
                                      Name__c,
                                      Patient_Birthday_Year__c,
                                      Patient_Birthday_Month__c,
                                      Patient_Birthday_Day__c,
                                      Patient_Contact_Method__c,
                                      Is_Email_Bounced__c,
  
                                      BillingStreet,
                                      BillingState,
                                      BillingPostalCode, 
                                      BillingCountry, 
                                      BillingCity
                                    FROM Account
                                    WHERE PersonEmail = '#{patient[:username]}'").first        
    end  
    
    #searches for patients  
    def search_patients_salesforce

      client = Restforce.new
      account_id = session[:account_id]
      
      if params[:FirstName] || params[:LastName]
        
        first_name = params[:FirstName]
        last_name = params[:LastName]
      
        @patients = client.query("SELECT Id, First_Name__c, Last_Name__c, PersonEmail, Name__c, Is_Email_Bounced__c
                                  FROM Account 
                                  WHERE Physician__c = '#{account_id}' 
                                  AND RecordType.Name = 'Patient' 
                                  AND First_Name__c LIKE '%#{first_name}%'
                                  AND Last_Name__c LIKE '%#{last_name}%'
                                  AND Business_Unit__c = 'DyrctAxess'
                                  ORDER BY LastName")    
        
        @ids = Hash.new
                
        @patients = @patients.find_all { |p| Patient.where(:username => p.PersonEmail).first != nil}
        
        @patients.each do |pat|
          
          p = Patient.where(:username => pat.PersonEmail).first
          
          @ids["#{pat.Id}"] = Patient.where(:username => pat.PersonEmail).first.id unless !p
          
        end
        
      else 
        
      
        @patients = client.query("SELECT Id, First_Name__c, Last_Name__c, PersonEmail, Name__c, Is_Email_Bounced__c
                                  FROM Account 
                                  WHERE Physician__c = '#{account_id}' 
                                  AND RecordType.Name = 'Patient'        
                                  AND Business_Unit__c = 'DyrctAxess'
                                  ORDER BY LastName LIMIT 25")        
        
        if @patients.size > 0
        
          @ids = Hash.new
                  
          @patients = @patients.find_all { |p| Patient.where(:username => p.PersonEmail).first != nil}
          
          @patients.each do |pat|
            
            p = Patient.where(:username => pat.PersonEmail).first
            
            @ids["#{pat.Id}"] = Patient.where(:username => pat.PersonEmail).first.id unless !p
            
          end
          
        end
                      
      end
  
    
    end
    
    #sends the information to salesforce
    def create_patient_salesforce
      
      patient = params[:patient]
      patient = patient.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      patient['Business_Unit__c'] = 'DyrctAxess'

      client = Restforce.new
      
      result = client.get "/services/apexrest/portal/patient", patient

      result_body = result.body

      puts "\n"
      puts "\n"

      puts result_body

      puts "\n"
      puts "\n"

      return result_body
      
    end

    #validate the existance of the email
    def validate_email

      email = params[:patient][:PersonEmail]
      
      patients = Patient.where(:email => email)
      
      if !patients.empty?
        return false
      end

      client = Restforce.new
      patient_check = client.query("SELECT Id
                                  FROM Account
                                  WHERE PersonEmail = '#{email}'
                                  ")

      if patient_check.size > 0
        return false
      end

      return true

    end

    def load_dates_salesforce
      
      client = Restforce.new

      @months = client.picklist_values("Account", "Patient_Birthday_Month__c").map {|x| x.value}
      @days = client.picklist_values("Account", "Patient_Birthday_Day__c").map {|x| x.value}      
    end

    def load_emails_salesforce
      
      client = Restforce.new
      result = client.query("SELECT PersonEmail FROM Account WHERE RecordType.Name = 'Patient' AND Physician__c = '#{session[:account_id]}'")
      emails = result.map {|x| x.PersonEmail}
      patients = Patient.where(:email => emails)
      @emails = patients.inject({}) {|elem, k| elem[k.id] = k.email; elem }.to_json
      
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
        patient_match.encrypted_password.to_s + '","GIC_contest_status":"' +
        gic_contest_status.to_s + '"}]}'


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

    # puts "\n Response#code: The HTTP response code\n"
    # puts response.code
    #
    # puts "\n Response#body: The response body as a string. (AKA .to_s)\n"
    # puts response.body
    #
    # puts "\n Response#cookies: A hash of HTTP cookies set by the server \n"
    # puts response.cookies
    #
    # puts "\n Response#headers: A hash of HTTP response headers \n"
    # puts response.headers
    #
    # puts "\n Response#cookie_jar: New in 1.8 An HTTP::CookieJar of cookies \n"
    # puts response.cookie_jar
    #
    # puts "\n Response#request: The RestClient::Request object used to make the request \n"
    # puts response.request
    #
    # puts "\n response.to_str \n"
    # puts response.to_str
    #
    # puts "\n response.to_json \n"
    # puts response.to_json
    #
    #
    # puts "\n"
    # puts "\n"
    # puts "\n"

  end

end
