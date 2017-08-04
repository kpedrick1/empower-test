class Patients::TermsController < ApplicationController

  skip_before_action :require_login, only: [:index]

  layout :set_layout

  def index

    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @cart_size = session['cart_products'].length

  end

  private

  def set_layout
    current_patients_patient ? "patients" : "patients_login"
  end

end