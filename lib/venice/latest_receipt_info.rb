module Venice
  class LatestReceiptInfo
    def self.parse_from(json)
      # From Apple docs:
      # > Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
      # > The JSON representation of the receipt for the most recent renewal
      if latest_receipt_info_attributes = json['latest_receipt_info']
        latest_receipt_info = []
        if latest_receipt_info_attributes.is_a? Array
          latest_receipt_info_attributes.each do |receipt_info_attrs|
            latest_receipt_info << InAppReceipt.new(receipt_info_attrs)
          end
        elsif latest_receipt_info_attributes.is_a? Hash
          latest_receipt_info << InAppReceipt.new(latest_receipt_info_attributes)
        end
        latest_receipt_info
      end
    end
  end
end
