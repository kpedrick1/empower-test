class Patients::ProductsController < ApplicationController

  skip_before_action :require_login, only: [:index]

  layout :set_layout

  def index

    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @cart_size = session['cart_products'].length

    get_products

  end


  def get_products

    client = Restforce.new

    result = client.get '/services/apexrest/portal/pricebook/', :business_unit => ENV['BUSINESS_UNIT']

    # todo: handle error response


    puts "get pricebook body \n\n"

    puts result.body

    puts "\n"

    puts "get pricebook body productList \n\n"

    puts result.body.productList

    puts "\n"

    @price_book = result.body.productList



  end

  def add_to_cart

    # add product id to cart

    puts "\n\n params \n\n"
    puts params

    puts "\n\n params[:product_id] \n\n"
    puts params[:product_id]

    # check if hash has key

    if session['cart_products'].key?(params[:product_id])

      session['cart_products'][params[:product_id]] = session['cart_products'][params[:product_id]].to_i + 1
    else
      session['cart_products'][params[:product_id]] = 1
    end

    # send success message

    flash[:success] = "#{params[:product_name]} added to your cart"

    # redirect to current page
    redirect_to :action => "index"


  end

  private

  def set_layout
    current_patients_patient ? "patients" : "patients_login"
  end


end
