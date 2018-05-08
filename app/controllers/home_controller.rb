class HomeController < ApplicationController

  layout "home"

  def index
    redirect_to '/shop/products'
  end

  def download_pdf

    if physicians_physician_signed_in?

      send_file(
          "#{Rails.root}/public/EPICERAM_L_ORDER_FORM_REV.pdf",
          filename: "EPICERAM_L_ORDER_FORM_REV.pdf",
          type: "application/pdf"
      )
    else
      redirect_to '/physicians/physicians/sign_in'
      return
    end

  end

end
