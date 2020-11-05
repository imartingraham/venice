module Venice
  class UnifiedReceipt

    # The environment for which App Store generated the receipt.
    # Possible values: Sandbox, Production
    attr_reader :environment

    # The latest Base64-encoded app receipt.
    attr_reader :latest_receipt

    # An array that contains the latest 100 in-app purchase transactions 
    # of the decoded value in latest_receipt. This array excludes 
    # transactions for consumable products your app has marked as finished. 
    # The contents of this array are identical to those in 
    # responseBody.Latest_receipt_info in the verifyReceipt endpoint 
    # response for receipt validation.
    attr_reader :latest_receipt_info

    # An array where each element contains the pending renewal information 
    # for each auto-renewable subscription identified in product_id. 
    # The contents of this array are identical to those in 
    # responseBody.Pending_renewal_info in the verifyReceipt endpoint 
    # response for receipt validation.
    attr_reader :pending_renewal_info

    # The status code, where 0 indicates that the notification is valid.
    # Value: 0
    attr_reader :status

    def initialize(json)
      @environment = json['environment']
      @latest_receipt = json['latest_receipt']
      @latest_receipt_info = Venice::LatestReceiptInfo.parse_from(json)
      @pending_renewal_info = Venice::PendingRenewalInfo.parse_from(json)
      @status = json['status']
    end
  end
end