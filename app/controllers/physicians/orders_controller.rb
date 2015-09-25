class Physicians::OrdersController < Physicians::ApplicationController

  layout 'physicians'


  def index


    get_order_salesforce


    puts "\n"
    puts "\n"

    puts @order_line

    puts "\n"
    puts "\n"
    puts "\n"

    @oppId = params[:oppId]

    puts @oppId

    puts "\n"
    puts "\n"


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
    puts params.inspect
    puts "\n"
    puts "\n"

    puts "\n"
    puts "\n"
    puts 'commit::::::::'
    puts "\n"

    puts params['commit']
    puts "\n"
    puts "\n"

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




    redirect_to action: "index", :oppId => result.body['opportunityId']

  end

end