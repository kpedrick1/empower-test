class Patients::CheckoutController < ApplicationController


  skip_before_action :require_login, only: [:index]

  layout :set_layout


  def index


    @commit_action = session['commit']



    @checkout_error = session['checkout_error']



    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @checkout_session = session



    #puts "\n\n @checkout_session['coupon_code'] \n\n"
    #puts @checkout_session['coupon_code']

    get_cart_items


    if @commit_action == 'Complete order' && @checkout_error == false
      delete_all_cart_session
    end




    delete_cart_session

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



      save_cart_items(params)



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


    puts "\n\n result.body['code'] \n\n"
    puts result.body['code']
    puts "\n\n result.body['message'] \n\n"
    puts result.body['message']
    puts "\n\n result.body['isError'] \n\n"
    puts result.body['isError']


    if result.body['isError'] == false
      puts "\n\n THERE ARE NO ERRORS \n\n"

      session['checkout_error'] = false

    else
      puts "\n\n THERE IS AN ERROR\n\n"


      session['checkout_error'] = true

      flash[:success] = result.body['message']
    end


  end



  def get_cart_items

    @cart_grand_total = 0

    has_eptex = false

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

    shipping_book = result.body.shippingList



    @cart_items = Array.new



    price_book.each do |line_item|


      if session['cart_products'].key?(line_item.productId)

        line_item.quantity = session['cart_products'][line_item.productId]


        if line_item.productCode == 'EptxWSngle' || line_item.productCode == 'EptxLSngl'
          has_eptex = true
        end


        #puts "\n\nline_item\n\n"
        #puts line_item


        #puts "\n\nline_item.quantity\n\n"
        #puts line_item.quantity

        #puts "\n\nline_item.productPrice\n\n"
        #puts line_item.productPrice



        line_item.totalPrice = line_item.quantity.to_f * line_item.productPrice.to_f


        @cart_grand_total += line_item.totalPrice

        @cart_items.push(line_item)
      end

    end

    shipping_book.each do |ship_item|

      puts "\n\nship_item\n\n"
      puts ship_item
      puts "\n\n"


      if has_eptex == true

        if ship_item.productCode == 'Shipping Eptex'


          ship_item.quantity = 1
          ship_item.totalPrice = ship_item.productPrice.to_f


          @cart_grand_total += ship_item.productPrice.to_f

          @cart_items.push(ship_item)

          break
        end

      else

        if ship_item.productCode == 'Shipping Epiceram-L'

          ship_item.quantity = 1
          ship_item.totalPrice = ship_item.productPrice.to_f

          @cart_grand_total += ship_item.productPrice.to_f

          @cart_items.push(ship_item)

          break
        end

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

  def delete_cart_session
    session['commit'] = nil
    session['checkout_error'] = nil
  end


  def delete_all_cart_session

    session['cart_products'] = nil

    # session['coupon_code'] = nil
    # session['email_address'] = nil
    # session['confirm_email'] = nil
    # session['billing_phone'] = nil
    # session['first_name'] = nil
    # session['last_name'] = nil
    # session['billing_address1'] = nil
    # session['billing_address2'] = nil
    # session['billing_city'] = nil
    # session['billing_state'] = nil
    # session['billing_zip'] = nil
    # session['shipping_address1'] = nil
    # session['shipping_address2'] = nil
    # session['shipping_city'] = nil
    # session['shipping_state'] = nil
    # session['shipping_zip'] = nil

  end


  private


  def set_layout
    current_patients_patient ? "patients" : "patients_login"
  end



end
