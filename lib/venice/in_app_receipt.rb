require 'time'

module Venice
  class InAppReceipt
    # For detailed explanations on these keys/values, see
    # https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html#//apple_ref/doc/uid/TP40010573-CH106-SW12

    # The number of items purchased. 
    #
    # This value corresponds to the quantity property of the SKPayment object
    #   stored in the transaction’s payment property.
    attr_reader :quantity

    # The product identifier of the item that was purchased.
    # This value corresponds to the productIdentifier property of the SKPayment
    #   object stored in the transaction’s payment property.
    attr_reader :product_id

    # The transaction identifier of the item that was purchased.
    # This value corresponds to the transaction’s transactionIdentifier property.
    attr_reader :transaction_id

    # The date and time this transaction occurred.
    # This value corresponds to the transaction’s transactionDate property.
    attr_reader :purchase_date

    # The expiration date for the subscription, expressed as the number of milliseconds
    #   since January 1, 1970, 00:00:00 GMT.
    attr_reader :expires_date

    # For a transaction that was canceled by Apple customer support, the time and date
    #   of the cancellation.
    attr_reader :cancellation_date

    # A string that the App Store uses to uniquely identify the application that created
    #   the transaction.
    # If your server supports multiple applications, you can use this value to differentiate
    #   between them.
    # Apps are assigned an identifier only in the production environment, so this key is not
    #   present for receipts created in the test environment.
    # This field is not present for Mac apps.
    # See also Bundle Identifier.
    attr_reader :app_item_id

    # An arbitrary number that uniquely identifies a revision of your application.
    # This key is not present for receipts created in the test environment.
    attr_reader :version_external_identifier

    # For a transaction that restores a previous transaction, this is the original receipt
    attr_accessor :original

    def initialize(attributes = {})
      @quantity = Integer(attributes['quantity']) if attributes['quantity']
      @product_id = attributes['product_id']
      @transaction_id = attributes['transaction_id']
      @app_item_id = attributes['app_item_id']
      @version_external_identifier = attributes['version_external_identifier']
      @is_trial_period = attributes['is_trial_period'] || false
      @is_in_intro_offer_period = attributes['is_in_intro_offer_period'] || false

      begin
        purchase_date = attributes['purchase_date']
        @purchase_date = DateTime.parse(purchase_date) if purchase_date
      rescue ArgumentError => e
        @purchase_date = Time.at(purchase_date.to_i / 1000).to_datetime
      end

      begin
        expires_date = attributes['expires_date']
        @expires_date = DateTime.parse(expires_date) if expires_date
      rescue ArgumentError => e
        @expires_date = Time.at(expires_date.to_i / 1000).to_datetime
      end

      begin
        cancellation_date = attributes['cancellation_date']
        @cancellation_date = DateTime.parse(cancellation_date) if cancellation_date
      rescue ArgumentError => e
        @cancellation_date = Time.at(cancellation_date.to_i / 1000).to_datetime
      end

      orig_trans_id = attributes['original_transaction_id']
      orig_purchase_date = attributes['original_purchase_date']
      if orig_trans_id || orig_purchase_date
          @original = InAppReceipt.new({
              'transaction_id' => orig_trans_id,
              'purchase_date' => orig_purchase_date
          })
      end
    end

    # This method is only useful for auto-renewable subscription receipts.
    # This will return "true" if the customer’s subscription
    # is currently in the free trial period, or "false" if not.
    def is_trial_period?
      @is_trial_period
    end

    # This method is only useful for auto-renewable subscription receipts.
    # This will return "true" if the customer’s subscription is
    # currently in an introductory price period, or "false" if not.
    def is_in_intro_offer_period?
      @is_in_intro_offer_period
    end

    def to_hash
      {
        quantity: @quantity,
        product_id: @product_id,
        transaction_id: @transaction_id,
        purchase_date: (@purchase_date.httpdate rescue nil),
        expires_date: (@expires_date.httpdate rescue nil),
        cancellation_date: (@cancellation_date.httpdate rescue nil),
        original_purchase_date: (@original.purchase_date.httpdate rescue nil),
        original_transaction_id: (@original.transaction_id rescue nil),
        app_item_id: @app_item_id,
        version_external_identifier: @version_external_identifier,
      }
    end
    alias_method :to_h, :to_hash

    def to_json
      to_hash.to_json
    end
  end
end
