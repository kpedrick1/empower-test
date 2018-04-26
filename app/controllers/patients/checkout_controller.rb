class Patients::CheckoutController < ApplicationController

  skip_before_action :require_login, only: [:index]

  layout :set_layout

  def index

    @commit_action = session['commit']

    @checkout_error = session['checkout_error']

    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @cart_size = session['cart_products'].length

    puts "\n\n@cart_size\n\n"
    puts @cart_size
    puts "\n\n"




    @checkout_session = session

    get_cart_items

    if @commit_action == 'Complete order' && @checkout_error == false
      delete_all_cart_session
    end

    delete_cart_session

  end

  def save

    if (params['commit'] == 'Continue to Payment method')

      if params['email_address'] != params['confirm_email']

        params['commit'] = 'Return to customer information'

        flash[:danger] = 'Emails do not match!'

      end
    end

    # save params to session
    create_cart_session

    if params['commit'] == 'Complete order'

      save_cart_items(params)

    end

    redirect_to :action => "index"

  end

  def save_cart_items params

    client = Restforce.new

    if session[:account_id] != nil

      result = client.post '/services/apexrest/portal/checkout/', :userid => session[:account_id], :par => params, :business_unit => ENV['BUSINESS_UNIT']

    else

      result = client.post '/services/apexrest/portal/checkout/', :userid => '', :par => params, :business_unit => ENV['BUSINESS_UNIT']

    end


    if result.body['isError'] == false

      session['checkout_error'] = false

    else

      session['checkout_error'] = true

      flash[:danger] = result.body['message']
    end

  end

  def get_cart_items

    @cart_grand_total = 0

    free_shipping = false

    has_gift = false

    has_16 = false

    client = Restforce.new

    result = client.get '/services/apexrest/portal/pricebook/', :business_unit => ENV['BUSINESS_UNIT'], :account_id => session[:account_id]

    price_book = result.body.productList

    shipping_book = result.body.shippingList

    coupon_map = result.body.couponMap

    account = result.body.account

    if session[:account_id] != nil

      session['first_name'] = account.First_Name__c
      session['last_name'] = account.Last_Name__c
      session['email_address'] = account.PersonEmail
      session['confirm_email'] = account.PersonEmail

      if session['billing_phone'] == nil
        session['billing_phone'] = account.PersonMobilePhone
      end

    end



    BigDecimal("0.9987")

    @cart_items = Array.new

    price_book.each do |line_item|

      if session['cart_products'].key?(line_item.productId)

        line_item.quantity = session['cart_products'][line_item.productId]

        if line_item.productCode == 'EmpTROGiftBox' || line_item.productCode == 'EmpTRLGiftBox' || line_item.productCode == 'EmpTROMDGiftBox'
          has_gift = true
        end
        if line_item.productCode == 'EmpSoakingSalts16'
          has_16 = true
        end
        if @cart_grand_total >= 100.00
          free_shipping = true
        end


        line_item.totalPrice = BigDecimal(line_item.quantity.to_s) * BigDecimal(line_item.productPrice.to_s)
        if @commit_action == 'Continue to Payment method' || (@commit_action == 'Complete order' && @checkout_error == false)
          if coupon_map.key?(line_item.productCode.to_s + '-' + session['coupon_code'].to_s)
            line_item.totalPrice = line_item.totalPrice - (line_item.totalPrice * BigDecimal(coupon_map[line_item.productCode.to_s + '-' + session['coupon_code'].to_s].Percent__c.to_s) / 100)
          end
        end

        puts "\n\nline_item.totalPrice\n\n"
        puts line_item.totalPrice
        puts "\n\n"


        @cart_grand_total += line_item.totalPrice

        @cart_items.push(line_item)
      end

    end

    shipping_book.each do |ship_item|

      if has_gift == true

        if ship_item.productCode == 'empshipgift'


          ship_item.quantity = 1
          ship_item.totalPrice = ship_item.productPrice


          @cart_grand_total += ship_item.productPrice

          @cart_items.push(ship_item)

          break
        end

      elsif has_16 == true
        
          if ship_item.productCode == 'empship16'


          ship_item.quantity = 1
          ship_item.totalPrice = ship_item.productPrice


          @cart_grand_total += ship_item.productPrice

          @cart_items.push(ship_item)

            break
          end
      else
        if ship_item.productCode == 'empship'
          ship_item.quantity = 1
          ship_item.totalPrice = ship_item.productPrice
          @cart_grand_total += ship_item.productPrice
          @cart_items.push(ship_item)
          break
        end
      end
    end
  end


  def create_cart_session

    session['commit'] = params['commit']
    #session['productline'] = params['productline']

    session['coupon_code'] = params['coupon_code'].upcase
    session['email_address'] = params['email_address']
    session['confirm_email'] = params['confirm_email']
    session['billing_phone'] = params['billing_phone']
    session['first_name'] = params['first_name']
    session['last_name'] = params['last_name']
    session['billing_address1'] = params['billing_address1']
    session['billing_city'] = params['billing_city']
    session['billing_state'] = params['billing_state']
    session['billing_zip'] = params['billing_zip']
    session['recipient_full_name'] = params['recipient_full_name']
    session['shipping_address1'] = params['shipping_address1']
    session['shipping_city'] = params['shipping_city']
    session['shipping_state'] = params['shipping_state']
    session['shipping_zip'] = params['shipping_zip']

    session['same_shipping'] = params['same_shipping']

  end

  def delete_cart_session
    session['commit'] = nil
    session['checkout_error'] = nil
  end


  def delete_all_cart_session

    session['cart_products'] = nil

  end

  private

  def set_layout
    current_patients_patient ? "patients" : "patients_login"
  end

end
