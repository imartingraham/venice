module Venice
  class LatestReceiptInfo
    def self.parse_from(json)
      latest_rec_attrs = json['latest_receipt_info']
      latest_rec_attrs = json['latest_expired_receipt_info'] unless latest_rec_attrs
      latest_receipt_info = []

      return latest_receipt_info unless latest_rec_attrs

      if latest_rec_attrs.is_a? Array
        latest_rec_attrs.each do |receipt_info_attrs|
          latest_receipt_info << InAppReceipt.new(receipt_info_attrs)
        end
      elsif latest_rec_attrs.is_a? Hash
        latest_receipt_info << InAppReceipt.new(latest_rec_attrs)
      end

      latest_receipt_info
    end
  end
end
