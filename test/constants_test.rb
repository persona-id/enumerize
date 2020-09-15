# frozen_string_literal: true

require 'test_helper'

describe Enumerize::Constants do
  let(:kklass) do
    Class.new do
      extend Enumerize
    end
  end

  let(:object) { kklass.new }

  it 'creates constants' do
    kklass.enumerize(:foo, in: %w(a b), constants: true)
    kklass.constants.must_include(:FOO_A, :FOO_B)
    kklass::FOO_A.must_equal 'a'
    kklass::FOO_B.must_equal 'b'
  end

  it 'creates constants when enumerized values have dash in it' do
    kklass.enumerize(:foo, in: %w(bar-a bar-b), constants: true)
    kklass.constants.must_include(:FOO_BAR_A, :FOO_BAR_B)
    kklass::FOO_BAR_A.must_equal 'bar-a'
    kklass::FOO_BAR_B.must_equal 'bar-b'
  end

  it 'creates constants with prefix' do
    kklass.enumerize(:foo, in: %w(a b), constants: { prefix: 'BAZ' })
    kklass.constants.must_include(:BAZ_A, :BAZ_B)
    kklass::BAZ_A.must_equal 'a'
    kklass::BAZ_B.must_equal 'b'
  end

  it 'accepts only option' do
    kklass.enumerize(:foo, in: %w(a b), constants: { only: :a })
    kklass.constants.must_include(:FOO_A)
    kklass.constants.wont_include(:FOO_B)
    kklass::FOO_A.must_equal 'a'
  end

  it 'accepts except option' do
    kklass.enumerize(:foo, in: %w(a b), constants: { except: :a })
    kklass.constants.must_include(:FOO_B)
    kklass.constants.wont_include(:FOO_A)
    kklass::FOO_B.must_equal 'b'
  end
end
