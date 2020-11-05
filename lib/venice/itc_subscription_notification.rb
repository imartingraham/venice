module Venice
  class ItcSubscriptionNotification
    # More info: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW1

    # Original json response from AppStore
    attr_reader :original_json_response

    # The environment for which App Store generated the receipt.
    #
    # Type: String
    # Possible values: Sandbox, PROD
    attr_reader :environment

    # An object that contains information about the most-recent, 
    # in-app purchase transactions for the app.
    #
    # https://developer.apple.com/documentation/appstoreservernotifications/unified_receipt
    attr_reader :unified_receipt

    # If the key `latest_receipt_info` is present in the response, this will
    # be populated with an instance of Venice::InAppReceipt.
    attr_reader :latest_receipt_info
    alias :latest_expired_receipt_info :latest_receipt_info

    # Base64 encoded string which represents the latest receipt
    attr_reader :latest_receipt
    alias :latest_expired_receipt :latest_receipt

    # The current renewal status for an auto-renewable subscription product. 
    #
    # Note that these values are different from those of the auto_renew_status in the receipt.
    #
    # Type: String
    # Possible values: true, false
    attr_reader :auto_renew_status

    # The product identifier of the auto-renewable subscription that the user’s subscription renews.
    #
    # Type: String
    attr_reader :auto_renew_product_id

    # The time at which the user turned on or off the renewal status for an 
    # auto-renewable subscription, in a date-time format similar to the ISO 8601 standard.
    #
    # Type: String
    attr_reader :auto_renew_status_change_date

    # The time at which the user turned on or off the renewal status for an auto-renewable 
    # subscription, in UNIX epoch time format, in milliseconds. 
    # Use this time format to process dates.
    #
    # Type: String
    attr_reader :auto_renew_status_change_date_ms

    # Describes the kind of event that triggered the notification.
    # See values in Table 6-4. (https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW16)
    attr_reader :notification_type

    # The reason a subscription expired. 
    # 
    # This field is only present for an expired auto-renewable subscription. 
    # See https://developer.apple.com/documentation/appstorereceipts/expiration_intent for more information.
    #
    # Type: Integer
    # Possible values: 
    #    1 – The customer voluntarily canceled their subscription.
    #    2 – Billing error; for example, the customer's payment information was no longer valid.
    #    3 – The customer did not agree to a recent price increase.
    #    4 – The product was not available for purchase at the time of renewal.
    #    5 – Unknown error.
    attr_reader :expiration_intent

    # The same value as the shared secret you submit in the password field of the 
    # requestBody when validating receipts.
    #
    # Tyoe: String
    attr_reader :password

    attr_reader :original_transaction_id

    module NotificationType
      # Initial purchase of the subscription. Store the latest_receipt on
      # your server as a token to verify the user’s subscription status
      # at any time, by validating it with the App Store.
      INITIAL_BUY = "INITIAL_BUY".freeze

      # Indicates that either Apple customer support canceled the 
      # subscription or the user upgraded their subscription. 
      # The cancellation_date key contains the date and time of the change.
      CANCEL = "CANCEL".freeze

      # Automatic renewal was successful for an expired subscription.
      # Check Subscription Expiration Date to determine the next
      # renewal date and time.
      RENEWAL = "RENEWAL".freeze

      # Customer renewed a subscription interactively after it lapsed,
      # either by using your app’s interface or on the App Store in
      # account settings. Service is made available immediately.
      INTERACTIVE_RENEWAL = "INTERACTIVE_RENEWAL".freeze

      # Customer changed the plan that takes affect at the next
      # subscription renewal. Current active plan is not affected.
      DID_CHANGE_RENEWAL_PREF = "DID_CHANGE_RENEWAL_PREF".freeze
      DID_CHANGE_RENEWAL_STATUS = "DID_CHANGE_RENEWAL_STATUS".freeze

      # Indicates a subscription that failed to renew due to a 
      # billing issue. Check is_in_billing_retry_period to know 
      # the current retry status of the subscription. 
      # Check grace_period_expires_date to know the new service 
      # expiration date if the subscription is in a billing grace period.
      DID_FAIL_TO_RENEW = "DID_FAIL_TO_RENEW".freeze

      # Indicates a successful automatic renewal of an expired 
      # subscription that failed to renew in the past. 
      # Check expires_date to determine the next renewal date and time.
      DID_RECOVER = "DID_RECOVER".freeze

      # Indicates that a customer’s subscription has successfully 
      # auto-renewed for a new transaction period.
      DID_RENEW = "DID_RENEW".freeze

      # Indicates that App Store has started asking the customer to consent 
      # to your app’s subscription price increase. 
      # In the unified_receipt.Pending_renewal_infoobject, the price_consent_status 
      # value is 0, indicating that App Store is asking for the customer’s 
      # consent, and hasn’t received it. 
      # The subscription won’t auto-renew unless the user agrees to the new price. 
      # When the customer agrees to the price increase, the system sets 
      # price_consent_status to 
      # 1. Check the receipt using verifyReceipt to view the updated price-consent status.
      PRICE_INCREASE_CONSENT = "PRICE_INCREASE_CONSENT".freeze

      # Indicates that App Store successfully refunded a transaction. 
      # The cancellation_date_ms contains the timestamp of the refunded transaction. 
      # The original_transaction_id and product_id identify the original 
      # transaction and product. The cancellation_reason contains the reason.
      REFUND = "REFUND".freeze
    end

    def initialize(json)
      @original_json_response = json
      @environment = json['environment']
      
      @unified_receipt = Venice::UnifiedReceipt.new(json['unified_receipt'])
      @latest_receipt = @unified_receipt.latest_receipt
      @latest_receipt_info = (@unified_receipt.latest_receipt_info || []).first
      @original_transaction_id = @latest_receipt_info.original.transaction_id if @latest_receipt_info
      
      @notification_type = json['notification_type']
      
      @auto_renew_status = json['auto_renew_status']
      @auto_renew_product_id = json['auto_renew_product_id']
      status_change_date = json['auto_renew_status_change_date']
      @auto_renew_status_change_date = DateTime.parse(status_change_date) if status_change_date
      @auto_renew_status_change_date_ms = json['auto_renew_status_change_date_ms']

      @is_in_billing_retry_period = json['is_in_billing_retry_period']
      @grace_period_expires_date = json['grace_period_expires_date']
      @expiration_intent = json['expiration_intent']

      @password = json['password']
    end

    def to_hash
      {
        latest_receipt_info: @latest_receipt_info.map(&:to_h),
        latest_receipt: @latest_receipt,
        auto_renew_status: @auto_renew_status,
        auto_renew_product_id: @auto_renew_product_id,
        notification_type: @notification_type,
        cancellation_date: (@cancellation_date.httpdate rescue nil),
        original_transaction_id: @original_transaction_id,
        auto_renew_status_change_date: @auto_renew_status_change_date,
        auto_renew_status_change_date_ms: @auto_renew_status_change_date_ms,
        is_in_billing_retry_period: @is_in_billing_retry_period,
        grace_period_expires_date: @grace_period_expires_date,
        expiration_intent: @expiration_intent,
        password: @password
      }
    end
    alias_method :to_h, :to_hash

  end
end
