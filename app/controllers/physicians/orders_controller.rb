class Physicians::OrdersController < Physicians::ApplicationController

  layout 'physicians'


  def index

    @opp_lines = []

    @grand_total = 0;

    get_order_salesforce

    get_first_order_account



    puts "\n"
    puts "\n"

    puts @order_line

    puts "\n"
    puts "\n"
    puts "\n"

    # @oppId = params[:oppId]
    #
    @commit_action = session['commit']
    @payment_type = session['paymentType']


    @oppId = session['oppId'];


    puts '-----------------START @commit_action -------------------------'
    puts "\n"
    puts @commit_action
    puts "\n"
    puts '-----------------END @commit_action -------------------------'
    puts "\n"

    puts "\n"
    puts "\n"


    if @commit_action == 'Place Order'


      products = session['productline']

      shipping = session['shippingType']

      puts "\n"
      puts "--------START ProductLine---------\n"
      puts "\n"


      #puts "---------shipping----------------\n"
      #puts shipping

      @order_line.each { |orderline|
        products.each { |product|
          if orderline.productId != product['productId']
            next
          end

          if product['qty'] == nil
            next
          end

          #puts "#{product}\n"

          orderline.qty = product['qty']

          orderline.totalPrice = orderline.qty.to_f * orderline.unitPrice.to_f

          if (session[:has_order] == false)
            orderline.totalPrice = orderline.totalPrice.to_f - (orderline.totalPrice.to_f * 0.20)
          end

          @grand_total = @grand_total + orderline.totalPrice.to_f

          @opp_lines.push(orderline)
        }
      }

      @shipping_options.each {|shippingopt|

        if (shippingopt.productId != shipping )
          next
        end

        shippingopt.qty = 1

        shippingopt.totalPrice = shippingopt.unitPrice

        if shippingopt.productName.include? 'Standard Shipping'
          shippingopt.totalPrice = 0
        end

        @grand_total = @grand_total + shippingopt.totalPrice.to_f

        @opp_lines.push(shippingopt)

      }

      puts @opp_lines

      puts "\n"
      puts "-------END ProductLine----------\n"
      puts "\n"


    elsif @commit_action == 'Accept'

      products = session['productline']

      puts "\n"
      puts "--------START ProductLine---------\n"
      puts "\n"


      #puts "---------shipping----------------\n"
      #puts shipping

      @order_line.each { |orderline|
        products.each { |product|
          if orderline.productId != product['productId']
            next
          end

          if product['qty'] == nil
            next
          end

          #puts "#{product}\n"

          orderline.qty = product['qty']

          orderline.totalPrice = orderline.qty.to_f * orderline.unitPrice.to_f

          if (session[:has_order] == false)
            orderline.totalPrice = orderline.totalPrice.to_f - (orderline.totalPrice.to_f * 0.20)
          end

          @grand_total = @grand_total + orderline.totalPrice.to_f

          @opp_lines.push(orderline)
        }
      }

      @shipping_options.each {|shippingopt|

        products.each { |product|
          if shippingopt.productId != product['productId']
            next
          end

          if product['qty'] == nil
            next
          end

          #puts "#{product}\n"

          shippingopt.qty = product['qty']

          shippingopt.totalPrice = shippingopt.unitPrice

          if shippingopt.productName.include? 'Standard Shipping'
            shippingopt.totalPrice = 0
          end

          @grand_total = @grand_total + shippingopt.totalPrice.to_f

          @opp_lines.push(shippingopt)
        }

      }


    end

    delete_cart_session

    puts "has order \n"

    puts @has_order


  end

  def get_first_order_account

    account_id = session[:account_id]

    client = Restforce.new

    accounts = client.query("select Id, Orders__c from Account where Id = '#{account_id}'")

    account = accounts.first


    if (!account.nil? && account.Orders__c > 0)
      session[:has_order] = true
    else
      session[:has_order] = false
    end

    @has_order = session[:has_order]


  end

  def get_opportunity_salesforce


    account_id = session[:account_id]

    client = Restforce.new

    result = client.get '/services/apexrest/portal/opportunity/', :oppId => @oppId


    @opportunity = result.body.opportunity



  end

  def get_order_salesforce

    account_id = session[:account_id]

    client = Restforce.new

    result = client.get '/services/apexrest/portal/orders/'

    @order_line = result.body.orderLineList

    @shipping_options = result.body.shippingList

  end

  def create

      #send data to salesforce endpoint

    puts "\n"
    puts "\n"
    puts '-----------------create called -------------------------'
    puts "--------start params.inspect--------\n"
    puts "\n"
    puts params.inspect
    puts "\n"
    puts "------- end params.inspect --------\n"
    puts "\n"
    puts 'commit::::::::'
    puts "\n"
    puts params['commit']
    puts "\n"
    puts "\n"

    create_cart_session

    if params['commit'] == 'Accept'


      puts 'place order called'


      client = Restforce.new

      args = Hash.new
      args["username"] = session[:account_id]
      #args["order"] = params[:inventory]

      result = client.post '/services/apexrest/portal/order_product/', :userid => session[:account_id], :par => params


      puts "\n"
      puts "\n"
      puts '-----------------result -------------------------'
      puts result
      puts "\n"
      puts result.body
      puts "\n"
      puts "\n"

      session['oppId'] = result.body['opportunityId']

      session['paymentType'] = params['paymentType']

    elsif params['commit'] == 'Close Invoice'
      delete_cart_session
      redirect_to '/physicians/orderhistories'
      return
    end

    redirect_to action: "index"

  end

  def create_cart_session

    session['commit'] = params['commit']
    session['productline'] = params['productline']
    session['shippingType'] = params['shippingType']

  end

  def delete_cart_session

    session['commit'] = nil
    session['productline'] = nil
    session['shippingType'] = nil
    session['oppId'] = nil

  end


end