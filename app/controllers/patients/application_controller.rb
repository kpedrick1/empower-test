class Patients::ApplicationController < ActionController::Base
    
  before_filter :authenticate_patients_patient!


end
