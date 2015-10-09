class Patients::PrescriptionsController < Patients::ApplicationController

  layout "patients"
  
  def index

    @prescriptions = Hash.new

    @prescriptions = search_prescriptions_salesforce

    if @prescriptions.size == 0
      flash[:danger] = 'Your search returned no results.'
    end
    
    get_readings_salesforce

    @selectedDrug
    @selectedDosage
    @selectedDate


    if params[:drug] && params[:drug] != ''
      @selectedDrug = params[:drug]
    end

    if params[:dosage] && params[:dosage] != ''
      @selectedDosage =params[:dosage]
    end

    if params[:date] && params[:date] != ''
      @selectedDate = params[:date]
    end
    
  end
  
  
  def search_prescriptions_salesforce

    
    account_id = session[:account_id]
    query = "SELECT Id, 

                    Opportunity.Id,
                    Opportunity.Name,
                    Opportunity.CloseDate, 
                    Opportunity.StageName,
                    Opportunity.Status__c,

                    Refills__c  ,
                    Opportunity_Date__c ,
                    Is_Opportunity_Prescription__c ,
                    Days__c ,
                    Administration__c,
                    Quantity,
                    Dosage__r.Display_Value__c,
                    Dosage_Value__c,
                    PricebookEntry.Name

                FROM OpportunityLineItem
                WHERE Opportunity.AccountId = '#{account_id}'"
                
    if params[:drug] && params[:drug] != ''
      @drugValue = params[:drug]
      query += " AND PricebookEntry.Name LIKE '%#{params[:drug]}%'"
    end
    
    if params[:dosage] && params[:dosage] != ''
      query += " AND Dosage__r.Display_Value__c = '#{params[:dosage]}'"
    end

    if params[:date] && params[:date] != ''
      query += " AND Opportunity_Date__c = '#{params[:date]}'"
    end    

    query += " ORDER BY Opportunity.CloseDate DESC"

    
    client = Restforce.new
    result = client.query(query)        

    return result

  end
  

  def get_readings_salesforce
    
    account_id = session[:account_id]
    client = Restforce.new
    
    drugs = client.query("SELECT Id, Product2.Name FROM PricebookEntry WHERE IsActive = true AND Pricebook2.Name = 'DyrctAxess' ")
    @drugs = drugs.map {|x| x.Product2.Name}.uniq
    
    dates = client.query("SELECT Id, Opportunity_Date__c FROM OpportunityLineItem 
                            WHERE Opportunity.AccountId = '#{account_id}'")
    
    @dates = dates.map {|x| x.Opportunity_Date__c}.uniq

    dosages = client.query("SELECT Id, Display_Value__c FROM Dosage__c")
    @dosages = dosages.map {|x| x.Display_Value__c}.uniq    
    
  end
  
  
end
