require 'test_helper'

describe Enlace::Fiscal::Payment do
  let(:payment) { Enlace::Fiscal::Payment.new }

  describe 'has attributes' do
    [:payment_method, :account_number, :details].each do |attribute|
      it "##{attribute.to_s}" do
        payment.must_respond_to attribute
      end
    end
  end

  describe 'validations' do
    it 'is valid' do
      payment.account_number = '1111'

      payment.must_be :valid?
    end

    it 'is invalid' do
      payment.tap do |p|
        p.payment_method = nil
        p.details = nil
      end

      payment.wont_be :valid?
      payment.errors.length.must_equal 2
    end

    it 'is invalid when payment option is not valid' do
      payment.payment_method = :invalid

      payment.wont_be :valid?
      payment.errors.length.must_equal 1
    end

    it 'is invalid when account number is not present when payment option require it' do
      payment.payment_method = :credit

      payment.wont_be :valid?
      payment.errors.length.must_equal 1
    end
  end
end
