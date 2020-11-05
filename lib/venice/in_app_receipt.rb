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

    # The unique identifier of the product purchased. You provide this value when creating the product in App Store Connect, and it corresponds to the productIdentifier property of the SKPayment object stored in the transaction’s payment property.
    attr_reader :product_id

    # The transaction identifier of the item that was purchased.
    # This value corresponds to the transaction’s transactionIdentifier property.
    attr_reader :transaction_id

    # The time when the App Store charged the user’s account for a subscription purchase or renewal after a lapse, in a date-time format similar to the ISO 8601 standard.
    attr_reader :purchase_date

    # The time when a subscription expires or when it will renew, in UNIX epoch time format, in milliseconds. Use this time format for processing dates. Note that this field is called expires_date_ms in the receipt.
    attr_reader :expires_date

    # The time when Apple customer support canceled a transaction, in a date-time format similar to the ISO 8601. This field is only present for refunded transactions.
    attr_reader :cancellation_date

    # The reason for a refunded transaction. When a customer cancels a transaction, the App Store gives them a refund and provides a value for this key. A value of “1” indicates that the customer canceled their transaction due to an actual or perceived issue within your app. A value of “0” indicates that the transaction was canceled for another reason; for example, if the customer made the purchase accidentally.
    # Possible values: 1, 0
    attr_accessor :cancellation_reason

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

    # For a transaction that restores a previous transaction, this is the original receipt.
    attr_accessor :original

    # An indicator of whether an auto-renewable subscription is in the introductory price period. For more information, see is_in_intro_offer_period.
    # Possible values: true, false
    attr_reader :is_in_intro_offer_period

    # An indicator of whether a subscription is in the free trial period. For more information, see is_trial_period.
    # Possible values: true, false
    attr_reader :is_trial_period

    # An indicator that the system canceled a subscription because the user upgraded. This field is only present for upgrade transactions.
    # Value: true
    attr_reader :is_upgraded

    # The identifier of the subscription offer redeemed by the user. For more information, see promotional_offer_id.
    attr_reader :promotional_offer_id

    # The identifier of the subscription group to which the subscription belongs. The value for this field is identical to the subscriptionGroupIdentifier property in SKProduct.
    attr_reader :subscription_group_identifier

    def initialize(attributes = {})
      @quantity = Integer(attributes['quantity']) if attributes['quantity']
      @product_id = attributes['product_id']
      @transaction_id = attributes['transaction_id']
      @app_item_id = attributes['app_item_id']
      @version_external_identifier = attributes['version_external_identifier']
      @is_trial_period = attributes['is_trial_period'] || false
      @is_in_intro_offer_period = attributes['is_in_intro_offer_period'] || false
      @is_upgraded = attributes['is_upgraded'] || false
      @promotional_offer_id = attributes['promotional_offer_id']
      @subscription_group_identifier = attributes['subscription_group_identifier']

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
        @cancellation_reason = attributes['cancellation_reason']
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
        promotional_offer_id: @promotional_offer_id,
        subscription_group_identifier: @subscription_group_identifier
      }
    end
    alias_method :to_h, :to_hash

    def to_json
      to_hash.to_json
    end
  end
end
