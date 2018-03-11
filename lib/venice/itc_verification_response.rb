module Venice
  class ItcVerificationResponse

    # Original json response from AppStore
    attr_reader :original_json_response

    # Either 0 if the receipt is valid, or one of the error codes listed in
    # Table 2-1. (https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html#//apple_ref/doc/uid/TP40010573-CH104-SW5)
    attr_reader :status

    # Represents the environement the receipt was created in. Can be either
    # Sandbox or Production.
    attr_reader :environment

    # The Venice::Receipt object containing information about the receipt
    # that was submitted to Apple for verification.
    attr_reader :receipt
    alias :latest_receipt :receipt

    # If the key `latest_receipt_info` is present in the response, this will
    # be populated with an array of Venice::InAppReceipt instances.
    attr_reader :latest_receipt_info

    # Information about the status of the customer's auto-renewable subscriptions
    attr_reader :pending_renewal_info

    # NOTE: Only present for app store subscription notifications
    # More info: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW16
    #
    # The current renewal status for the auto-renewable subscription.
    #
    # This key is only present for auto-renewable subscription receipts, for
    # active or expired subscriptions. The value for this key should not be
    # interpreted as the customer’s subscription status. You can use this
    # value to display an alternative subscription product in your app,
    # for example, a lower level subscription plan that the customer can
    # downgrade to from their current plan.
    attr_reader :auto_renew_status

    # NOTE: Only present for app store subscription notifications
    # More info: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW16
    #
    # The current renewal preference for the auto-renewable subscription.
    #
    # This key is only present for auto-renewable subscription receipts.
    # The value for this key corresponds to the productIdentifier property
    # of the product that the customer’s subscription renews. You can use
    # this value to present an alternative service level to the customer
    # before the current subscription period ends.
    attr_reader :auto_renew_product_id

    # NOTE: Only present for app store subscription notifications
    # More info: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW16
    #
    # Describes the kind of event that triggered the notification.
    # See values in Table 6-4. (https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW16)
    attr_reader :notification_type

    # NOTE: Only present for app store subscription notifications
    # More info: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW16
    #
    # The time and date that a transaction was cancelled by Apple
    # customer support. Posted only if the notification_type is CANCEL.
    # See values and descriptions in NotificationType.
    attr_reader :cancellation_date

    # NOTE: Only present for app store subscription notifications
    # More info: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Subscriptions.html#//apple_ref/doc/uid/TP40008267-CH7-SW16
    #
    # This value is the same as the Original Transaction Identifier in
    # the receipt. You can use this value to relate multiple iOS 6-style
    # transaction receipts for an individual customer’s subscription.
    attr_reader :original_transaction_id

    module NotificationType
      # Initial purchase of the subscription. Store the latest_receipt on
      # your server as a token to verify the user’s subscription status
      # at any time, by validating it with the App Store.
      INITIAL_BUY = "INITIAL_BUY".freeze

      # Subscription was canceled by Apple customer support.
      # Check Cancellation Date to know the date and time when the
      # subscription was canceled.
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
    end

    def initialize(json)
      @status = json['status'].to_i if json['status']
      receipt_data = json['receipt']
      receipt_data = json['latest_receipt'] unless receipt_data
      receipt_attributes = receipt_data.dup if receipt_data
      @original_json_response = json if receipt_attributes

      case @status
      when 0, 21006
        @environment = json['environment']
        @receipt = Venice::Receipt.new(receipt_attributes)
        @latest_receipt_info = Venice::LatestReceiptInfo.parse_from(json)
        @pending_renewal_info = Venice::PendingRenewalInfo.parse_from(json)
        @auto_renew_status = json['auto_renew_status']
        @auto_renew_product_id = json['auto_renew_product_id']
        @notification_type = json['notification_type']
        cancel_date = json['cancellation_date']
        @cancellation_date = DateTime.parse(cancel_date) if cancel_date
        @original_transaction_id = json['original_transaction_id']
      else
        raise VerificationError, json
      end
    end

    def is_subscription?
      !@auto_renew_product_id.nil? || !@pending_renewal_info.nil?
    end

    def to_hash
      {
        receipt: @receipt.to_h,
        latest_receipt_info: @latest_receipt_info.map(&:to_h),
        pending_renewal_info: @pending_renewal_info.map(&:to_h),
        auto_renew_status: @auto_renew_status,
        auto_renew_product_id: @auto_renew_product_id,
        notification_type: @notification_type,
        cancellation_date: (@cancellation_date.httpdate rescue nil),
        original_transaction_id: @original_transaction_id,
      }
    end
    alias_method :to_h, :to_hash

  end
end
