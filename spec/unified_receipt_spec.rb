require 'spec_helper'

describe Venice::UnifiedReceipt do
  describe '.new' do
    let(:json) do
      {
        'environment' => 'foo',
        'latest_receipt' => 'aksjdhfiw83yiohwli8whefilw8e4fiuks',
        'latest_receipt_info' => [{
          'transaction_id' => '37xxxxxxxxx88',
          'original_transaction_id' => '37xxxxxxxxx89',
        }],
        'pending_renewal_info' => [{
          'auto_renew_product_id' => 'com.foo.product1',
          'original_transaction_id' => '37xxxxxxxxx89',
          'product_id' => 'com.foo.product1',
          'auto_renew_status' => '0',
          'is_in_billing_retry_period' => '0',
          'expiration_intent' => '1'
        }],
        'status' => 0
      }
    end

    subject { described_class.new(json) }
    
    its(:environment) { should eq 'foo' }
    its(:latest_receipt) { should eq 'aksjdhfiw83yiohwli8whefilw8e4fiuks' }
    its(:latest_receipt_info) { should be_instance_of Array }
    its(:pending_renewal_info) { should be_instance_of Array }
    its(:status) { should eq 0 }

  end
end
