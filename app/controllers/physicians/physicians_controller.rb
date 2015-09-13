class Physicians::PhysiciansController < Physicians::ApplicationController

  layout "physicians"

  
  def edit
    
    client = Restforce.new
    
    @physician = get_physician_salesforce client

    @timezones = client.picklist_values "Account", "Timezone__c"
    @timezones = @timezones.map {|x| x.value}
    
  end
  
  def update
    
    if update_physician_salesforce 
      flash[:notice] = "Settings saved!"
    else
      flash[:error] = "Invalid input. Please review your data"
    end
    
    redirect_to action: "edit"
      
  end
  
  protected
    
    def get_physician_salesforce client
      
      
      client.find "Account", session[:account_id]
    end

    def update_physician_salesforce
      
      physician = params[:physician]

      physician = physician.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

      # if physician[:Virtual_Pharmacy__c]
      #   physician[:Virtual_Pharmacy__c] = true
      # elsif
      #   physician[:Virtual_Pharmacy__c] = false
      # end
      #
      # session[:Virtual_Pharmacy] = physician[:Virtual_Pharmacy__c]

      
      client = Restforce.new
      client.update "Account", physician

    end
    
end
