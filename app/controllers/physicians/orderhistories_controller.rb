class Physicians::OrderhistoriesController < Physicians::ApplicationController

  layout 'physicians'

  def index


    get_order_history_salesforce



  end

  def get_order_history_salesforce

    account_id = session[:account_id]

    client = Restforce.new

    result = client.get '/services/apexrest/portal/order_history/', :userId => account_id

    puts "\n"
    puts "\n"
    puts "\n"

    puts result.body

    @orderList = result.body.orderList

    puts "\n"
    puts "\n"
    puts "\n"


  end



end