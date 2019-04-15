require 'spec_helper'

describe Venice::ItcVerificationResponse do
  describe 'parses the apple app store subscription notification' do
    describe 'with non-expired receipt info' do
      let(:receipt_notif_json) do
        {
          'latest_receipt' => '<receipt-data>',
          'latest_receipt_info' => {
            'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
            'is_in_intro_offer_period' => 'false',
            'purchase_date_ms' => '1520796612000',
            'unique_identifier' => 'hueouqheluiheohiefy8ye9y38u32i8u3uwuo9w4we',
            'original_transaction_id' => '1000000375019271',
            'expires_date' => '1520796912000',
            'transaction_id' => '1000000381910263',
            'quantity' => '1',
            'web_order_line_item_id' => '1000000038010278',
            'original_purchase_date_ms' => '1518255510000',
            'unique_vendor_identifier' => 'F118261D-1111-41C3-AF55-B79B99887DE9',
            'expires_date_formatted_pst' => '2018-03-11 12:35:12 America/Los_Angeles',
            'item_id' => '1726354637',
            'expires_date_formatted' => '2018-03-11 19:35:12 Etc/GMT',
            'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
            'product_id' => 'com.test.product',
            'purchase_date' => '2018-03-11 19:30:12 Etc/GMT',
            'is_trial_period' => 'false',
            'purchase_date_pst' => '2018-03-11 12:30:12 America/Los_Angeles',
            'bid' => 'com.org.app',
            'bvrs' => '7'
          },
          'environment' => 'Sandbox',
          'auto_renew_status' => 'true',
          'password' => 'aiduad9889heiuau7yuguyg2eieuwiuhw',
          'auto_renew_product_id' => 'com.test.product',
          'notification_type' => 'INTERACTIVE_RENEWAL'
        }
      end

      let(:notification) do
        Venice::ItcSubscriptionNotification.new receipt_notif_json
      end

      subject { notification }

      its(:original_json_response) { should eq receipt_notif_json }
      its(:latest_receipt) { should eq '<receipt-data>' }
      its(:environment) { should eq 'Sandbox' }
      its(:latest_receipt_info) { should be_instance_of Venice::InAppReceipt }
      its(:auto_renew_status) { should eq 'true' }
      its(:auto_renew_product_id) { should eq 'com.test.product' }
      its(:notification_type) {
        should eq Venice::ItcSubscriptionNotification::NotificationType::INTERACTIVE_RENEWAL
      }
      its("latest_receipt_info.original.transaction_id") {
        should eq '1000000375019271'
      }
      its(:original_transaction_id) { should eq '1000000375019271' }
    end

    describe 'with expired receipt info' do
      let(:expired_receipt_notif_json) do
        {
          'latest_expired_receipt' => '<receipt-data>',
          'latest_expired_receipt_info' => {
            'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
            'is_in_intro_offer_period' => 'false',
            'purchase_date_ms' => '9863298112000',
            'unique_identifier' => 'auaiuheiuyi82i3iuweyiweyiuweiwueiuyiwueyiuwye',
            'original_transaction_id' => '1000000876957628',
            'expires_date' => '1520711442000',
            'transaction_id' => '1000000381989898',
            'quantity' => '1',
            'web_order_line_item_id' => '1000000038011888',
            'original_purchase_date_ms' => '1511927110000',
            'unique_vendor_identifier' => '1FFBF6FC-8BCC-4AB0-81F0-C2104A07E0B3',
            'expires_date_formatted_pst' => '2018-03-11 13:00:12 America/Los_Angeles',
            'item_id' => '1159952388',
            'expires_date_formatted' => '2018-03-11 20:00:12 Etc/GMT',
            'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
            'product_id' => 'com.test.product',
            'purchase_date' => '2018-03-11 19:55:12 Etc/GMT',
            'is_trial_period' => 'false',
            'purchase_date_pst' => '2018-03-11 12:55:12 America/Los_Angeles',
            'bid' => 'com.org.app',
            'bvrs' => '7'
          },
          'environment' => 'Sandbox',
          'auto_renew_status' => 'false',
          'password' => 'aiduad9889heiuau7yuguyg2eieuwiuhw',
          'auto_renew_product_id' => 'com.test.product',
          'notification_type' => 'INTERACTIVE_RENEWAL'
        }
      end

      let(:notification) do
        Venice::ItcSubscriptionNotification.new expired_receipt_notif_json
      end

      subject { notification }

      its(:original_json_response) { should eq expired_receipt_notif_json }
      its(:latest_receipt) { should eq '<receipt-data>' }
      its(:environment) { should eq 'Sandbox' }
      its(:latest_receipt_info) { should be_instance_of Venice::InAppReceipt }
      its(:auto_renew_status) { should eq 'false' }
      its(:auto_renew_product_id) { should eq 'com.test.product' }
      its(:notification_type) {
        should eq Venice::ItcSubscriptionNotification::NotificationType::INTERACTIVE_RENEWAL
      }
      its("latest_receipt_info.original.transaction_id") {
        should eq '1000000876957628'
      }
      its(:original_transaction_id) { should eq '1000000876957628' }
    end
  end
end
