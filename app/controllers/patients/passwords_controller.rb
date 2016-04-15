class Patients::PasswordsController < Devise::PasswordsController
  
  layout "login"
  
  def create


    puts "\n"
    puts "password reset called !!!!!!!!!!!!"
    puts "\n"
    
    username = params[:patients_patient][:username]
    
    client = Restforce.new
    
    if !Patient.where(:username => username).empty?
    
      result = client.get "/services/apexrest/portal/password/patient", :username => username, :businessUnit => 'PuraCap'
            
      if result.body.status
        
        password = result.body.password
        patient = Patient.where(:username => username).first
        
        patient.password = password
        patient.save
        
        flash[:notice] = "You password has been reset, please check you inbox"
        redirect_to new_patients_patient_session_path
      else
        
        flash[:danger] = "Something went wrong. Please try again"
        redirect_to new_patients_patient_password_path
        
      end
      
    else 
    
      flash[:danger] = "Entered email is incorrect. Please try again"
      redirect_to new_patients_patient_password_path
    end
    
  end  
  
end
