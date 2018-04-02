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

    def initialize(json)
      @original_json_response = json

      @status = Integer(json['status'])
      receipt_data = json['receipt']

      case @status
      when 0, 21006
        @environment = json['environment']
        @receipt = Venice::Receipt.new(receipt_data) if receipt_data
        @latest_receipt_info = Venice::LatestReceiptInfo.parse_from(json)
        @pending_renewal_info = Venice::PendingRenewalInfo.parse_from(json)
      else
        raise VerificationError, json
      end
    end

    def is_subscription?
      @pending_renewal_info && !@pending_renewal_info.empty?
    end

    def to_hash
      {
        status: @status,
        receipt: @receipt.to_h,
        latest_receipt_info: @latest_receipt_info.map(&:to_h),
        pending_renewal_info: @pending_renewal_info.map(&:to_h),
        original_json_response: @original_json_response
      }
    end
    alias_method :to_h, :to_hash

  end
end
