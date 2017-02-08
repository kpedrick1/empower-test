class Patients::FaqController < ApplicationController

  skip_before_action :require_login, only: [:index]

  layout :set_layout


  def index


  end

  end


  private


  def set_layout
    current_patients_patient ? "patients" : "patients_login"
  end