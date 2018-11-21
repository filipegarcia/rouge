# -*- coding: utf-8 -*- #
# frozen_string_literal: true

describe Rouge::Lexers::Switfmessage do
  let(:subject) { Rouge::Lexers::Switfmessage.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo'
    end

    it 'guesses by mimetype' do
      assert_guess :mimetype => 'text/swift'
    end
  end
end
