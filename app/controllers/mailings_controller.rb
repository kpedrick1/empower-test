class MailingsController < ApplicationController

  layout "login"
  
  def new 

    client = Restforce.new
    init
    
  end
  
  def create
    
    caseObject = params[:case]
    caseObject[:SuppliedName] = params[:firstname] + ' ' + params[:lastname]    
    caseObject = caseObject.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} 

    client = Restforce.new
    
    if client.insert "Case", caseObject    
      flash[:success] = "Message Sent!"
    else 
      flash[:error] = "An Error has occurred. Try again in a few minutes"
    end    
    
    render :new
    
  end

protected
  
  def init 
      @firstname = ""
      @lastname = ""
      @email = ""
  end  


  
  
  
end
