require 'time'

module Venice
  class Receipt
    # For detailed explanations on these keys/values, see
    # https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ReceiptFields.html#//apple_ref/doc/uid/TP40010573-CH106-SW1

    # The app’s bundle identifier.
    attr_reader :bundle_id

    # The app’s version number.
    attr_reader :application_version

    # The receipt for an in-app purchase. In the JSON file, the value of this key is an array containing all in-app purchase receipts.
    attr_reader :in_app

    # The version of the app that was originally purchased.
    attr_reader :original_application_version

    # For a transaction that restores a previous transaction, the date of the original transaction.
    #
    # In an auto-renewable subscription receipt, this indicates the beginning
    # of the subscription period, even if the subscription has been renewed.
    attr_reader :original_purchase_date

    # The date when the app receipt was created
    attr_reader :creation_date

    # This key is present only for apps purchased through the
    # Volume Purchase Program.
    # If this key is not present, the receipt does not expire.
    attr_reader :expires_date

    # Non-Documented receipt keys/values
    attr_reader :receipt_type
    attr_reader :adam_id
    attr_reader :download_id
    attr_reader :requested_at

    def initialize(attributes = {})
      @original_json_response = attributes['original_json_response']
      @bundle_id = attributes['bundle_id']
      @application_version = attributes['application_version']
      @original_application_version = attributes['original_application_version']

      expires_date = attributes['expiration_date']
      @expires_date = Time.at(expires_date.to_i / 1000).to_datetime if expires_date

      original_purchase_date = attributes['original_purchase_date']
      @original_purchase_date = DateTime.parse(original_purchase_date) if original_purchase_date

      @receipt_type = attributes['receipt_type']
      @adam_id = attributes['adam_id']
      @download_id = attributes['download_id']
      @requested_at = DateTime.parse(attributes['request_date']) if attributes['request_date']

      @in_app = []
      if attributes['in_app']
        attributes['in_app'].each do |in_app_purchase_attributes|
          @in_app << InAppReceipt.new(in_app_purchase_attributes)
        end
      end
    end

    def to_hash
      {
        bundle_id: @bundle_id,
        application_version: @application_version,
        original_application_version: @original_application_version,
        original_purchase_date: (@original_purchase_date.httpdate rescue nil),
        expires_at: (@expires_at.httpdate rescue nil),
        receipt_type: @receipt_type,
        adam_id: @adam_id,
        download_id: @download_id,
        requested_at: (@requested_at.httpdate rescue nil),
        in_app: @in_app.map(&:to_h)
      }
    end
    alias_method :to_h, :to_hash

    def to_json
      to_hash.to_json
    end

  end
end
