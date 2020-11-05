require 'spec_helper'

describe Venice::PendingRenewalInfo do
  describe '.new' do
    let(:attributes) do
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
    end

    subject { described_class.new(attributes) }

    its(:expiration_intent) { should eq 1 }
    its(:auto_renew_status) { should eq 0 }
    its(:auto_renew_product_id) { should eq  'com.foo.product1' }
    its(:is_in_billing_retry_period) { should eq false }
    its(:product_id) { should eq 'com.foo.product1' }

    it 'outputs attributes in hash' do
      expect(subject.to_hash).to eql(
        expiration_intent: 1,
        auto_renew_status: 0,
        auto_renew_product_id: 'com.foo.product1',
        is_in_billing_retry_period: false,
        product_id: 'com.foo.product1',
        price_consent_status: '1',
        grace_period_expires_date: '2020-10-02T15:56:58+00:00',
        grace_period_expires_date_ms: '1518255510001',
        original_transaction_id: '37xxxxxxxxx89'
      )
    end
  end
end
