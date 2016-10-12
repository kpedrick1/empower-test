class Physicians::OrdersController < Physicians::ApplicationController

  layout 'physicians'

  def index

    @opp_lines = []

    @grand_total = 0;

    @has_rx = false
    @has_not_rx = false
    @has_multi_dist = false

    @has_shipping = false;

    @num_shipping_discounts = 0;

    get_order_salesforce

    session[:first_orders] = @first_orders

    @commit_action = session['commit']
    @payment_type = session['paymentType']


    @oppId = session['oppId']


    if @commit_action == 'Place Order'


      products = session['productline']

      shipping = session['shippingType']


      @order_line.each { |orderline|
        products.each { |product|
          if orderline.productId != product['productId']
            next
          end


          if product['qty'] == nil || product['qty'] == '0'
            next
          end

          if orderline.freeShipping != true
            @has_shipping = true;
          end

          if orderline.rXrequired == true && orderline.freeShipping != true
            @has_rx = true
          elsif orderline.rXrequired == false && orderline.freeShipping != true
            @has_not_rx = true
          end

          orderline.qty = product['qty']

          orderline.discountFormatted = ''

          orderline.totalPrice = orderline.qty.to_f * orderline.unitPrice.to_f


          @grand_total = @grand_total + orderline.totalPrice.to_f

          @opp_lines.push(orderline)
        }
      }

      has_multi_dist

      if @opp_lines.any? == false

        @commit_action = nil

        delete_cart_session

        flash.now[:danger] = 'Please select a product to order'

        return

      end

      @shipping_options.each {|shippingopt|

        if (shippingopt.productId != shipping )
          next
        end


        shippingopt.qty = 1

        shippingopt.discountFormatted = ''

        shippingopt.totalPrice = shippingopt.unitPrice

        if @has_multi_dist == true
          shippingopt.qty = 2
          shippingopt.totalPrice = shippingopt.unitPrice * shippingopt.qty
        end

        #  if user only ordered new product discount shipping
        if @has_shipping == false
          shippingopt.discountFormatted = '100%'
          shippingopt.totalPrice = 0
        end

        # shippingopt.discountFormatted = '100%'
        # shippingopt.totalPrice = 0

        @grand_total = @grand_total + shippingopt.totalPrice.to_f

        @opp_lines.push(shippingopt)

      }


    elsif @commit_action == 'Accept'


      products = session['productline']


      @order_line.each { |orderline|
        products.each { |product|
          if orderline.productId != product['productId']
            next
          end

          if product['qty'] == nil
            next
          end

          if orderline.freeShipping != true
            @has_shipping = true;
          end

          if orderline.rXrequired == true && orderline.freeShipping != true
            @has_rx = true
          elsif orderline.rXrequired == false && orderline.freeShipping != true
            @has_not_rx = true
          end


          orderline.qty = product['qty']

          orderline.totalPrice = orderline.qty.to_f * orderline.unitPrice.to_f


          @grand_total = @grand_total + orderline.totalPrice.to_f

          @opp_lines.push(orderline)
        }
      }

      has_multi_dist

      @shipping_options.each {|shippingopt|

        products.each { |product|
          if shippingopt.productId != product['productId']
            next
          end

          if product['qty'] == nil
            next
          end

          shippingopt.qty = 1

          shippingopt.discountFormatted = ''

          shippingopt.totalPrice = shippingopt.unitPrice

          if @has_multi_dist == true
            shippingopt.qty = 2
            shippingopt.totalPrice = shippingopt.unitPrice * shippingopt.qty
          end

          if @has_shipping == false
            shippingopt.discountFormatted = '100%'
            shippingopt.totalPrice = 0
          end


          @grand_total = @grand_total + shippingopt.totalPrice.to_f

          @opp_lines.push(shippingopt)
        }

      }


    end

    delete_cart_session

  end

  def has_multi_dist

    if @has_rx == true && @has_not_rx == true
      @has_multi_dist = true
    else
      @has_multi_dist = false
    end

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

    result = client.get '/services/apexrest/portal/orders/', :accountId => account_id, :businessUnit => ENV['BUSINESS_UNIT']

    # handle error response

    @order_line = result.body.orderLineList

    @shipping_options = result.body.shippingList

    @first_orders = result.body.firstTimeOrders



  end

  def create

    create_cart_session

    if params['commit'] == 'Accept'


      client = Restforce.new

      args = Hash.new
      args["username"] = session[:account_id]
      #args["order"] = params[:inventory]

      result = client.post '/services/apexrest/portal/order_product/', :userid => session[:account_id], :par => params

      session['oppId'] = result.body['opportunityId']

      session['paymentType'] = params['paymentType']

    elsif params['commit'] == 'Close Invoice'
      delete_cart_session
      redirect_to '/physicians/orderhistories'
      return
    end

    redirect_to :action => 'index'

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