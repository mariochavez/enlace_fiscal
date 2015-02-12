require 'test_helper'

describe Enlace::Fiscal::Invoice do
  let(:invoice) { Enlace::Fiscal::Invoice.new }

  describe 'has attributes' do
    it '#serie' do
      invoice.must_respond_to :serie
    end

    it '#folio' do
      invoice.must_respond_to :folio
    end

    it '#date' do
      invoice.must_respond_to :date
    end

    it '#subtotal' do
      invoice.must_respond_to :subtotal
    end

    it '#total' do
      invoice.must_respond_to :total
    end

    it '#rfc' do
      invoice.must_respond_to :rfc
    end

    it '#valid?' do
      invoice.must_respond_to :valid?
    end

    it '#payment' do
      invoice.must_respond_to :payment
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
