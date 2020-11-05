module Venice
  class PendingRenewalInfo
    # The reason a subscription expired. This field is only present for a receipt that contains an expired, auto-renewable subscription.
    # Possible values: 1, 2, 3, 4, 5
    attr_reader :expiration_intent

    # The current renewal status for the auto-renewable subscription. For more information, see auto_renew_status.
    # Possible values: 1, 0
    attr_reader :auto_renew_status

    # The current renewal preference for the auto-renewable subscription. The value for this key corresponds to the productIdentifier property of the product that the customer’s subscription renews. This field is only present if the user downgrades or crossgrades to a subscription of a different duration for the subsequent subscription period.
    attr_reader :auto_renew_product_id

    # A flag that indicates Apple is attempting to renew an expired subscription automatically. This field is only present if an auto-renewable subscription is in the billing retry state. For more information, see is_in_billing_retry_period.
    # Possible values: 1, 0
    attr_reader :is_in_billing_retry_period

    # The time at which the grace period for subscription renewals expires, in a date-time format similar to the ISO 8601.
    attr_reader :grace_period_expires_date

    # The time at which the grace period for subscription renewals expires, in UNIX epoch time format, in milliseconds. This key is only present for apps that have Billing Grace Period enabled and when the user experiences a billing error at the time of renewal. Use this time format for processing dates.
    attr_reader :grace_period_expires_date_ms

    # The unique identifier of the product purchased. You provide this value when creating the product in App Store Connect, and it corresponds to the productIdentifier property of the SKPayment object stored in the transaction’s payment property.
    attr_reader :product_id
    
    # The price consent status for a subscription price increase. This field is present only if App Store notified the customer of the price increase. The default value is "0" and changes to "1" if the customer consents.
    # Possible values: 1, 0
    attr_reader :price_consent_status

    # The transaction identifier of the original purchase.
    attr_reader :original_transaction_id

    def initialize(attributes)
      @expiration_intent = Integer(attributes['expiration_intent']) if attributes['expiration_intent']
      @auto_renew_status = Integer(attributes['auto_renew_status']) if attributes['auto_renew_status']
      @auto_renew_product_id = attributes['auto_renew_product_id']

      if attributes['is_in_billing_retry_period']
        @is_in_billing_retry_period = (attributes[is_in_billing_retry_period] == '1')
      end

      grace_expires_date = attributes['grace_period_expires_date']
      @grace_period_expires_date = DateTime.parse(grace_expires_date) if grace_expires_date
      @grace_period_expires_date_ms = attributes['grace_period_expires_date_ms']

      @product_id = attributes['product_id']

      @price_consent_status = Integer(attributes['price_consent_status']) if attributes['price_consent_status']

      @original_transaction_id = attributes['original_transaction_id']
    end

    def self.parse_from(json)
      pending_renewal_info = []
      if pending_renewal_info_attrs = json['pending_renewal_info']
        pending_renewal_info_attrs.each do |pending_renewal_attributes|
          pending_renewal_info << new(pending_renewal_attributes)
        end
      end
      pending_renewal_info
    end

    def to_hash
      {
        expiration_intent: @expiration_intent,
        auto_renew_status: @auto_renew_status,
        auto_renew_product_id: @auto_renew_product_id,
        is_in_billing_retry_period: @is_in_billing_retry_period,
        product_id: @product_id,
        price_consent_status: @price_consent_status.to_s,
        grace_period_expires_date: @grace_period_expires_date.to_s,
        grace_period_expires_date_ms: @grace_period_expires_date_ms,
        original_transaction_id: @original_transaction_id
      }
    end

    alias_method :to_h, :to_hash

    def to_json
      to_hash.to_json
    end
  end
end
