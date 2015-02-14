require 'test_helper'

describe Enlace::Fiscal::Invoice do
  let(:invoice) {
    Enlace::Fiscal::Invoice.new.tap do |i|
      i.serie = 'GA'
      i.folio = 1
      i.date = Date.today
      i.subtotal = 1.0
      i.total = 1.0
      i.tax_translated_total = 0
      i.tax_retained_total = 0
      i.rfc = 'RFCT800101TR4'
    end
  }

  describe 'has attributes' do
    [:serie, :folio, :date, :subtotal, :total, :rfc, :valid?,
     :payment, :receptor, :lines, :taxes, :tax_retained_total,
     :tax_translated_total].each do |attribute|
      it "##{attribute.to_s}" do
        invoice.must_respond_to attribute
      end
    end
  end

  describe 'validations' do
    it 'is valid' do

      invoice.must_be :valid?
    end

    it 'is invalid' do
      Enlace::Fiscal::Invoice.new.wont_be :valid?
    end

    it 'is invalid when subtotal or total is less than zero' do
      invoice.tap do |i|
        i.subtotal = -1.0
        i.total = -1.0
        i.tax_translated_total = -1.0
        i.tax_retained_total = -1.0
      end

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 4
    end

    it 'is invalid if rfc format is invalid' do
      invoice.rfc = 'RFC'

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 1
    end

    it 'is invalid if rfc length is invalid' do
      invoice.rfc = 'RFCT800101TR478'

      invoice.wont_be :valid?
      invoice.errors.size.must_equal 1
    end
  end

  describe 'lines' do
    it 'add' do
      invoice.add_line

      invoice.lines.length.must_equal 2
    end

    it 'delete' do
      invoice.add_line
      invoice.delete_line_at(1)

      invoice.lines.length.must_equal 1
    end
  end

  describe 'taxes' do
    it 'add' do
      invoice.add_tax

      invoice.taxes.length.must_equal 2
    end

    it 'delete' do
      invoice.add_tax
      invoice.delete_tax_at(1)

      invoice.taxes.length.must_equal 1
    end
  end

  describe 'global valid' do
    it 'is invalid' do
      invoice.wont_be :valid_all?

      invoice.errors.length.must_equal 14
    end

    it 'is valid' do
      invoice.tap do |i|
        i.serie = 'GA'
        i.folio = 1
        i.date = Date.today
        i.subtotal = 1.0
        i.total = 1.0
        i.tax_translated_total = 0
        i.tax_retained_total = 0
        i.rfc = 'RFCT800101TR4'

        i.payment.tap do |p|
          p.account_number = '1123'
        end

        i.receptor.tap do |r|
          r.name = 'Client'
          r.rfc = 'TRYD850610YUI'
          r.street = 'Known street'
          r.state = 'Known state'
        end

        i.lines.first.tap do |l|
          l.quantity = 1
          l.unit = :piece
          l.description = 'Sample product'
          l.unit_price = 10
          l.total = 10
        end

        i.taxes.first.tap do |t|
          t.type = :iva
          t.kind = :retained
          t.total = 1.6
          t.rate = 16
        end
      end

      invoice.must_be :valid_all?
    end
  end
end
