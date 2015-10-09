class Patients::PatientsController < Patients::ApplicationController
  
  layout "patients"
  
  def show
    redirect_to action: "edit"
  end
  
  def edit
    
    client = Restforce.new  
    @patient = client.find "Account", session[:account_id]
    @years = client.picklist_values "Account", "Patient_Credit_Card_Expiration_Year__c"
    @years = @years.map {|x| x.value}
    @months = client.picklist_values "Account", "Patient_Credit_Card_Expiration_Month__c"
    @months = @months.map {|x| x.value}
    
    @timezones = client.picklist_values "Account", "Timezone__c"
    @timezones = @timezones.map {|x| x.value}
    
  end
  
  def update

    patient = params[:patient]
    
    client = Restforce.new

    p = Patient.find(current_patients_patient[:id])

    result = client.query("SELECT Id FROM Account WHERE PersonEmail = '#{params[:patient][:PersonEmail].downcase}'")

    if result.size == 0 || p[:email].downcase == params[:patient][:PersonEmail].downcase
      
      if params[:patient][:Billing_As_Shipping__c] == nil
          params[:patient][:Billing_As_Shipping__c] = "false"
      end
      
      if client.update "Account", patient

        p[:username] = params[:patient][:PersonEmail]
        p[:email] = params[:patient][:PersonEmail]
        
        if p.save
          
          flash.now[:notice] = "Settings saved!"
          
        else 
          
          flash.now[:danger] = "Something went wrong. Please review data"
        end
      
      else
        
        flash.now[:danger] = "Something went wrong. Please review data"  
      end

    else
      flash[:danger] = "The Email already exists"

    end

    redirect_to action: "edit"
    
  end
  
  def validate_credit_card patient
    
    if (patient[:Patient_Credit_Card_Number__c].length != 0)
      
      result = patient[:Patient_Credit_Card_Expiration_Year__c].length != 0
      result = result && patient[:Patient_Credit_Card_Expiration_Month__c].length != 0
      result = result && patient[:Patient_Credit_Card_Security_Number__c].length != 0
              
      if result
        true
      else
        false
      end
    else 
      true
    end
    
  end
  
end
