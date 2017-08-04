class Patients::SessionsController < Devise::SessionsController
  
  layout "patients_login"

  def new

    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @cart_size = session['cart_products'].length

    super #we are extending devise so we need to invoke the user creation here

  end

end
