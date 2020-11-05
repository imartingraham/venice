require 'spec_helper'

describe Venice::ItcSubscriptionNotification do
  describe 'parses the apple app store subscription notification' do
    let(:receipt_notif_json) do
      {
        'auto_renew_product_id' => 'com.test.product',
        'auto_renew_status' => 'true',
        'auto_renew_status_change_date' => '2020-11-05T15:56:58+0000',
        'auto_renew_status_change_date_ms' => '123456789',
        'environment' => 'Sandbox',
        'password' => 'aiduad9889heiuau7yuguyg2eieuwiuhw',
        'notification_type' => 'INTERACTIVE_RENEWAL',
        'expiration_intent' => 'Something here',
        'unified_receipt' => {
          'latest_receipt' => '<receipt-data>',
          'latest_receipt_info' => [
            {
              'cancellation_date' => '2020-11-06T15:56:58+0000',
              'cancellation_date_ms' => '1518255510000',
              'cancellation_reason' => 'Some reason here',
              'expires_date' => '1520796912000',
              'expires_date_ms' => '1520796912000',
              'is_in_intro_offer_period' => 'false',
              'is_trial_period' => 'false',
              'is_upgraded' => 'true',
              'original_purchase_date' => '2020-10-02T15:56:58+0000',
              'original_purchase_date_ms' => '1518255510000',
              'original_transaction_id' => '1000000375019271',
              'promotional_offer_id' => 'com.promotion.id',
              'product_id' => 'com.test.product',
              'purchase_date' => '2020-11-02T15:56:58+0000',
              'purchase_date_ms' => '1520796612000',
              'quantity' => '1',
              'subscription_group_identifier' => 'sub.groud.id',
              'transaction_id' => '1000000381910263',
              'web_order_line_item_id' => '1000000038010278'
            },
            {
              'cancellation_date' => '2020-09-06T15:56:58+0000',
              'cancellation_date_ms' => '1518255510001',
              'cancellation_reason' => 'Some reason here',
              'expires_date' => '1520796912001',
              'expires_date_ms' => '1520796912001',
              'is_in_intro_offer_period' => 'false',
              'is_trial_period' => 'false',
              'is_upgraded' => 'true',
              'original_purchase_date' => '2020-08-02T15:56:58+0000',
              'original_purchase_date_ms' => '1518255510001',
              'original_transaction_id' => '1000000375019272',
              'promotional_offer_id' => 'com.promotion.id',
              'product_id' => 'com.test.product',
              'purchase_date' => '2020-09-02T15:56:58+0000',
              'purchase_date_ms' => '1520796612001',
              'quantity' => '1',
              'subscription_group_identifier' => 'sub.groud.id',
              'transaction_id' => '1000000381910264',
              'web_order_line_item_id' => '1000000038010279'
            }
          ],
          'pending_renewal_info' => [
            {
              'auto_renew_product_id' => 'com.foo.product1',
              'original_transaction_id' => '37xxxxxxxxx89',
              'product_id' => 'com.foo.product1',
              'auto_renew_status' => '0',
              'is_in_billing_retry_period' => '0',
              'expiration_intent' => '1',
              'grace_period_expires_date' => '2020-10-02T15:56:58+0000',
              'grace_period_expires_date_ms' => '1518255510001',
              'price_consent_status' => '1'
            }
          ],
          'environment' => 'Sandbox'
        }
      }
    end

    let(:notification) do
      Venice::ItcSubscriptionNotification.new receipt_notif_json
    end

    describe 'has expected attributes' do
      subject { notification }

      its(:original_json_response) { should eq receipt_notif_json }
      its(:latest_receipt) { should eq '<receipt-data>' }
      its(:environment) { should eq 'Sandbox' }
      its(:unified_receipt) { should be_instance_of Venice::UnifiedReceipt }
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
    
    describe 'with unified_receipt.latest_receipt_info' do
      subject { notification }

      its('unified_receipt.latest_receipt_info') { should be_instance_of Array }
    end

    describe 'with unified_receipt.pending_renewal_info' do
      subject { notification }

      its('unified_receipt.pending_renewal_info') { should be_instance_of Array }
    end
  end
end
