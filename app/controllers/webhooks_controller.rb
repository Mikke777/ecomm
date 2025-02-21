class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      Rails.logger.error "Invalid payload: #{e.message}"
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      Rails.logger.error "Webhook signature verification failed: #{e.message}"
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    case event.type
    when 'checkout.session.completed'
      handle_checkout_session_completed(event.data.object)
    else
      Rails.logger.info "Unhandled event type: #{event.type}"
    end

    render json: { message: 'success' }
  end

  private

  def handle_checkout_session_completed(session)
    shipping_details = session["shipping_details"]
    Rails.logger.info "Session: #{session}"
    address = if shipping_details
                "#{shipping_details['address']['line1']} #{shipping_details['address']['city']}, #{shipping_details['address']['state']} #{shipping_details['address']['postal_code']}"
              else
                ""
              end

    # Find the order by session ID or other identifier
    order = Order.find_by(checkout_session_id: session.id)
    if order
      order.update!(customer_email: session["customer_details"]["email"], total: session["amount_total"], address: address, fulfilled: true)
      Rails.logger.info "Order updated: #{order.inspect}"
    else
      order = Order.create!(customer_email: session["customer_details"]["email"], total: session["amount_total"], address: address, fulfilled: true, checkout_session_id: session.id)
      Rails.logger.info "Order created: #{order.inspect}"
    end

    full_session = Stripe::Checkout::Session.retrieve({
      id: session.id,
      expand: ['line_items']
    })
    line_items = full_session.line_items
    line_items["data"].each do |item|
      product = Stripe::Product.retrieve(item["price"]["product"])
      product_id = product["metadata"]["product_id"].to_i

      # Check if the product exists in the database
      db_product = Product.find_by(id: product_id)
      if db_product.nil?
        Rails.logger.warn "Product with ID #{product_id} not found in the database."
        next
      end

      OrderProduct.create!(order: order, product_id: product_id, quantity: item["quantity"], size: product["metadata"]["size"])
      Stock.find(product["metadata"]["product_stock_id"]).decrement!(:amount, item["quantity"])
    end
  end
end
