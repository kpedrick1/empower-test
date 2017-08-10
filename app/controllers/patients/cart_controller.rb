class Patients::CartController < ApplicationController

  skip_before_action :require_login, only: [:index]

  layout :set_layout

  def index

    if session['cart_products'] == nil
      session['cart_products'] = {}
    end

    @cart_size = session['cart_products'].length

    get_cart_items

  end


  def get_cart_items


    client = Restforce.new

    result = client.get '/services/apexrest/portal/pricebook/', :business_unit => ENV['BUSINESS_UNIT']

    # todo: handle error response


    puts "get pricebook body \n\n"

    puts result.body

    puts "\n"

    puts "get pricebook body productList \n\n"

    puts result.body.productList

    puts "\n"


    price_book = result.body.productList


    @cart_items = Array.new

    price_book.each do |line_item|


      if session['cart_products'].key?(line_item.productId)

        line_item.quantity = session['cart_products'][line_item.productId]

        @cart_items.push(line_item)
      end

    end


  end


  def save

    puts "\n\n params['commit'] \n"
    puts params['commit']
    puts "\n\n"

    if params['commit'] == 'remove'

      puts "\n\n REMOVE CALLED \n\n"

      remove_from_cart

    elsif params['commit'] == 'Checkout'

      puts "\n\n CHECKOUT CALLED \n\n"

      puts "\n\n params['productline'] \n\n"
      puts params['productline']

      puts "\n\n session['cart_products'] \n\n"
      puts session['cart_products']


      params['productline'].each { |product|

        session['cart_products'][product['productId']] = product['qty']
      }


      puts "\n\n session['cart_products'] \n\n"
      puts session['cart_products']






      if current_patients_patient
        redirect_to patients_checkout_path
      else
        redirect_to patients_checkout_path
      end



    end


  end


  def remove_from_cart



    # remove product id from cart

    session['cart_products'].delete(params[:product_id])

    # send success message

    flash[:success] = "#{params[:product_name]} removed from your cart"

    # redirect to current page
    redirect_to :action => "index"

  end



  private


  def set_layout
    current_patients_patient ? "patients" : "patients_login"
  end


end
