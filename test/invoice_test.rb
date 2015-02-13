require 'test_helper'

describe Enlace::Fiscal::Invoice do
  let(:invoice) { Enlace::Fiscal::Invoice.new }

  describe 'has attributes' do
    [:serie, :folio, :date, :subtotal, :total, :rfc, :valid?,
     :payment, :receptor, :lines].each do |attribute|
      it "##{attribute.to_s}" do
        invoice.must_respond_to attribute
      end
    end
  end

  describe 'validations' do
    it 'is valid' do
      invoice.tap do |i|
        i.serie = 'GA'
        i.folio = 1
        i.date = Date.today
        i.subtotal = 1.0
        i.total = 1.0
        i.rfc = 'RFCT800101TR4'
      end

      invoice.must_be :valid?
    end

    it 'is invalid' do
      invoice.wont_be :valid?
    end

    it 'is invalid when subtotal or total is less than zero' do
      invoice.tap do |i|
        i.serie = 'GA'
        i.folio = 1
        i.date = Date.today
        i.subtotal = -1.0
        i.total = -1.0
        i.rfc = 'RFCT800101TR4'
      end

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 2
    end

    it 'is invalid if rfc format is invalid' do
      invoice.tap do |i|
        i.serie = 'GA'
        i.folio = 1
        i.date = Date.today
        i.subtotal = 1.0
        i.total = 1.0
        i.rfc = 'RFC'
      end

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 1
    end

    it 'is invalid if rfc length is invalid' do
      invoice.tap do |i|
        i.serie = 'GA'
        i.folio = 1
        i.date = Date.today
        i.subtotal = 1.0
        i.total = 1.0
        i.rfc = 'RFCT800101TR478'
      end

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 1
    end
  end
end
