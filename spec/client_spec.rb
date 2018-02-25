require 'spec_helper'

describe Venice::Client do
  let(:receipt_data) { 'asdfzxcvjklqwer' }
  let(:client) { Venice::Client.development }
  let(:headers) { {
    'Accept'=>'application/json',
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Content-Type'=>'application/json',
    'User-Agent'=>'Ruby'
  } }

  describe '#verify!' do
    let(:response) do
      Venice::ItcVerificationResponse.new({
        'status' => 0,
        'receipt' => {}
      })
    end

    before do
      client.stub(:response_from_verifying_data!).and_return(response)
    end

    let(:itc_response) { client.verify('asdf') }

    it 'should create the itc verification response' do
      itc_response.should_not be_nil
    end
  end

  describe "#verify!" do

    let(:response) do
      Venice::ItcVerificationResponse.new({
        'status' => 0,
        'receipt' => {}
      })
    end

    context "with no verification_url" do
      it "should raise error" do
        client.verification_url = nil
        expect { client.verify!("foo") }.to raise_error(Venice::Client::NoVerificationEndpointError)
      end
    end

    context 'with a receipt response' do
      before do
        client.stub(:response_from_verifying_data!).and_return(response)
      end

      it 'does not generate a self-referencing Hash' do
        response = client.verify! 'asdf'
        expect(response.original_json_response['receipt']).not_to have_key('original_json_response')
      end
    end

    context 'no shared_secret' do
      before do
        client.shared_secret = nil
        Venice::ItcVerificationResponse.stub(:new).and_return(:response)
      end

      it 'should only include the receipt_data' do
        stub_request(:post, client.verification_url).
        to_return(status: 200, body: "{\"status\":0}", headers: {})

        client.verify! receipt_data

        expect(a_request(:post, client.verification_url).
        with(
          body: {
            'receipt-data' => receipt_data,
          },
          headers: headers)).
        to have_been_made.once
      end
    end

    context 'with a shared secret' do
      let(:secret) { 'shhhhhh' }

      before do
        Venice::ItcVerificationResponse.stub(:new).and_return(:response)
      end

      context 'set secret manually' do
        before do
          client.shared_secret = secret
        end

        it 'should include the secret in the post' do
          stub_request(:post, client.verification_url).
          to_return(status: 200, body: "{\"status\":0}", headers: {})

          client.verify! receipt_data

          expect(a_request(:post, client.verification_url).
          with(
            body: {
              'receipt-data' => receipt_data,
              'password' => secret
            },
            headers: headers)).
          to have_been_made.once
        end
      end

      context 'set secret when verification' do
        let(:options) { { shared_secret: secret } }

        before do
          client.shared_secret = nil
        end

        it 'should include the secret in the post' do
          stub_request(:post, client.verification_url).
          to_return(status: 200, body: "{\"status\":0}", headers: {})

          client.verify! receipt_data, options

          expect(a_request(:post, client.verification_url).
          with(
            body: {
              'receipt-data' => receipt_data,
              'password' => secret
            },
            headers: headers)).
          to have_been_made.once
        end
      end
    end

    context 'with a latest receipt info attribute' do
      let(:response) do
        Venice::ItcVerificationResponse.new({
          'status' => 0,
          'receipt' => {},
          'latest_receipt' => '<encoded string>',
          'latest_receipt_info' =>  [
            {
              'original_purchase_date_pst' => '2012-12-30 09:39:24 America/Los_Angeles',
              'unique_identifier' => '0000b01147b8',
              'original_transaction_id' => '1000000061051565',
              'expires_date' => '1365114731000',
              'transaction_id' => '1000000070104252',
              'quantity' => '1',
              'product_id' => 'com.ficklebits.nsscreencast.monthly_sub',
              'original_purchase_date_ms' => '1356889164000',
              'bid' => 'com.ficklebits.nsscreencast',
              'web_order_line_item_id' => '1000000026812043',
              'bvrs' => '0.1',
              'expires_date_formatted' => '2013-04-04 22:32:11 Etc/GMT',
              'purchase_date' => '2013-04-04 22:27:11 Etc/GMT',
              'purchase_date_ms' => '1365114431000',
              'expires_date_formatted_pst' => '2013-04-04 15:32:11 America/Los_Angeles',
              'purchase_date_pst' => '2013-04-04 15:27:11 America/Los_Angeles',
              'original_purchase_date' => '2012-12-30 17:39:24 Etc/GMT',
              'item_id' => '590265423'
            }
          ]
        })
      end

      before do
        client.stub(:response_from_verifying_data!).and_return(response)
      end

      it 'should create a latest receipt' do
        res = client.verify! 'asdf'
        res.latest_receipt_info.first.product_id.should eq 'com.ficklebits.nsscreencast.monthly_sub'
      end
    end

    context 'with an error response' do
      it 'raises a VerificationError' do
        stub_request(:post, client.verification_url).
        to_return(status: 200, body: "{\"status\":21000}", headers: {})

        expect do
          client.verify! 'asdf'
        end.to raise_error(Venice::VerificationError) do |error|
          expect(error.json).to eq(response)
          expect(error.code).to eq(21000)
          expect(error).not_to be_retryable
        end
      end
    end

    context 'with a retryable error response' do
      it 'raises a VerificationError' do
        stub_request(:post, client.verification_url).
        to_return(
          status: 200,
          body: "{\"status\":21000, \"is-retryable\": true}",
          headers: {}
        )

        expect do
          client.verify!('asdf')
        end.to raise_error(Venice::VerificationError) do |error|
          expect(error).to be_retryable
        end
      end
    end
  end
end
