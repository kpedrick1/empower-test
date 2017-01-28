class Patients::CheckoutController < ApplicationController


  skip_before_action :require_login, only: [:index]

  layout :set_layout


  def index


    @commit_action = session['commit']







    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @checkout_session = session



    #puts "\n\n @checkout_session['coupon_code'] \n\n"
    #puts @checkout_session['coupon_code']

    get_cart_items





  end



  def save

    puts "\n\n params \n\n"
    puts params

    puts "\n\nparams['productline']\n\n"
    puts params['productline']


    puts "\n\n params['expiration_year'] \n\n"
    puts params['expiration_year']

    # save params to session
    create_cart_session


    #puts "\n\nparams['commit']\n\n"
    #puts params['commit']


    #puts "\n\n params \n\n"

    #puts params

    if params['commit'] == 'Complete order'



      opportunity_id = save_cart_items(params)



    end



   redirect_to :action => "index"


  end

  def save_cart_items params


    #puts "\n\nsession[:account_id]\n\n"
    #puts  session[:account_id]

    #puts "\n\n save_cart_items - params\n\n"
    #puts params

    client = Restforce.new

    if session[:account_id] == nil

      result = client.post '/services/apexrest/portal/checkout/', :userid => session[:account_id], :par => params, :business_unit => ENV['BUSINESS_UNIT']

    else

      result = client.post '/services/apexrest/portal/checkout/', :userid => '', :par => params, :business_unit => ENV['BUSINESS_UNIT']

    end

    puts "\n\n result.body \n\n"
    puts result.body


    #puts "\n\n result.body['opportunityId'] \n\n"



    result.body['opportunityId']

    #puts "\n\n"

  end



  def get_cart_items

    client = Restforce.new

    result = client.get '/services/apexrest/portal/pricebook/', :business_unit => ENV['BUSINESS_UNIT']

    # todo: handle error response


    #puts "get pricebook body \n\n"

    #puts result.body

    #puts "\n"

    #puts "get pricebook body productList \n\n"

    #puts result.body.productList

    #puts "\n"


    price_book = result.body.productList


    @cart_items = Array.new



    price_book.each do |line_item|


      if session['cart_products'].key?(line_item.productId)

        line_item.quantity = session['cart_products'][line_item.productId]


        #puts "\n\nline_item\n\n"
        #puts line_item


        #puts "\n\nline_item.quantity\n\n"
        #puts line_item.quantity

        #puts "\n\nline_item.productPrice\n\n"
        #puts line_item.productPrice



        line_item.totalPrice = line_item.quantity.to_f * line_item.productPrice.to_f

        @cart_items.push(line_item)
      end

    end


  end



  def create_cart_session

    session['commit'] = params['commit']
    #session['productline'] = params['productline']

    session['coupon_code'] = params['coupon_code']
    session['email_address'] = params['email_address']
    session['confirm_email'] = params['confirm_email']
    session['billing_phone'] = params['billing_phone']
    session['first_name'] = params['first_name']
    session['last_name'] = params['last_name']
    session['billing_address1'] = params['billing_address1']
    session['billing_address2'] = params['billing_address2']
    session['billing_city'] = params['billing_city']
    session['billing_state'] = params['billing_state']
    session['billing_zip'] = params['billing_zip']
    session['shipping_address1'] = params['shipping_address1']
    session['shipping_address2'] = params['shipping_address2']
    session['shipping_city'] = params['shipping_city']
    session['shipping_state'] = params['shipping_state']
    session['shipping_zip'] = params['shipping_zip']

    #session['card_number'] = params['card_number']
    #session['card_type'] = params['card_type']
    #session['expiration_month'] = params['expiration_month']
    #session['expiration_year'] = params['expiration_month']
    #session['security_code'] = params['security_code']




  end


  private


  def set_layout
    current_patients_patient ? "patients" : "patients_login"
  end



end
