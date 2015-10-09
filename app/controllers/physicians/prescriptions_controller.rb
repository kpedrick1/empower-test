class Physicians::PrescriptionsController < Physicians::ApplicationController

  layout "physicians"
    
  def new
    
    new_salesforce
    
  end
  
  def create
    
    if params[:has_prescriptions] == "true"
      
      if create_salesforce
        
        flash[:notice] = "Prescriptions Saved!"
        redirect_to physicians_patient_path(params[:id]) #controller: "patients", action: "show", id: params[:id]
        return
      
      else
        
        flash[:error] = "There was an error processing the prescriptions"
      end
      
    else
      
      flash[:error] = "You need to select at least one prescription"
    end
        
    render :new
    
  end
  
  def index
  
    get_readings_salesforce
    @prescriptions = get_prescriptions_salesforce
  
  end  
  
  protected
  
  
    def get_prescriptions_salesforce
      
      account_id = session[:account_id]
      
      client = Restforce.new

      query = "SELECT Id, 

                  Opportunity.Id,
                  Opportunity.Name,
                  Opportunity.CloseDate, 
                  Opportunity.StageName,
                  Opportunity.Status__c,
                  Opportunity.Account.First_Name__c,
                  Opportunity.Account.Last_Name__c,
                  Refills__c,
                  Opportunity_Date__c ,
                  Is_Opportunity_Prescription__c,
                  Days__c,
                  Dosage__c,
                  Dosage__r.Name,
                  Dosage__r.Id,
                  Dosage__r.Display_Value__c,
                  Administration__c,
                  Quantity,
                  PriceBookEntry.Name

                FROM OpportunityLineItem
                WHERE Opportunity.Account.Physician__c = '#{account_id}'"
      
      if params[:date] != "" && params[:date] != nil
        query += " AND Opportunity_Date__c = '#{params[:date]}'"
      end
      
      if params[:drug] != "" && params[:drug] != nil
        query += " AND PricebookEntry.Name = '#{params[:drug]}'"
      end

      if params[:name] != "" && params[:name] != nil
        query += " AND Patient_Name__c LIKE '%#{params[:name]}%'"
      end

      if params[:status] != "" && params[:status] != nil
        query += " AND Opportunity.Status__c = '#{params[:status]}'"
      end
      
      query += " AND Opportunity.Account.Business_Unit__c = 'DyrctAxess' ORDER BY CreatedDate DESC"    

      client.query(query)
      
    end
  
    def create_salesforce
          
      drugs = params[:drug]
      drugs = drugs.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} 
      drugs = drugs.map { |x| x }
      drugs = drugs.select {|x| x[1][:selected]}
      drugs = drugs.map {|x| x[1]}
      
      
      client = Restforce.new
            
      result = client.get("/services/apexrest/portal/prescription/", content: drugs.to_json, patient: params[:PatientId])
      result.body.status
      
    end
      
    
    def new_salesforce
      
      client = Restforce.new
      
      @drugs = get_product_dosages_salesforce client
            
      @patient = get_patient_data_salesforce client 
      
      
    end
      
  
    def get_product_dosages_salesforce client
      
      entries = client.query("SELECT 
                                  Name, 
                                  Id,
                                  Product2Id,
                                  IsActive, 
                                  ProductCode,
                                  Pricebook2.Name     
                                FROM PricebookEntry
                                WHERE IsActive = true
                                AND Pricebook2.Name = 'DyrctAxess'") 
      
      productIds = entries.map {|x| x.Product2Id}.join("','")
      productIds = "'#{productIds}'" 
      
      result = client.query("SELECT Id, 
                                    Name,
                                    Administration__c,
                                    Days__c,
                                    Form__c,
                                    Refills__c,
                                      (SELECT
                                          Id,
                                          Name, 
                                          Value__c, 
                                          Unit__c, 
                                          Display_Value__c,
                                          Product__r.Administration__c, 
                                          Product__r.Days__c, 
                                          Product__r.Form__c, 
                                          Product__r.Refills__c 
                                        FROM Dosages__r)
                                    FROM Product2
                                    WHERE IsActive = true
                                    AND Id IN (#{productIds})
                                    ORDER BY Name")
      
      return result
      
    end
    
    def get_patient_data_salesforce client
      
      patient = Patient.find(params[:id])
            
      result = client.query("SELECT Id, 
                                      Name,
                                      First_Name__c,
                                      Last_Name__c,
                                      Name__c,
                                      PersonBirthdate,
                                      PersonHomePhone,
                                      PersonMobilePhone
                                    FROM Account
                                    WHERE PersonEmail = '#{patient.username}'").first        
    end
  

    def get_readings_salesforce
      
      account_id = session[:account_id]
      client = Restforce.new
      
      drugs = client.query("SELECT 
                              Name, 
                              Id,
                              Product2Id,
                              Product2.Name,
                              IsActive, 
                              ProductCode,
                              Pricebook2.Name
                            FROM PricebookEntry
                            WHERE IsActive = true
                            AND Pricebook2.Name = 'DyrctAxess'")       
      
      @drugs = drugs.map {|x| x.Product2.Name}.uniq
      
      dates = client.query("SELECT Id, Opportunity_Date__c FROM OpportunityLineItem 
                              WHERE Opportunity.Account.Physician__c = '#{account_id}'
                              ORDER BY Opportunity_Date__c")
      
      @dates = dates.map {|x| x.Opportunity_Date__c}.uniq

      @statuses = client.picklist_values('Opportunity', 'Status__c') 
      @statuses = @statuses.map {|x| x.value}
      
      @days = client.picklist_values('OpportunityLineItem', 'Days__c') 
      @days = @days.map {|x| x.value}
      
      @administration = client.picklist_values('OpportunityLineItem', 'Administration__c') 
      @administration = @administration.map {|x| x.value}      
      
      @refills = client.picklist_values('OpportunityLineItem', 'Refills__c') 
      @refills = @refills.map {|x| x.value}
      
    end

end
