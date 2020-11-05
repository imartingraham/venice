require 'spec_helper'

describe Venice::Receipt do
  describe 'parsing the response' do
    let(:client) { Venice::Client.development }
    let(:response) do
      Venice::ItcVerificationResponse.new({
         'status' => 0,
         'environment' => 'Sandbox',
         'receipt' => {
            'receipt_type' => 'ProductionSandbox',
            'adam_id' => 7654321,
            'app_item_id' => 0,
            'bundle_id' => 'com.test.appid',
            'application_version' => '7',
            'download_id' => 1234567,
            'version_external_identifier' => 0,
            'receipt_creation_date' => '2018-02-18 18:19:15 Etc/GMT',
            'receipt_creation_date_ms' => '1518977955000',
            'receipt_creation_date_pst' => '2018-02-18 10:19:15 America/Los_Angeles',
            'request_date' => '2018-02-18 18:19:21 Etc/GMT',
            'request_date_ms' => '1518977961785',
            'request_date_pst' => '2018-02-18 10:19:21 America/Los_Angeles',
            'original_purchase_date' => '2013-08-01 07:00:00 Etc/GMT',
            'original_purchase_date_ms' => '1375340400000',
            'original_purchase_date_pst' => '2013-08-01 00:00:00 America/Los_Angeles',
            'original_application_version' => '1.0',
            'expiration_date' => '2020-08-01 00:00:00 America/Los_Angeles',
            'in_app' => [
               {
                  'quantity' => '1',
                  'product_id' => 'com.test.in_app.productid',
                  'transaction_id' => '1000000375057628',
                  'original_transaction_id' => '1000000375057628',
                  'purchase_date' => '2018-02-11 20:55:08 Etc/GMT',
                  'purchase_date_ms' => '1518382508000',
                  'purchase_date_pst' => '2018-02-11 12:55:08 America/Los_Angeles',
                  'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
                  'original_purchase_date_ms' => '1518382510000',
                  'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
                  'expires_date' => '2018-02-11 21:00:08 Etc/GMT',
                  'expires_date_ms' => '1518382808000',
                  'expires_date_pst' => '2018-02-11 13:00:08 America/Los_Angeles',
                  'web_order_line_item_id' => '1000000037792870',
                  'is_trial_period' => 'false',
                  'is_in_intro_offer_period' => 'false'
               },
               {
                  'quantity' => '1',
                  'product_id' => 'com.test.in_app.productid',
                  'transaction_id' => '1000000375057773',
                  'original_transaction_id' => '1000000375057628',
                  'purchase_date' => '2018-02-11 21:00:41 Etc/GMT',
                  'purchase_date_ms' => '1518382841000',
                  'purchase_date_pst' => '2018-02-11 13:00:41 America/Los_Angeles',
                  'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
                  'original_purchase_date_ms' => '1518382510000',
                  'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
                  'expires_date' => '2018-02-11 21:05:41 Etc/GMT',
                  'expires_date_ms' => '1518383141000',
                  'expires_date_pst' => '2018-02-11 13:05:41 America/Los_Angeles',
                  'web_order_line_item_id' => '1000000037792871',
                  'is_trial_period' => 'false',
                  'is_in_intro_offer_period' => 'false'
               },
               {
                  'quantity' => '1',
                  'product_id' => 'com.test.in_app.productid',
                  'transaction_id' => '1000000375058263',
                  'original_transaction_id' => '1000000375057628',
                  'purchase_date' => '2018-02-11 21:06:40 Etc/GMT',
                  'purchase_date_ms' => '1518383200000',
                  'purchase_date_pst' => '2018-02-11 13:06:40 America/Los_Angeles',
                  'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
                  'original_purchase_date_ms' => '1518382510000',
                  'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
                  'expires_date' => '2018-02-11 21:11:40 Etc/GMT',
                  'expires_date_ms' => '1518383500000',
                  'expires_date_pst' => '2018-02-11 13:11:40 America/Los_Angeles',
                  'web_order_line_item_id' => '1000000037792890',
                  'is_trial_period' => 'false',
                  'is_in_intro_offer_period' => 'false'
               }
            ]
         },
         'latest_receipt_info' => [
            {
               'quantity' => '1',
               'product_id' => 'com.test.latest_receipt_info.productid',
               'transaction_id' => '1000000375057628',
               'original_transaction_id' => '1000000375057628',
               'purchase_date' => '2018-02-11 20:55:08 Etc/GMT',
               'purchase_date_ms' => '1518382508000',
               'purchase_date_pst' => '2018-02-11 12:55:08 America/Los_Angeles',
               'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
               'original_purchase_date_ms' => '1518382510000',
               'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
               'expires_date' => '2018-02-11 21:00:08 Etc/GMT',
               'expires_date_ms' => '1518382808000',
               'expires_date_pst' => '2018-02-11 13:00:08 America/Los_Angeles',
               'web_order_line_item_id' => '1000000037792870',
               'is_trial_period' => 'false',
               'is_in_intro_offer_period' => 'false'
            },
            {
               'quantity' => '1',
               'product_id' => 'com.test.latest_receipt_info.productid',
               'transaction_id' => '1000000375057773',
               'original_transaction_id' => '1000000375057628',
               'purchase_date' => '2018-02-11 21:00:41 Etc/GMT',
               'purchase_date_ms' => '1518382841000',
               'purchase_date_pst' => '2018-02-11 13:00:41 America/Los_Angeles',
               'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
               'original_purchase_date_ms' => '1518382510000',
               'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
               'expires_date' => '2018-02-11 21:05:41 Etc/GMT',
               'expires_date_ms' => '1518383141000',
               'expires_date_pst' => '2018-02-11 13:05:41 America/Los_Angeles',
               'web_order_line_item_id' => '1000000037792871',
               'is_trial_period' => 'false',
               'is_in_intro_offer_period' => 'false'
            },
            {
               'quantity' => '1',
               'product_id' => 'com.test.latest_receipt_info.productid',
               'transaction_id' => '1000000375058263',
               'original_transaction_id' => '1000000375057628',
               'purchase_date' => '2018-02-11 21:06:40 Etc/GMT',
               'purchase_date_ms' => '1518383200000',
               'purchase_date_pst' => '2018-02-11 13:06:40 America/Los_Angeles',
               'original_purchase_date' => '2018-02-11 20:55:10 Etc/GMT',
               'original_purchase_date_ms' => '1518382510000',
               'original_purchase_date_pst' => '2018-02-11 12:55:10 America/Los_Angeles',
               'expires_date' => '2018-02-11 21:11:40 Etc/GMT',
               'expires_date_ms' => '1518383500000',
               'expires_date_pst' => '2018-02-11 13:11:40 America/Los_Angeles',
               'web_order_line_item_id' => '1000000037792890',
               'is_trial_period' => 'false',
               'is_in_intro_offer_period' => 'false'
            }
         ],
         'latest_receipt' => '<receipt-data>',
         'pending_renewal_info' => [
            {
               'auto_renew_product_id' => 'com.test.productid',
               'original_transaction_id' => '1000000375057628',
               'product_id' => 'com.test.productid',
               'auto_renew_status' => '1',
               'is_in_billing_retry_period' => '0'
            }
         ]
      })
    end

    describe '#verify! receipt' do
      before do
        expect(client).to receive(:response_from_verifying_data!).and_return(response)
      end

      subject { client.verify('asdf').receipt }

      its(:bundle_id) { should eq 'com.test.appid' }
      its(:application_version) { should eq '7' }
      its(:in_app) { should be_instance_of Array }
      its(:original_application_version) { should eq '1.0' }
      its(:original_purchase_date) { should be_instance_of DateTime }
      its(:expires_date) { should be_instance_of DateTime }
      its(:receipt_type) { should eq 'ProductionSandbox' }
      its(:adam_id) { should eq 7654321 }
      its(:download_id) { should eq 1234567 }
      its(:requested_at) { should be_instance_of DateTime }
    end
  end
end
